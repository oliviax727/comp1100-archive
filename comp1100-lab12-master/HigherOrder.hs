module HigherOrder where

--Implement the following functions using higher order functions.
--Your solutions should be very succinct, and should
--not use recursion (other than the recursion provided by a higher
--order function). 

-- arithMean : Computes the average of a list of numbers.
arithMean :: (Fractional a) => [a] -> a
arithMean = undefined

-- Computes the geometric mean of a list of numbers.
geoMean :: (Floating a) => [a] -> a
geoMean = undefined

-- l1Norm : Takes a list of numbers, and computes the sum of the 
-- absolute values of each term.
l1Norm :: (Num a) => [a] -> a
l1Norm = undefined

-- l2Norm : Takes a list of numbers, and computes the Eucledian norm,
-- defined to be the square root of the sum of the squares of each element.
l2Norm :: (Floating a) => [a] -> a 
l2Norm = undefined

-- cesaroSum : Takes a list of numbers, and returns a list, where the nth element
-- is the average of the first n terms of the input list.
cesaroSum :: (Fractional a) => [a] -> [a]
cesaroSum = undefined

-- ===========================================


-- | revMap : Takes an element, and feeds that element to each function in a list.
revMap :: a -> [(a -> b)] -> [b]
revMap = undefined

-- | superMap : Takes a list of elements, and a list of functions, and applies each element to
-- | each function. Your output should be a list of lists.
superMap :: [a] -> [(a -> b)] -> [[b]]
superMap = undefined
