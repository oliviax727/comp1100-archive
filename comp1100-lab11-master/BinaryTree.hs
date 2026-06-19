module BinaryTree where

type BSTree a = BinaryTree a

data BinaryTree a = Null | Node (BinaryTree a) a (BinaryTree a)
    deriving Show


{-
Exercise 5

Copy in your solutions from Lab 09 and Lab 10
(or finish them off if you haven't)

State the complexity class of each function.
They should be written as efficently as possible.
-}

-- Copy in your solutions from Lab 09

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
treeSize :: BinaryTree a -> Integer
treeSize Null = 0
treeSize (Node left _ right) = 1 + treeSize right + treeSize left

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
treeDepth :: BinaryTree a -> Integer
treeDepth Null = 0
treeDepth (Node left _ right) = 1 + max (treeDepth left) (treeDepth right)

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n^2)
flattenTree :: BinaryTree a -> [a]
flattenTree Null = []
flattenTree (Node left x right) = x : (flattenTree left ++ flattenTree right)

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n^2)
leavesTree :: BinaryTree a -> [a]
leavesTree Null = []
leavesTree (Node Null x Null) = [x]
leavesTree (Node left _ right) = leavesTree left ++ leavesTree right

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
treeMap :: (a -> b) -> BinaryTree a -> BinaryTree b
treeMap f (Node left x right) = Node (treeMap f left) (f x) (treeMap f right)
treeMap _ Null = Null


-- Copy in your solutions from Lab 10

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
elemBSTree :: (Ord a) => a -> BSTree a -> Bool
elemBSTree _ Null = False
elemBSTree x (Node left y right)
  | x == y = True
  | x < y = elemBSTree x left
  | otherwise = elemBSTree x right

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
treeBSMax :: (Ord a) => BSTree a -> a
treeBSMax Null = error "Null input"
treeBSMax (Node Null x Null) = x
treeBSMax (Node _ _ right) = treeBSMax right

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
treeBSMin :: (Ord a) => BSTree a -> a
treeBSMin Null = error "Null input"
treeBSMin (Node Null x Null) = x
treeBSMin (Node left _ _) = treeBSMin left

-- Balanced tree: best O(1), worst O(n log n)
-- Any tree:      best O(1), worst O(n)
isBSTree :: (Ord a) => BinaryTree a -> Bool
isBSTree Null = True
isBSTree (Node left x right) = case (left, right) of
  (Null, Null) -> True
  (Node _ l _, Null) -> l < x && isBSTree left && isBSTree right
  (Null, Node _ r _) -> r > x && isBSTree left && isBSTree right
  (Node _ l _, Node _ r _) -> l < x && r > x && isBSTree left && isBSTree right

-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
treeInsert :: (Ord a) => BSTree a -> a -> BSTree a
treeInsert Null n = Node Null n Null
treeInsert (Node left x right) n
  | n > x = Node left x (treeInsert right n)
  | n < x = Node (treeInsert left n) x right
  | otherwise = Node left x right

-- Balanced tree: best O(1), worst O(n log n)
-- Any tree:      best O(1), worst O(n^2)
flattenTreeOrd :: BSTree a -> [a]
flattenTreeOrd Null = []
flattenTreeOrd (Node left x right) = flattenTreeOrd left ++ [x] ++ flattenTreeOrd right


-- =================================
-- Functions below are extensions
-- =================================

-- Balanced tree: best O(1), worst O(n log n)
-- Any tree:      best O(1), worst O(n^2)
treeDelete :: (Ord a) => (BSTree a) -> a -> (BSTree a)
treeDelete Null _ = Null
treeDelete (Node left x right) n
  | n > x = Node left x (treeDelete right n)
  | n < x = Node (treeDelete left n) x right
  | otherwise = case (left, right) of
    (Node {}, Null) -> left
    (Null, Node {}) -> right
    (Node ll l lr, Node {}) -> Node (Node ll l (treeDelete lr (treeBSMax lr))) (treeBSMax lr) right
    _ -> Null

-- This was an optional exercise, so if you haven't implemented treeBalance, 
-- don't worry about it.
-- Balanced tree: best O(?), worst O(?)
-- Any tree:      best O(?), worst O(?)
treeBalance :: (Ord a) => BSTree a -> BSTree a
treeBalance = undefined


{-
Module for drawing nice looking trees
David Quarel 13/02/2019

Don't worry too much about how this works,
or the types of these functions.
It's beyond the scope of this course.

Code modified from
http://hackage.haskell.org/package/containers-0.5.7.1/docs/src/Data.Tree.html#drawTree
-}

printTree :: (Show a) => BinaryTree a -> IO ()
printTree = putStr.unlines.draw

draw :: (Show a) => BinaryTree a -> [String]
draw Null = ["Null"]
draw (Node left x right) = (show x) : drawSubTrees [right,left]
  where
    drawSubTrees [] = []
    drawSubTrees [t] =
        "|" : shift "`- " "   " (draw t)
    drawSubTrees (t:ts) =
        "|" : shift "+- " "|  " (draw t) ++ drawSubTrees ts

    shift first other = zipWith (++) (first : repeat other)


notBSTree :: BinaryTree Integer
notBSTree = Node (Node (Node Null 1 Null) 3 (Node Null 2 Null))
                    5
                 (Node (Node Null 6 Null) 7 (Node Null 9 Null))

-- I've tried my best to textually display the tree in a nice way
-- Sorry if it's more confusing now

goodTree :: BSTree Integer
goodTree =  Node 
                (Node
                    (Node 
                        (Node 
                                Null 
                            1 
                                Null) 
                    3 
                        (Node 
                                Null 
                            5 
                                Null))
                7
                    (Node   
                        (Node 
                                Null 
                            10 
                                Null) 
                    12 
                        (Node 
                                Null 
                            13 
                                Null)))
            15

                (Node 
                    (Node
                        (Node 
                                Null 
                            16 
                                Null) 
                    17 
                        (Node 
                                Null 
                            18 
                                Null))
                23
                    (Node
                        (Node 
                                Null 
                            25 
                                Null) 
                    26 
                        (Node 
                                Null 
                            31 
                                Null)))

badTree :: BSTree Integer
badTree = Node (Node Null 1 Null) 3
            (Node (Node Null 5 Null) 7
                (Node (Node Null 10 Null) 12
                    (Node (Node Null 13 Null) 15
                        (Node (Node Null 16 Null) 17
                            (Node (Node Null 18 Null) 23
                                (Node (Node Null 25 Null) 26
                                        (Node Null 31 Null)))))))

smallTree :: BSTree Integer
smallTree = Node (Node Null 1 Null) 5 (Node Null 10 Null)
