module Multiply where

import Prelude hiding ((*))

-- | multiply: Multiply two natural numbers using only addition.
--
-- Factoring allows us to treat m * n = m + m * (n-1).
-- This derives a simple primitive recursive definition for multiplication
-- of natural numbers using only addition (+): mul(m,n) = m + mul(m,n-1)
--
-- Examples:
--
-- >>> multiply 0 0
-- 0
-- >>> multiply 2 2
-- 4
-- >>> multiply 3 2
-- 6
-- >>> multiply 12 3
-- 36
multiply :: Integer -> Integer -> Integer
multiply _ 0 = 0
multiply a 1 = a
multiply a b = a + multiply a (b - 1)

