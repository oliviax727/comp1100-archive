module ListFunctions where

-- DO NOT delete or modify the two import statements below.
-- Note that these lines may cause warnings to be shown to you.
-- You may ignore these warnings.

import Prelude hiding (take)
import Data.List hiding (take,genericTake,elemIndices,findIndices)

-- | stutter
-- Given a list of any type as input,
-- return the list with every element of the input list repeated twice in a row.
--
-- FOR THIS FUNCTION ONLY:
-- For full marks you must implement this with a fold.
--
-- Examples:
--
-- >>> stutter []
-- []
--
-- >>> stutter [1,2]
-- [1,1,2,2]
--
-- >>> stutter "hello"
-- "hheelllloo"

stutter :: [a] -> [a]
stutter = undefined

-- | take
-- Given an Int n, and a list of any type, as input,
-- return the first n elements of that list.
--
-- If n is zero or negative, return the empty list.
-- If n is larger than the input list's length, return the whole input list.
--
-- You may not use the Prelude (or Data.List) function take,
-- nor the Data.List function genericTake.
--
-- Note that it is NOT necessary to complete stutter
-- before attempting this question.
--
-- Examples:
--
-- >>> take (-1) [1,2]
-- []
--
-- >>> take 2 "hello"
-- "he"
--
-- >>> take 5 [1.5,2.5,3.5]
-- [1.5,2.5,3.5]

take :: Int -> [a] -> [a]
take = undefined

-- | elemIndices
-- Given an element of any type, and a list of the same type, as input,
-- return the list of Ints,
-- containing all indices, in ascending order, at which this element appears.
--
-- An index (plural: indices) is the position of an element in a list.
-- The first element of the list has index 0, the second has index 1, etc.
--
-- You may not use the Data.List functions elemIndices or findIndices.
--
-- Note that it is NOT necessary to complete either of the previous two functions
-- before attempting this question.
--
-- Examples:
--
-- >>> elemIndices 4 [1,2,3]
-- []
--
-- >> elemIndices 'l' "hello world"
-- [2,3,9]

elemIndices :: Eq a => a -> [a] -> [Int]
elemIndices = undefined

-- | ascendingPrefix
-- Given a list as input,
-- return the longest possible prefix (first section) of that list,
-- for which each element is less than or equal to the next.
--
-- No type signature has been provided;
-- you must define it for yourself.
-- Make your type as general as possible.
--
-- Note that it is NOT necessary to complete any of the previous three functions
-- before attempting this question.
--
-- Examples:
--
-- >>> ascendingPrefix [1,2,3,2,1]
-- [1,2,3]
--
-- >> ascendingPrefix "zyx"
-- "z"

-- ascendingPrefix :: ?????
ascendingPrefix = undefined