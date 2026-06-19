module ListFunctions where

-- Answer type definition. DO NOT EDIT THIS.

data Answer = Correct | Incorrect | NoAnswer

-- | answersToMark
--
-- Given a list of Answers as input,
-- return an Int giving a total mark according to the formula:
-- 2 marks for each Correct;
-- -1 marks for each Incorrect;
-- 0 marks for each NoAnswer.
--
-- Examples:
--
-- >>> answersToMark []
-- 0
--
-- >>> answersToMark [Correct,Incorrect,NoAnswer,Correct]
-- 3

answersToMark :: [Answer] -> Int
answersToMark = foldr (\x y -> answerToMark x + y) 0
    where
        answerToMark :: Answer -> Int
        answerToMark a = case a of
            Correct -> 2
            Incorrect -> -1
            NoAnswer -> 0

-- | allBetween
--
-- Given two values and a list of values as input,
-- return True if all values in the list are
-- greater than or equal to the first value, and
-- less than or equal to the second value.
--
-- No type is provided;
-- for full marks you must provide it yourself.
--
-- Note that it is NOT necessary to complete the previous questions
-- before attempting this question.
--
-- Examples:
--
-- >>> allBetween 10 5 []
-- True
--
-- >>> allBetween 'a' 'e' "abcdedcba"
-- True
--
-- >>> allBetween 0.0 5.0 [1.0,2.0,6.0,3.0]
-- False

allBetween :: Ord a => a -> a -> [a] -> Bool
allBetween l u = foldr (\x y -> (u >= x && l <= x) && y) True

-- | stretch
--
-- Given a list as input,
-- return a list where, for all n,
-- the element with index n in the input list
-- appears n times in a row in the output list.
-- (Note that the first element of a list has index 0,
-- so should not appear at all in the output).
--
-- Note that it is NOT necessary to complete the previous questions
-- before attempting this question.
--
-- Examples:
--
-- >>> stretch []
-- []
--
-- >>> stretch [7,3,8,4]
-- [3,8,8,4,4,4]

stretch :: [a] -> [a]
stretch = strH 0
    where
        strH :: Int -> [a] -> [a]
        strH _ [] = []
        strH n (x:xs) = rep n x ++ strH (n+1) xs

        rep :: Int -> a -> [a]
        rep 0 _ = []
        rep n x = x:rep (n-1) x


-- | longestStreak
--
-- A 'streak' in a list is a sequence of elements in a row that are all equal.
--
-- Given a list as input,
-- return the longest such streak.
--
-- If there is more than one streak of length equal to the longest,
-- return the leftmost such streak.
--
-- Note that it is NOT necessary to complete the previous questions
-- before attempting this question.
--
-- Examples:
--
-- >>> longestStreak []
-- []
--
-- >>> longestStreak [1,2,2,3]
-- [2,2]
--
-- >> longestStreak [1,2,3,3,3,4,5,5,5]
-- [3,3,3]

longestStreak :: Eq a => [a] -> [a]
longestStreak [] = []
longestStreak (x:xs) = streak [] x [] xs
    where
        streak :: Eq a => [a] -> a -> [a] -> [a] -> [a]
        streak l _ c [] = if length c > length l then c else l
        streak l a c (y:ys)
            | a == y = streak l a (a:c) ys
            | length c > length l = streak c y [y] ys
            | otherwise = streak l y [y] ys