module ApproximatingTwo where

-- | twoApprox:
-- Given an input of type Int,
-- return a Double according to the sequence:
--
-- on input 0, return 1/(2^0)
-- on input 1, return 1/(2^0) + 1/(2^1)
-- on input 2, return 1/(2^0) + 1/(2^1) + 1/(2^2)
-- ...
-- on input k, return 1/(2^0) + 1/(2^1) + 1/(2^2) + ... + 1/(2^k)
--
-- (As an infinite sequence, this converges to two.)
--
-- If the input is negative, return zero.
--
-- Examples:
--
-- >>> twoApprox (-1)
-- 0.0
--
-- >>> twoApprox 0
-- 1.0
--
-- >>> twoApprox 1
-- 1.5

twoApprox :: Int -> Double
twoApprox 0 = 1
twoApprox k
    | k > 0 = 1/(2^k) + twoApprox (k - 1)
    | otherwise = 0.0