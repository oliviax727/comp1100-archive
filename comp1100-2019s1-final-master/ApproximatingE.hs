module ApproximatingE where

-- | fact:
-- Given an Integer as input,
-- compute the factorial:
--
-- fact 0 = 1
-- and for positive Integers n,
-- fact n = the product of all positive Integers less than or equal to n
-- e.g. fact 5 = 5 * 4 * 3 * 2 * 1
--
-- You will not be tested on negative Integers,
-- so you may treat these however you wish.
--
-- Examples:
--
-- >>> fact 0
-- 1
--
-- >>> fact 1
-- 1
--
-- >>> fact 3
-- 6

fact :: Integer -> Integer
fact = undefined

-- | eApprox
-- Given an Integer as input,
-- compute a Double according to the sequence:
--
-- on input 0, return 1 / (fact 0)
-- on input 1, return 1 / (fact 0) + 1 / (fact 1)
-- on input 2, return 1 / (fact 0) + 1 / (fact 1) + 1 / (fact 2)
-- ...
-- on input k, return 1 / (fact 0) + 1 / (fact 1) + 1 / (fact 2) + ... + 1 / (fact k)
--
-- (As an infinite series, this converges to Euler's number e.)
--
-- You will not be tested on negative Integers,
-- so you may treat these however you wish.
--
-- Hint: recall the function fromIntegral can convert Integers to Doubles.
--
-- Note that it IS necessary to complete fact to pass the below doctests
-- BUT you can get full marks for this function even if fact is incomplete or incorrect.
--
-- Examples:
--
-- >>> eApprox 0
-- 1.0
--
-- >>> eApprox 1
-- 2.0
--
-- >>> eApprox 2
-- 2.5

eApprox :: Integer -> Double
eApprox = undefined