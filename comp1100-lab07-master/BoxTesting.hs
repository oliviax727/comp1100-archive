module BoxTesting where

-- | Finds the second smallest value in a list of Ints
-- >>> secondMinimum []
-- Nothing
--
-- >>> secondMinimum [4]
-- Nothing
--
-- >>> secondMinimum [1, 1, 1, 1]
-- Nothing
--
-- >>> secondMinimum [1, 3, 8, 5]
-- Just 3
--
-- >>> secondMinimum [2, 1, 2]
-- Just 2
--
-- >>> secondMinimum [1, 1, 2]
-- Just 2
--
-- >>> secondMinimum [2, 2, 2, 1]
-- Just 2
--
-- >>> secondMinimum [1, 2]
-- Just 2
--
secondMinimum :: [Int] -> Maybe Int
secondMinimum l = secMin (uniqueList l [])
  where
    -- | Function meant to do the work of secondMinimum without having to repeadtedly call uniqueList
    secMin :: [Int] -> Maybe Int
    secMin [x, y] = if x > y then Just x else Just y
    secMin (x:y:z:ls)
      | x > y && x > z = secMin (y:z:ls) -- x is greatest
      | y > x && y > z = secMin (x:z:ls) -- y is greatest
      | z > y && z > x = secMin (x:y:ls) -- z is greatest
    secMin _ = Nothing
    
    -- | Accumulator function that returns a list containing one of each element in the inputted list
    uniqueList :: [Int] -> [Int] -> [Int]
    uniqueList [] ls  = ls
    uniqueList (x:xs) ls  = if x `elem` ls then uniqueList xs ls else uniqueList xs (x:ls)