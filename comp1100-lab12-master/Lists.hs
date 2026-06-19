module Lists where

-- | isSorted : Checks if a list is sorted from smallest to biggest.
-- >>> isSorted [1, 2, 4, 6, 9]
-- True
-- >>> isSorted [1, 2, 4, 6, 3, 9]
-- False
isSorted :: (Ord a) => [a] -> Bool
isSorted (x:y:ys) = x < y && isSorted (y:ys)
isSorted _ = True 

-- | insertSorted : Assuming that the input list is sorted, take an element and
-- insert it into the list in the correct place, so that the list is still
-- sorted.
-- >>> insertSorted [1, 2, 4, 6, 9] 8
-- [1,2,4,6,8,9]
-- >>> insertSorted [1, 2, 4, 6] 8
-- [1,2,4,6,8]
-- >>> insertSorted [1, 2, 4, 6, 9] 0
-- [0,1,2,4,6,9]
insertSorted :: (Ord a) => [a] -> a -> [a]
insertSorted [] y = [y]
insertSorted (x:xs) y = if x > y then y:x:xs else x : insertSorted xs y


-- | removeDup : Takes a list, and deletes any elements that have already
-- appeared in the list so far. (Don't use nub here.)
-- >>> (reverse . removeDup) [2,5,2,4,4,1,7,8,2,4,6,3]
-- [2,5,4,1,7,8,6,3]
removeDup :: (Eq a) => [a] -> [a]
removeDup l = set l []
    where
        set :: (Eq a) => [a] -> [a] -> [a]
        set [] s = s
        set (x:xs) s = if x `elem` s then set xs s else set xs (x:s)

-- | continuous : Takes a list of integers, and checks that each element
-- in the list is at most one away from the previous element
-- >>> continuous [1,2,3,3,2,3,4,3,2]
-- True
-- >>> continuous [3,4,3,5,4] -- jumps from 3 to 5
-- False
continuous :: [Integer] -> Bool
continuous (x:y:ys) = (abs (x - y) <= 1) && continuous (y:ys)
continuous _ = True 

-- | rotate : Takes a list, and a value, and rotates the list around
-- by the number of elements indicated
-- >>> rotate [1,2,3,4] 1
-- [2,3,4,1]
-- >>> rotate [5,6,7,8,9,10] 3
-- [8,9,10,5,6,7]
-- >>> rotate "abcdefg" (-2)
-- "fgabcde"
rotate :: [a] -> Int -> [a]
rotate l n
    | n > 0 = drop n l ++ take n l
    | n < 0 = drop (length l + n) l ++ take (length l + n) l
    | otherwise = l

-- | insertAt : Takes a list of `a`, an element of type `a`, an index `Int`,
-- and inserts that element into the list at that element.
-- >>> insertAt "abcdef" '$' 0
-- "$abcdef"
-- >>> insertAt "abcdef" '$' 3
-- "abc$def"
-- >>> insertAt "abcdef" '$' (-1)
-- "abcdef$"
-- >>> insertAt "abcdef" '$' (-2)
-- "abcde$f"
insertAt :: [a] -> a -> Int -> [a]
insertAt l li i = insH l li (ind i $ length l)
    where
        insH :: [a] -> a -> Int -> [a]
        insH [] y 0 = [y]
        insH [] _ _ = error "List index too large or small"
        insH (x:xs) y 0 = y:x:xs
        insH (x:xs) y n = x : insH xs y (n-1)

        ind :: Int -> Int -> Int
        ind x n = if x < 0 then n + x + 1 else x

-- | runLengthEncoding : Takes a list, and returns a list of tuples,
-- counting how many times that element was duplicated consecutively.
-- >>> runLengthEncoding "aaabbccccddcccaaaab"
-- [('a',3),('b',2),('c',4),('d',2),('c',3),('a',4),('b',1)]
-- >>> runLengthEncoding [2,2,1,4,4,2,3,2,2,3]
-- [(2,2),(1,1),(4,2),(2,1),(3,1),(2,2),(3,1)]
runLengthEncoding :: (Eq a) => [a] -> [(a,Integer)]
runLengthEncoding [] = []
runLengthEncoding (z:l) = eH l 1 z
    where
        eH :: (Eq a) => [a] -> Integer -> a -> [(a, Integer)]
        eH [] n y = [(y,n)]
        eH (x:xs) n y
            | x == y = eH xs (n+1) y
            | otherwise = (y, n) : eH xs 1 x

-- | runLengthDecoding : Take the output from `runLengthEncoding`, and 
-- reconstruct the original string.
-- >>> runLengthDecoding [('a',3),('b',2),('c',4),('d',2),('c',3),('a',4),('b',1)]
-- "aaabbccccddcccaaaab"
-- >>> runLengthDecoding [(2,2),(1,1),(4,2),(2,1),(3,1),(2,2),(3,1)]
-- [2,2,1,4,4,2,3,2,2,3]
runLengthDecoding :: [(a,Integer)] -> [a]
runLengthDecoding [] = []
runLengthDecoding (x:xs) = mult x ++ runLengthDecoding xs
    where
        mult :: (a, Integer) -> [a]
        mult (_, 0) = []
        mult (a, n) = a : mult (a, n-1)

-- | transpose : Takes [[a]] as input, and transpose it 
-- (swap rows with columns). (Don't use the transpoes function in Data.List here)
-- >>> transpose [[1,2,3],[4,5,6],[7,8,9]]
-- [[1,4,7],[2,5,8],[3,6,9]]
transpose :: [[a]] -> [[a]]
transpose mtx = row 0 (length $ head mtx) mtx
    where
        pass :: Int -> [[a]] -> [a]
        pass _ [] = []
        pass n (x:xs) = x!!n : pass n xs

        row :: Int -> Int -> [[a]] -> [[a]]
        row _ 0 _ = []
        row n m l = pass n l : row (n+1) (m-1) l