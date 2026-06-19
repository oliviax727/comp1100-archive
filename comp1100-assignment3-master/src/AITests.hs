-- 80 chars
-- M1tWLm3QqaIUR1kzWjBK1ddqkqZlHi6gdswvOHQchJQwsTTEhf1PeIiHvYnMgv99h4EyBSvYGdnU

{-|
Module      : AITests
Description : Tests for your AI functions
Copyright   : (c) 2020 Your Name Here
License     : AllRightsReserved
-}
module AITests where

import           AI
import           Othello
import           Testing
import           Eliminator

aiTests :: Test
aiTests = TestGroup "AI" $
  infTests
  ++ hTests
  ++ abpTests

-- | Tests if inf is the upper bound
infTests :: [Test]
infTests =
  [ Test "inf is upper bound" $ assertEqual (inf + (inf + 1)) (-1)
  , Test "inf is 64-bit limit"
  $ assertEqual (toInteger inf) ((2^(63 :: Integer) - 1) :: Integer)
  ]

-- | Tests to determine if simpleHeuristic/heuristic is working
hTests :: [Test]
hTests =
  [ Test "simple heuristic on initialBoard"
  $ assertEqual
    (simpleHeuristic (Just $ initialState (8, 8)) True) 2
  , Test "simple heuristic on no states/draws"
  $ assertEqual
    (simpleHeuristic Nothing True)
    (simpleHeuristic
      (Just $ GameState (8,8) (GameOver Draw) (initialBoard (8,8))) True
    )
  , Test "simple heuristic on wins"
  $ assertEqual
  (simpleHeuristic
    (Just $ GameState (8,8) (GameOver $ Winner Player1) (initialBoard (8,8)))
    True) inf
  , Test "heuristic on initialBoard"
  $ assertEqual (
    heuristic (Just $ initialState (8, 8)) True
    ) 0
  , Test "bias function on corners"
  $ assertApproxEqual (bias (100, 100) (99, 99)) 1 0.02
  , Test "bias function on central edge"
  $ assertApproxEqual (bias (101, 101) (100, 50)) 0 0.02
  , Test "bias function on near-centre"
  $ assertApproxEqual (bias (100, 100) (50, 50)) 1 0.02
  , Test "amplitude function"
  $ assertNotEqual
    (amp 8 (Just Player1) (Just Player1)) (amp 8 (Just Player1) (Just Player2))
  , Test "summation of an irregular board"
  $ assertEqual (sumBoard 5 [[1, 1], [], [1, 1, 1], [1]]) 300000
  ]

-- | Testing the ABP function
abpTests :: [Test]
abpTests =
  [ Test "ABP on initial state" $
  assertEqual
    (headABPrune simpleHeuristic 5 (Node (Just $ initialState (8,8)) [])) 3
  , Test "AI algorithim on initial state" $
  assertEqual (abpai heuristic (initialState (8,8)) 5) (Move (3,2))
  , Test "ABP on Gameover state" $
  assertEqual (
    headABPrune heuristic 5
      (Node (Just $ GameState (8,8) (GameOver Draw) (initialBoard (8,8))) [])
    ) inf
  ]