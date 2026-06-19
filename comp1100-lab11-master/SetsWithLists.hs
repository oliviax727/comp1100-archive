module SetsWithLists where

data Set a = Set [a]
   deriving Show


{-
Exercise 4

Complete the functions setEquals, addElement, setUnion.

We have given you the complexity class that your functions should meet.

-}


-- | Returns the definition for the empty set for this data structure
-- best O(1), worst O(1), average O(1)
emptySet :: Set a
emptySet = Set []


-- | The number of elements in a set.
-- best O(n), worst O(n), average O(n)
setSize :: Integral b => Set a -> b
setSize (Set list) = case list of
  []    -> 0
  _: xs -> 1 + setSize (Set xs)


-- | Checks if an element is present in a set
-- best O(1), worst O(n), average O(n)
containsElement :: (Eq a) => Set a -> a -> Bool
containsElement (Set list) element = elem element list


-- | Equality on sets (as lists could be in different order, we want [1,2,3]
-- | to represent the same set as [3,2,1])
-- best O(1), worst O(n^2), average O(n^2)  
setEquals :: (Eq a) => Set a -> Set a -> Bool
setEquals (Set b) (Set l) = (length b == length l) && foldr (\x y -> x `elem` b && y) True l


-- | Adds an element to a set, if it does not already exist
-- best O(1), worst O(n), average O(n)
addElement :: (Eq a) => a -> Set a -> Set a
addElement e (Set x) = if e `elem` x then Set x else Set $ (:) e x

  
-- | Computes the union of two sets (all the elements in at least one of the two sets)
-- best O(1), worst O(n^2), average O(n^2)
setUnion :: (Eq a) => Set a -> Set a -> Set a
setUnion (Set []) l = l
setUnion (Set (s:ss)) l = addElement s (setUnion (Set ss) l)

-- ==================================
--  Functions below are extensions
-- ==================================


-- | Removes an element from a set, if it is present
-- best O(1), worst O(n), average O(n)
removeElement :: (Eq a) => a -> Set a -> Set a --1130 
removeElement e (Set l) = Set $ foldr (\x y -> if x == e then y else x:y) [] l

-- | Computes the intersection of two sets (all the elements in both sets)
-- best O(1), worst O(n^2), average O(n^2)
setIntersection :: (Eq a) => Set a -> Set a -> Set a --1130
setIntersection (Set n) (Set m) = Set $ acc n m []
  where
    acc :: (Eq a) => [a] -> [a] -> [a] -> [a]
    acc [] _ l = l
    acc _ [] _ = []
    acc (x:xs) y l = if x `elem` y then acc xs y (x:l) else acc xs y l

-- | Computes the set difference (all the elements in the first set, but not the second)
-- best O(1), worst O(n^2), average O(n^2)
setDifference :: (Eq a) => Set a -> Set a -> Set a --1130
setDifference (Set n) (Set m) = Set $ acc n m []
  where
    acc :: (Eq a) => [a] -> [a] -> [a] -> [a]
    acc [] _ l = l
    acc x [] _ = x
    acc (x:xs) y l = if x `elem` y then acc xs y l else acc xs y (x:l)
