module Recursion where

-- | Computes the tribonacci sequence.
-- | T(0) = 0, T(1) = 0, T(2) = 1, T(n) = T(n-1) + T(n-2) + T(n-3)
tribonacci :: Integer -> Integer
tribonacci = acc 1 0 0
    where
        acc :: Integer -> Integer -> Integer -> Integer -> Integer
        acc a b c n
            | n < 2 = 0
            | n == 2 = a
            | otherwise = acc (a + b + c) a b (n - 1)

-- | Chessboard: Given input of n and m,
-- | returns a list of all tuples from (1,1) to (n,m)
-- >>> chessboard (2,3)
-- [(2,3),(1,3),(2,2),(1,2),(2,1),(1,1)]
-- >>> chessboard (0, 3) == chessboard (3, 0)
-- True
chessboard :: (Integer, Integer) -> [(Integer, Integer)]
chessboard (_, 0) = []
chessboard (a, b) = row a b ++ chessboard (a, b-1)
    where
        row :: Integer -> Integer -> [(Integer, Integer)]
        row 0 _ = []
        row x c = (x, c) : row (x-1) c

-- | Work out a suitable type signature to implement the square root
-- by method of bisection algorithm.
bisectSqrt :: Double -> Integer -> Double
bisectSqrt x = root x x 0
    where
        root :: Double -> Double -> Double -> Integer -> Double
        root f u l n
                | ((u + l) / 2) ** 2 == f || n == 0 = (u + l) / 2
                | ((u + l) / 2) ** 2 < f = root f u ((u + l) / 2) (n-1)
                | otherwise = root f ((u + l) / 2) l (n-1)
