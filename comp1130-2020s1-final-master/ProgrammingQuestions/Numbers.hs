module Numbers where

-- | sumOfPowers
--
-- Given an Int as input,
-- output an Int according to the following pattern:
--
-- sumOfPowers 1 = 1
-- sumOfPowers 2 = 1 + 2^2
-- sumOfPowers 3 = 1 + 2^2 + 3^3
-- sumOfPowers 4 = 1 + 2^2 + 3^3 + 4^4
-- and so on.
--
-- If the input is zero or negative, output 0.
--
-- Examples:
--
-- >>> sumOfPowers 0
-- 0
--
-- >>> sumOfPowers 1
-- 1
--
-- >>> sumOfPowers 3
-- 32

sumOfPowers :: Int -> Int
sumOfPowers n
    | n <= 0 = 0
    | otherwise = n ^ n + sumOfPowers (n - 1)

-- | mercator
--
-- Given an Int as input,
-- output a Double according to the following pattern:
--
-- mercator 1 = 1
-- mercator 2 = 1 - 1/2
-- mercator 3 = 1 - 1/2 + 1/3
-- mercator 4 = 1 - 1/2 + 1/3 - 1/4
-- mercator 5 = 1 - 1/2 + 1/3 - 1/4 + 1/5
-- and so on.
--
-- (Aside: this is a special case of a Mercator series,
-- and will converge to the natural logarithm of 2)
--
-- If the input is zero or negative, output 0.
--
-- Hint: the Prelude function fromIntegral can convert Ints to Doubles.
--
-- Note that it is NOT necessary to complete the previous question
-- before attempting this question.
--
-- Examples:
--
-- >>> mercator 0
-- 0.0
--
-- >>> mercator 1
-- 1.0
--
-- >>> mercator 3
-- 0.8333333333333333

mercator :: Int -> Double
mercator n
    | n <= 0 = 0
    | even n = - 1 / fromIntegral n + mercator (n-1)
    | otherwise = 1 / fromIntegral n + mercator (n-1)