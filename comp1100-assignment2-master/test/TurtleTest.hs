{-|
Module      : Main
Description : The tesing module component of Main
Maintainer  : u7280249@anu.edu.au

-}

module Main where

import Turtle
import Testing

-- | The list of tests to run.
tests :: [Test]
tests =
  [ testOne
  , testTwo
  , testThree
  , testFour
  , testFive
  ]

-- | Testing the Hilbert L-System for a order 2 curve
testOne :: Test
testOne =
  Test "Hilbert lv 2 test"
  (
    assertEqual (interpretLSystem hilbertSystem 2)
    [ P,N,A,F,P,B,F,B,P,F,A,N,F,N,P,B,F,N,A,F,A,N,F,B,P
    , F,P,B,F,N,A,F,A,N,F,B,P,N,F,N,A,F,P,B,F,B,P,F,A,N,P
    ]
  )

-- | Testing the Sierpinski L-System for a order 2 curve
testTwo :: Test
testTwo =
  Test "Sierpinski lv 2 test"
  (
    assertEqual (interpretLSystem sierpinskiSystem 2)
    [ T,F,A,T,P,F,A,N,T,N,F,A,P,F,F,A,A,T,F,A,T,P,F,A,N,T,N
    , F,A,P,P,F,F,A,A,N,T,F,A,T,P,F,A,N,T,N,F,A,P,N,F,F,A,A,P
    ]
  )

-- | Checks the ability for the hilbert function to convert an L-System to turtle commands
testThree :: Test
testThree =
  Test "L-System Tokens to Turtle Commands"
  (
    assertEqual (hilbert 1)
    [ PenDown, Turn (pi / 2), Forward, Turn (- pi / 2)
    , Forward, Turn (- pi / 2), Forward, Turn (pi / 2)
    ]
  )

-- | Tests if the polygon 3 is equal to a triangle
testFour :: Test
testFour =
  Test "Polygon/Triangle test" (assertEqual (triangle 2.5) (polygon 3 2.5))

-- | Tests the affectPen function
testFive :: Test
testFive =
  Test "Affect Pen"
  (
    assertEqual
    (
      affectPen (affectPen initialPen PenDown)
      (Turn (pi / 2))) (Pen (0, 0) (0, 0) pi 1.0 True
    )
  )

-- | A haskell program starts by running the computation defined by
-- 'main'. We run the list of tests that we defined above.
main :: IO ()
main = runTests tests
