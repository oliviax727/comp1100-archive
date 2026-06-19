module Minimum where

import Prelude hiding (min)

-- | Given two Integer values a and b, return the smallest of the two values.
--
-- Examples:
-- >>> min 1 2
-- 1
-- >>> min 400 3
-- 3
-- >>> min 10 10
-- 10
--
min :: Integer -> Integer -> Integer
min a b
    | a < b = a
    | a > b = b
    | otherwise = a
