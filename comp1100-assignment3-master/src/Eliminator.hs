-- 80 chars
-- M1tWLm3QqaIUR1kzWjBK1ddqkqZlHi6gdswvOHQchJQwsTTEhf1PeIiHvYnMgv99h4EyBSvYGdnU

module Eliminator where

import Othello

-- | Tree data types
data Tree a = Node a [Tree a] deriving Show
type GTree = Tree (Maybe GameState)
type HTree = Tree Double

-- | Arbitrary heuristic function
type Heuristic = (Maybe GameState -> Bool -> Int)

-- | Gets the best move out of a set of moves
maximize :: (Eq a, Ord a) => [Move] -> [a] -> Move
maximize moves hs = moves !! decide hs
  where
    decide :: (Eq a, Ord a) => [a] -> Int
    decide l = getIndex (maximum l) l

-- | Gets index of element
getIndex :: Eq a => a -> [a] -> Int
getIndex = index 0
  where
    index :: Eq a => Int -> a -> [a] -> Int
    index _ _ [] = -1
    index a y (x:xs) = if x == y then a else index (a + 1) y xs

{-
ALL CODE BEYOND THIS POINT DOES NOT DIRECTLY CONTRIBUTE TO THE DEFAULT AI
IT CONTAINS CODE THAT DOES NOT FUNCTION CORRECTLY AS IT HAS BEEN ABANDONED
HOWEVER, IT HAS STILL BEEN STYLED CORRECTLY AND USED AS BENCHMARKING AI
-}

-- | Performs a move
singleStateMove ::  Int -> GameState -> Move
singleStateMove n = makeMove . generateTree n

-- | Makes a move given the highest heuristic on a tree
makeMove :: GTree -> Move
makeMove gtree@(Node (Just gs) _) =
  maximize (legalMoves gs) $ collapse $ applyGH $ simpleHTree gtree
makeMove _ = undefined

-- | Collapses a HTree by taking all depth-1 nodes
collapse :: Tree a -> [a]
collapse (Node _ l) = foldr ((:) . getVal) [] l
  where
    getVal :: Tree a -> a
    getVal (Node a _) = a

-- | Generates a tree of depth n.
-- This function will only generate on nodes that have a heuristic
-- score greater than the current state, or if there is no better option,
-- the best remaining option. The depth of the tree at a node will affect
-- it's heuristic. once a node is generated, the function will move
-- onto lower depths.
generateTree :: Int -> GameState -> GTree
generateTree iterations gamestate =
  genNode iterations $ Node (Just gamestate) []
  where
    -- | Calculate all possible gamestates from a legal move
    nextStates :: Maybe GameState -> [GTree]
    nextStates (Just s) = map (gsToNode . applyMove s) $ legalMoves s
    nextStates Nothing = []

    -- | Converts a gamestate to a GTree node
    gsToNode :: Maybe GameState -> GTree
    gsToNode s = Node s []

    -- | Decides what nodes should further generated
    genTree :: Int -> (GTree, Double, Bool)  -> GTree
    genTree 0 (gnode, _, _) = gnode
    genTree n (Node next _, _, cond) =
      if cond
        then genNode n $ Node next []
        else Node next []

    -- | Creates a subordinate node for all
    -- possible gamestates after a parent node
    genNode :: Int -> GTree -> GTree
    genNode n (Node gs []) =
      Node gs $ map (genTree (n - 1)) (prune gs $ nextStates gs)
    genNode n (Node gs l) =
      Node gs $ map (genTree (n - 1)) (prune gs l)

    -- | Establishes the conditions for deciding
    -- whether to expand on a gamestate
    prune :: Maybe GameState -> [GTree] -> [(GTree, Double, Bool)]
    prune gs gsts =
      highlightMax $
        map (\x -> (x, (\(Node g _) -> singleHeuristic g) x, cond1 gs x)) gsts

    -- | Checks if a gamestate is better than the previous
    cond1 :: Maybe GameState -> GTree -> Bool
    cond1 upper (Node next _) = singleHeuristic upper < singleHeuristic next

    -- | Flags the best gamestate as clear to generate on
    highlightMax :: [(a, Double, Bool)] -> [(a, Double, Bool)]
    highlightMax l =
      (\n -> foldr (\(a, b, c) y -> (a, b, c || (b == n)) : y) [] l) $ myMax l

    -- | Gets the best immediate outcome from a set of GameStates
    myMax :: [(a, Double, Bool)] -> Double
    myMax ((_, x, _):xs) = foldr (\(_, a, _) b -> if a > b then a else b) x xs
    myMax _ = -1

-- | Collapses a HTree into a tree of depth 1
applyGH :: HTree -> HTree
applyGH (Node x y) = Node x (map (simpleGH False) y)

-- | A simple heuristic tree compiler
simpleGH :: Bool -> HTree -> HTree
simpleGH True (Node x xs) = Node (x + sumNodes (map (simpleGH False) xs)) []
simpleGH False (Node x xs) = Node (-(x + sumNodes (map (simpleGH True) xs))) []

-- | Sums the nodes of the tree below
sumNodes :: [HTree] -> Double
sumNodes [] = 0
sumNodes ((Node n _):ns) = n + sumNodes ns

-- | Maps the heuristic to all branches of the tree
simpleHTree :: GTree -> HTree
simpleHTree = roseMap singleHeuristic

-- | Maps a function onto a rose tree
roseMap :: (a -> b) -> Tree a -> Tree b
roseMap f (Node x []) = Node (f x) []
roseMap f (Node x xs) = Node (f x) (map (roseMap f) xs)

-- | Determines the value of a single GameState
singleHeuristic :: Maybe GameState -> Double
singleHeuristic (Just (GameState _ (Turn p) b)) =
  fromIntegral $ currentScore b p
singleHeuristic (Just (GameState _ (GameOver o) _)) = case o of
  Draw -> 0
  Winner Player2 -> 1e100
  Winner Player1 -> - 1e100
singleHeuristic Nothing = 0