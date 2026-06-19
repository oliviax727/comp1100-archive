-- OVERVIEW OF PROGRAMMING QUESTIONS:
-- 15 marks for 1100 only:
-- GreatMinusLess  (5)
-- MobileOS       (10)
-- 55 marks shared between both courses:
-- Trees          (15)

module Master where

import Prelude hiding (take)
import Data.List hiding (take,genericTake,elemIndices,findIndices)

-- GreatMinusLess.hs
-- 5 MARKS, 1100 ONLY
-- Tests guards and basic arithmetic, or slightly-less basic arithmetic without guards
-- Very easy

-- | greatMinusLess:
-- Given two Ints as input,
-- return the greater Int minus the lesser Int.
--
-- Examples:
--
-- >>> greatMinusLess 5 3
-- 2
--
-- >>> greatMinusLess (-5) 3
-- 8
--
-- >>> greatMinusLess 5 5
-- 0

greatMinusLess :: Int -> Int -> Int
greatMinusLess x y = (max x y) - (min x y)

-- Or, if you do not know about max and min:

greatMinusLess' :: Int -> Int -> Int
greatMinusLess' x y
  | x >= y    = x - y
  | otherwise = y - x

-- MobileOS.hs
-- 10 MARKS, 1100 ONLY
-- Tests ability to work with user defined datatypes
-- Very easy

-- Type declarations for popular mobile operating systems.
-- DO NOT EDIT THESE

data OSName = Android | IOS
  deriving (Eq, Show)

type ReleaseNumber = Int

data MobileOS = OS OSName ReleaseNumber
  deriving (Eq, Show)

-- | latestRelease:
-- Given an OSName as input,
-- return a MobileOS according to the following specification:
--
-- >>> latestRelease Android
-- OS Android 9
--
-- >>> latestRelease IOS
-- OS IOS 12

latestRelease :: OSName -> MobileOS
latestRelease name = case name of
  Android -> OS Android 9
  IOS     -> OS IOS 12

-- Or

latestReleaseNumber :: OSName -> ReleaseNumber
latestReleaseNumber name = case name of
  Android -> 9
  IOS     -> 12

latestRelease' :: OSName -> MobileOS
latestRelease' name = OS name (latestReleaseNumber name)

-- | validRelease:
-- Given a MobileOS as input,
-- return True if
-- - its ReleaseNumber is greater than or equal to 1, and
-- - its ReleaseNumber is less than or equal to that of the latestRelease
-- return False otherwise
--
-- Note that while you may choose to use the previous function in your answer,
-- it is NOT necessary to do so.
--
-- Examples:
--
-- >>> validRelease (OS Android 0)
-- False
--
-- >>> validRelease (OS Android 5)
-- True
--
-- >>> validRelease (OS Android 10)
-- False

validRelease :: MobileOS -> Bool
validRelease (OS name release)
  | release < 1 = False
  | otherwise   = case name of
      Android -> release <= 9
      IOS     -> release <= 12

-- Or

validRelease' (OS name release)
  = (latestReleaseNumber name) >= release && release >= 1

-- Trees.hs
-- 15 MARKS
-- Working with binary and rose trees
-- Difficult

-- Type declarations for trees
-- DO NOT EDIT THESE

data BinaryTree a = Null | Node (BinaryTree a) a (BinaryTree a)
  deriving Show

data RoseTree a = RoseNode a [RoseTree a]
  deriving Show

