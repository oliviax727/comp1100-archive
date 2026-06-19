module Complexity where

-- This file contains functions for the complexity question.
-- You should NOT edit it. 

-- | isSorted
-- Checks whether a list is sorted.

isSorted :: Ord a => [a] -> Bool
isSorted list = case list of
  []     -> True
  [_]    -> True
  x:y:ys -> x <= y && isSorted (y:ys)

-- | sortedTail
-- Returns the longest possible sorted tail of the input list.

sortedTail :: Ord a => [a] -> [a]
sortedTail list = case list of
  [] -> []
  _:xs
    | isSorted list -> list
    | otherwise     -> sortedTail xs