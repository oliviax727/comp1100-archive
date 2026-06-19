module SetsWithTrees where

import BinaryTree

data Set a = Set (BSTree a)
   deriving Show

{-
Exercise 6

Complete all these functions, and state their complexity class.

COMP1100:   setEquals, 
            addElement, 
            setUnion

Extensions: setEquals, 
            addElement, 
            setUnion, 
            removeElement, 
            setIntersection, 
            setDifference
-}



-- | Returns the definition for the empty set for this data structure
-- Balanced tree: best O(1), worst O(1)
-- Any tree:      best O(1), worst O(1)
emptySet :: Set a
emptySet = Set Null


-- | The number of elements in a set.
-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
setSize :: Set a -> Integer
setSize (Set tree) = treeSize tree 

-- | Checks if an element is present in a set
-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
containsElement :: (Ord a) => Set a -> a -> Bool
containsElement (Set tree) x = elemBSTree x tree

-- | Equality on sets (as lists could be in different order, we want [1,2,3]
-- | to represent the same set as [3,2,1])
-- Balanced tree: best O(1), worst O(n log n)
-- Any tree:      best O(1), worst O(n^2)
setEquals :: (Eq a) => Set a -> Set a -> Bool
setEquals (Set n) (Set m) = corr (flattenTreeOrd n) (flattenTreeOrd m)
   where
      corr :: (Eq a) => [a] -> [a] -> Bool
      corr l1 l2 = case (l1, l2) of
         (x:xs, y:ys) -> (x == y) && corr xs ys
         ([], []) -> True
         _ -> False


-- | Adds an element to a set, if it does not already exist
-- Balanced tree: best O(1), worst O(log n)
-- Any tree:      best O(1), worst O(n)
addElement :: (Ord a) => a -> Set a -> Set a
addElement x (Set y) = Set $ treeInsert y x
  

-- | Computes the union of two sets (all the elements in at least one of the two sets)
-- Balanced tree: best O(1), worst O(n log n)
-- Any tree:      best O(1), worst O(n^2)
setUnion :: (Ord a) => Set a -> Set a -> Set a
setUnion s (Set Null) = s
setUnion s (Set (Node Null x Null)) = addElement x s
setUnion s (Set (Node l x r)) = addElement x (setUnion (setUnion s $ Set l) $ Set r)

-- =================================
-- Functions below are extensions
-- =================================

-- | Removes an element from a set, if it is present
-- Balanced tree: best O(1), worst O(n log n)
-- Any tree:      best O(1), worst O(n^2)
removeElement :: (Ord a) => a -> Set a -> Set a
removeElement a (Set t) = Set $ treeDelete t a

-- | Computes the intersection of two sets (all the elements in both sets)
-- Balanced tree: best O(1), worst O(n log n)
-- Any tree:      best O(1), worst O(n^2)
setIntersection :: (Eq a, Ord a) => Set a -> Set a -> Set a
setIntersection (Set n) (Set m) = Set $ acc n m Null
  where
    acc :: (Eq a, Ord a) => BSTree a -> BSTree a -> BSTree a -> BSTree a
    acc Null _ t = t
    acc _ Null t = Null
    acc (Node l x r) y t = if elemBSTree x y then acc r y (acc l y $ treeInsert t x) else acc r y (acc l y t)

-- | Computes the set difference (all the elements in the first set, but not the second)
-- Balanced tree: best O(1), worst O(n log n)
-- Any tree:      best O(1), worst O(n^2)
setDifference :: (Eq a, Ord a) => Set a -> Set a -> Set a
setDifference (Set n) (Set m) = Set $ acc n m Null
  where
    acc :: (Eq a, Ord a) => BSTree a -> BSTree a -> BSTree a -> BSTree a
    acc Null _ t = t
    acc x Null _ = x
    acc (Node l x r) y t = if elemBSTree x y then acc r y (acc l y t) else acc r y (acc l y $ treeInsert t x)