-- | isBinary:
-- given a RoseTree as input,
-- return True if its structure is binary - no node has more than two children.
-- Return False otherwise.
--
-- Examples:
--
-- >>> isBinary (RoseNode 1 [])
-- True
--
-- >>> isBinary (RoseNode 1 [RoseNode 2 [],RoseNode 3 [],RoseNode 4 []])
-- False
--
-- >>> isBinary (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- True

isBinary :: RoseTree a -> Bool
isBinary (RoseNode _ roses) = length roses <= 2 && all isBinary roses

-- (note that the above solution looks inefficient, but laziness of (&&) saves time)

-- | roseToBinary:
-- Given a RoseTree as input,
-- return a BinaryTree with the same node structure,
-- with the first child (if any) of each node as the left subtree,
-- the second child (if any) of each node as the right subtree,
-- but all other children pruned away.
--
-- Note that it is NOT necessary to complete isBinary
-- before attempting this question;
-- roseToBinary should return a BinaryTree on any input.
--
-- Examples:
--
-- >>> roseToBinary (RoseNode 1 [])
-- Node Null 1 Null
--
-- >>> roseToBinary (RoseNode 1 [RoseNode 2 [],RoseNode 3 [],RoseNode 4 []])
-- Node (Node Null 2 Null) 1 (Node Null 3 Null)
--
-- >>> roseToBinary (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- Node (Node (Node (Node Null 2 Null) 3 Null) 4 (Node Null 5 Null)) 1 Null

roseToBinary :: RoseTree a -> BinaryTree a
roseToBinary (RoseNode x roses) = case roses of
  []           -> Node Null x Null
  [left]       -> Node (roseToBinary left) x Null
  left:right:_ -> Node (roseToBinary left) x (roseToBinary right)

-- | isPath:
-- Given a list and a RoseTree as inputs,
-- return True if the list corresponds to a 'path' through the tree.
-- Return False otherwise.
-- A path is a sequence of nodes where each node is the parent of the next node.
--
-- Note that it is NOT necessary to complete the previous two functions
-- before attempting this question.
--
-- Examples:
--
-- >>> isPath [] (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- True
--
-- >>> isPath [1,4,3,2] (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- True
--
-- >>> isPath [4,3] (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- True
--
-- >>> isPath [3,5] (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- False

isPath :: Eq a => [a] -> RoseTree a -> Bool
isPath path (RoseNode x roses) = case (path,roses) of
  ([],_)   -> True
  ([y],[]) -> x == y
  (y:ys,_)
    | x == y    -> any (isPath ys) roses || any (isPath path) roses
    | otherwise -> any (isPath path) roses

 -- Or

isPath' :: Eq a => [a] -> RoseTree a -> Bool
isPath' path roses = any (isInfixOf path) (roseToPaths roses)

roseToPaths :: RoseTree a -> [[a]]
roseToPaths (RoseNode x roses) = case roses of
  []   -> [[x]]
  [r]  -> map (x:) (roseToPaths r)
  r:rs -> map (x:) (roseToPaths r) ++ roseToPaths (RoseNode x rs)

-- Approximatinge.hs
-- 10 MARKS
-- Induction on numbers
-- Moderate difficulty

-- | fact:
-- Given an Integer as input,
-- compute the factorial:
--
-- fact 0 = 1
-- and for positive n:
-- fact n = n * (n - 1) * (n - 2) * ... * 3 * 2 * 1
--
-- You will not be tested on negative Integers,
-- so you may treat these however you wish.
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
fact n = product [1..n]

-- Or

fact' :: Integer -> Integer
fact' n
  | n <= 0    = 1
  | otherwise = n * fact' (n - 1)

-- Or

fact'' :: Integer -> Integer
fact'' = factAcc 1
  where
    factAcc acc n
      | n <= 0    = acc
      | otherwise = factAcc (acc * n) (n-1)

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
-- (As an infinite sequence, this converges to Euler's number e.)
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
eApprox n
  | n < 0    = 0
  | otherwise = 1 / fromIntegral (fact n) + eApprox (n-1)

-- Or

approximatingeLeft :: Integer -> Double
approximatingeLeft = eAcc 0
    where
      eAcc acc n
        | n < 0     = acc
        | otherwise = eAcc (acc + 1 / fromIntegral (fact n)) (n-1)

-- Calculations for epsilon for testing
-- Set at 10 * maximum difference I get from calculating by different methods
-- Also 20 * difference between exp 1 and converging value of functions

maxMethodDiffs :: Double
maxMethodDiffs = maximum $ zipWith (-) (map eApprox [0..17]) (map approximatingeLeft [0..17])

epsilon :: Double
epsilon = 8.881784197001252e-15

-- Movies.hs
-- 10 MARKS
-- User-defined datatypes, induction on lists, typeclasses
-- Moderate difficulty

-- Type declarations for Movies.
-- Each Movie has
--  a String as title
--  a censor's Rating
--  an Int as minutes duration
-- DO NOT EDIT THESE

data Rating = G | PG | M | MA15 | R18
  deriving (Eq, Ord, Show)

data Movie = Movie String Rating Int

currentFilms :: [Movie]
currentFilms = [
  Movie "X-Men: Dark Phoenix" M 114,
  Movie "Rocketman" M 121,
  Movie "Aladdin" PG 121,
  Movie "Godzilla: King of the Monsters" M 132,
  Movie "John Wick: Chapter 3 – Parabellum" MA15 130,
  Movie "Red Joan" M 101,
  Movie "Asterix: The Secret of the Magic Potion" PG 105,
  Movie "Avengers: Endgame" M 180,
  Movie "Brightburn" MA15 95,
  Movie "2040" G 110,
  Movie "Pokémon: Detective Pikachu" PG 104,
  Movie "Swimming with Men" M 94
  ]

-- | show:
-- We would like to print a movie's details in a prettier format.
--
-- Make Movie an instance of Show
-- by following exactly the following example specifications:
--
-- >>> Movie "X-Men: Dark Phoenix" M 114
-- X-Men: Dark Phoenix (M, 114 minutes)
--
-- >>> Movie "Rocketman" M 121
-- Rocketman (M, 121 minutes)

instance Show Movie where

  show (Movie title rating duration)
    = title ++ " (" ++ show rating ++ ", " ++ show duration ++ " minutes)"

-- An example list of Movies, for testing purposes.
-- There is no need to edit this.

currentMovies :: [Movie]
currentMovies = [
  Movie "X-Men: Dark Phoenix" M 114,
  Movie "Rocketman" M 121,
  Movie "Aladdin" PG 121,
  Movie "Godzilla: King of the Monsters" M 132,
  Movie "John Wick: Chapter 3 – Parabellum" MA15 130,
  Movie "Red Joan" M 101,
  Movie "Asterix: The Secret of the Magic Potion" PG 105,
  Movie "Avengers: Endgame" M 180,
  Movie "Brightburn" MA15 95,
  Movie "2040" G 110,
  Movie "Pokémon: Detective Pikachu" PG 104,
  Movie "Swimming with Men" M 94
  ]

-- | unrestrictedTitles
-- Given a list of Movies as input,
-- return the titles only of all Movies with Rating G, PG, or M.
-- Do not reorder the list.
--
-- Note that it is NOT necessary to complete show
-- before attempting this question.
--
-- >>> unrestrictedTitles []
-- []
--
-- >>> unrestrictedTitles [Movie "X-Men: Dark Phoenix" M 114]
-- ["X-Men: Dark Phoenix"]
--
-- >>> unrestrictedTitles currentMovies
-- ["X-Men: Dark Phoenix","Rocketman","Aladdin","Godzilla: King of the Monsters","Red Joan","Asterix: The Secret of the Magic Potion","Avengers: Endgame","2040","Pok\233mon: Detective Pikachu","Swimming with Men"]

unrestrictedTitles :: [Movie] -> [String]
unrestrictedTitles = (map returnTitle) . (filter unrestrictedRating)
  where
    unrestrictedRating (Movie _ rating _) = rating < MA15
    returnTitle (Movie title _ _)         = title

-- Or, in one pass with a foldr and not so many Prelude functions:

unrestrictedTitles' :: [Movie] -> [String]
unrestrictedTitles' = foldr maybeAppend []
  where
    maybeAppend (Movie title rating _) list
      | rating < MA15 = title:list
      | otherwise     = list

-- ListFunctions.hs
-- 20 MARKS
-- Polymorphic list functions
-- Moderate to hard difficulty

-- | stutter
-- Given a list of any type as input,
-- return a list of the same type,
-- but with every element repeated twice.
--
-- >>> stutter []
-- []
--
-- >>> stutter [1,2]
-- [1,1,2,2]
--
-- >>> stutter "hello"
-- "hheelllloo"

stutter :: [a] -> [a]
stutter = foldr (\x y -> x:x:y) []

-- | take
-- Given an Int n, and list of any type, as input,
-- return the first n elements of that list.
--
-- If n is zero or negative, return the empty list.
-- If n is larger than the input list's length, return the whole input list.
--
-- You may not use the Prelude (or Data.List) function take,
-- nor the Data.List function genericTake.
--
-- Note that it is NOT necessary to complete stutter
-- before attempting this question.
--
-- >>> take (-1) [1,2]
-- []
--
-- >>> take 2 "hello"
-- "he"
--
-- >>> take 5 [1.5,2.5,3.5]
-- [1.5,2.5,3.5]

take :: Int -> [a] -> [a]
take n list
  | n <= 0    = []
  | otherwise = case list of
      []   -> []
      x:xs -> x : take (n-1) xs

-- | elemIndices
-- Given an element of any type, and a list of the same type, as input,
-- return the list of Ints,
-- containing all indices, in ascending order, at which this element appears.
--
-- An index (plural: indices) is the position of an element in a list.
-- The first element of the list has index 0, the second has index 1, etc.
--
-- You may not use the Data.List functions elemIndices or findIndices.
--
-- Note that it is NOT necessary to complete either of the previous two functions
-- before attempting this question.
--
-- >>> elemIndices 4 [1,2,3]
-- []
--
-- >> elemIndices 'l' "hello world"
-- [2,3,9]

elemIndices :: Eq a => a -> [a] -> [Int]
elemIndices = eIHelper 0

eIHelper :: Eq a => Int -> a -> [a] -> [Int]
eIHelper index key indices = case indices of
  []   -> []
  x:xs
    | x == key  -> index : eIHelper (index+1) key xs
    | otherwise -> eIHelper (index+1) key xs

-- | ascendingPrefix
-- Given a list as input,
-- return the longest possible prefix (first section) of that list,
-- for which element is smaller than the next.
--
-- No type signature has been provided;
-- you must define for yourself.
-- Make your type as general as possible.
--
-- Note that it is NOT necessary to complete any of the previous three functions
-- before attempting this question.
--
-- >>> ascendingPrefix [1,2,3,2,1]
-- [1,2,3]
--
-- >> ascendingPrefix "zyx"
-- "z"

ascendingPrefix :: Ord a => [a] -> [a]
ascendingPrefix list = case list of
  []     -> []
  [x]    -> [x]
  x:y:ys
    | x <= y    -> x : ascendingPrefix (y:ys)
    | otherwise -> [x]

-- Code for program proof

len :: [a] -> Int
len []     = 0          -- L1
len (_:xs) = 1 + len xs -- L2

mirror :: [a] -> [a]
mirror = helper [] -- M1

helper :: [a] -> [a] -> [a]
helper xs []     = xs                      -- H1
helper xs (y:ys) = helper (y:(xs ++ [y])) ys -- H2