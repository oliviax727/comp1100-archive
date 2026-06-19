module PositiveInts where

-- | startPositive:
-- Given as input a list of Ints,
-- return True if its first element is positive (one or greater);
-- return False if its first element is zero or negative, or if the list is empty.
--
-- Examples:
--
-- >>> startPositive []
-- False
--
-- >>> startPositive [1,-2,3,-4]
-- True
--
-- >>> startPositive [-1,-2,3,-4]
-- False

startPositive :: [Int] -> Bool
startPositive [] = False
startPositive (x:_) = x > 0

-- | countPositive:
-- Given as input a list of Ints,
-- return the number of positive elements in the list.
--
-- Note that it is NOT necessary to complete startPositive
-- before attempting this question.
--
-- Examples:
--
-- >>> countPositive []
-- 0
--
-- >>> countPositive [1,-2,3,-4]
-- 2
--
-- >>> countPositive [-1,-2,3,-4]
-- 1

countPositive :: [Int] -> Int
countPositive [] = 0
countPositive (x:xs) = if x > 0 then 1 + countPositive xs else countPositive xs