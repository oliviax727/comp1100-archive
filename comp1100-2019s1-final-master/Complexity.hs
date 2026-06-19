module Complexity where

-- This file contains functions for the complexity question.
-- You should NOT edit it, nor submit it.

-- | rightOfList
-- Returns the rightmost element of a non-empty list.
--
-- Example:
--
-- rightOfList [1,2,3]
-- 3

rightOfList :: [a] -> a
rightOfList list = case foldl (\x y -> y:x) [] list of
  []  -> error "rightOfList: Empty list"
  x:_ -> x

data BinaryTree a = Null | Node (BinaryTree a) a (BinaryTree a)

-- | rightOfBTree
-- Returns the rightmost element of a binary tree.
--
-- Example:
--
-- rightOfBTree (Node Null 1 (Node (Node (Node Null 2 Null) 3 Null) 4 (Node Null 5 Null)))
-- 5

rightOfBTree :: BinaryTree a -> a
rightOfBTree tree = case tree of
  Null           -> error "rightOfBTree: Empty list"
  Node _ x Null  -> x
  Node _ _ right -> rightOfBTree right

data RoseTree a = RoseNode a [RoseTree a]

-- | rightOfRose
-- Returns the rightmost element of a rose tree.
--
-- Example:
--
-- rightOfRose (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- 5

rightOfRose :: RoseTree a -> a
rightOfRose rose = case rose of
  RoseNode x []     -> x
  RoseNode _ [r]    -> rightOfRose r
  RoseNode x (_:rs) -> rightOfRose (RoseNode x rs)