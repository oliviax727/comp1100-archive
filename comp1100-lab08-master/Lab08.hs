module Lab08 where

-- Week 8: Recursion
-- David Quarel 07/01/19

{-
Exercise 1 + 2: applyOpInt
Combines two Integers together with a given operator.
Don't forget to give it a type declaration!
Make the type as general as you can.
-}

applyOpInt :: (Integer -> Integer -> Integer) -> Integer -> Integer -> Integer
applyOpInt operator = operator

{-
Exercise 2A: compose

Takes two functions and an input, and performs
function composition.

Using the provided functions and compose, 
complete the unfinished functions.

-}

compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

square :: Integer -> Integer 
square x = x^2

inc :: Integer -> Integer
inc x = x + 1

-- | Computes the function f(x) = (x+1)^2
incThenSquare :: Integer -> Integer
incThenSquare = compose square inc

-- | Computes the function f(x) = x^2 + 1
squareThenInc :: Integer -> Integer
squareThenInc = compose inc square

-- | Computes the function f(x) = x+2
add2 :: Integer -> Integer
add2 = compose inc inc

-- | Computes the function f(x) = x^4 + 1
quadThenInc :: Integer -> Integer
quadThenInc = compose inc (compose square square)


{-
Exercise 3: myMap

Applies a function to each integer in a list.
Use myMap to implement incAll, negateAll, isLeast100All
-}

myMap :: (a -> b) -> [a] -> [b]
myMap f list = case list of
  [] -> []
  x:xs -> f x : myMap f xs

incAll :: [Integer] -> [Integer]
incAll = myMap (1 +)

negateAll :: [Bool] -> [Bool]
negateAll = myMap (False ==)

isLeast100All :: [Integer] -> [Bool]
isLeast100All = myMap (100 <=)


{-
Exercise 4: myFilter 

`myFilter` takes two inputs:

* A list of type `a`
* A function that takes an `a` to a `Bool`

It returns the same list, but only keeping those elements for which
the function evaluated to `True`.

-}

-- | Performs a filter using a provided function
-- >>> filter even [1,2,3,4,5]
-- [2,4]
-- >>> filter (elem 'e') ["apple", "plum", "banana", "pear"]
-- ["apple","pear"]
myFilter :: (a -> Bool) -> [a] -> [a]
myFilter func list = case list of
  [] -> []
  x:xs -> if func x then x : myFilter func xs else myFilter func xs

{-
Exercise 5: myZipWith

`myZipWith` takes three inputs:

* Two lists.
* A binary function with inputs that match the types of the two lists.

Output is the result of taking pairs of successive elements from
each list, and applying the operation.
-}

-- | Performs a zip with a given operation
-- >>> myZipWith (+) [1,2,3] [5,10,20]
-- [6,12,23]
-- >>> myZipWith (==) ["hello","cow"] ["world","cow"]
-- [False,True]
-- >>> myZipWith (elem) [3,6,1] [[1,2,3],[10,20,30],[-1, 0, 1]]
-- [True,False,True]
-- >>> myZipWith (+) [1,2,3] [10,20,30,40,50]
-- [11,22,33]
myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith op list1 list2 = case (list1, list2) of
  (x:xs, y:ys) -> op x y : myZipWith op xs ys
  (_, _) -> []


{-
Exercise 6: 

`repeatApply` takes 3 inputs:

* A function `f`, with the same input and output type.
* An integer `n`, indicating the number of times to apply the function.
* An element `x` with suitable type to insert into the function.

Output is the result of applying the function `f` to `x`, `n` many times.
(So if `n=3`, the output should be `f(f(f(x)))`. Applying `f` zero many times
just returns `x` unchanged.)
Make the type as general as can be.

-}

-- | Repeatedly applies a function
-- >>>repeatApply (*2) 3 1
-- 8
-- >>>repeatApply (++ " NO") 5 "OH"
-- "OH NO NO NO NO NO"
repeatApply :: (a -> a) -> Int -> a -> a
repeatApply _ 0 x = x
repeatApply f n x = repeatApply f (n-1) (f x)


{-
Exercise 7: Rewriting with folds

Rewrite all of the functions `sumList, productList, allTrue, anyTrue,
concatenate` using either `foldLeft` or `foldRight`. The definition of
each function should only take up one line.
-}

-- | Folding Examples
-- >>> sumList [1,2,3,4]
-- 10
-- >>> productList [1,2,3,4]
-- 24
-- >>> allTrue [True,False,True]
-- False
-- >>> allTrue [True, True]
-- True
-- >>> anyTrue [False, True, False]
-- True
-- >>> anyTrue [False, False]
-- False
-- >>> concatenate ["Hello","World","!"]
-- "HelloWorld!"
-- >>> doNothingList [1,2,3]
-- [1,2,3]

foldRight :: (a -> b -> b) -> b -> [a] -> b
foldRight op e list = case list of
  [] -> e
  x:xs -> x `op` foldRight op e xs

foldLeft :: (b -> a -> b) -> b -> [a] -> b
foldLeft op e list = case list of
  [] -> e
  x:xs -> foldLeft op (e `op` x) xs

sumList :: [Integer] -> Integer
sumList = foldLeft (+) 0

productList :: [Integer] -> Integer
productList =  foldLeft (*) 1

allTrue :: [Bool] -> Bool
allTrue = foldRight (&&) True

anyTrue :: [Bool] -> Bool
anyTrue = foldRight (||) False

concatenate :: [[a]] -> [a]
concatenate = foldRight (++) []

doNothingList :: [a] -> [a]
doNothingList = foldRight (:) []

{-
Exercise 8: Using higher order functions.

Complete the following functions: 
positiveSum, average, magnitude, dot
-}

-- | Calculates positive sum
-- >>> positiveSum [1,-2,3]
-- 4
-- >>> positiveSum [1,-2,-3]
-- 1
-- >>> positiveSum [-1,-2,-3]
-- 0
positiveSum :: [Integer] -> Integer
positiveSum = foldRight (\x y -> if x > 0 then x + y else y) 0

-- | Calculates average
-- >>> average [1,2,3]
-- 2.0
average :: [Double] -> Double
average list = foldRight (+) 0 list / foldRight (\_ y -> 1 + y) 0 list

-- | Calculates vector magnitude
-- >>> magnitude [-4, 3]
-- 5.0
magnitude :: [Double] -> Double
magnitude vector = sqrt (foldRight (\x y -> x ** 2 + y) 0 vector)

-- | Dot product of two vectors
-- >>> dot [-4, 3] [1, 2]
-- 2.0
dot :: [Double] -> [Double] -> Double
dot vec1 vec2 = foldRight (+) 0 (myZipWith (*) vec1 vec2)

{-
Exercise 9: Maximum using a fold.

Complete the myMaximum function using a fold.
-}

-- | Gets Maximum value of set
-- >>> myMaximum [1, 2, 3, 1, 5, 1]
-- 5
-- >>> myMaximum [6, 1, 2, 3, 1, 5, 1]
-- 6
myMaximum :: [Integer] -> Integer
myMaximum (x:xs) = foldLeft (\a b -> if a > b then a else b) x xs

-- EXTENSIONS --
{-
Extension 1

Try and figure out how to reverse a list using a fold.

-}

reverseFold :: [a] -> [a]
reverseFold = foldl (flip (:)) []

{-
Extension 2

Emulate a `map` using a fold.
-}

mapFold :: (a -> b) -> [a] -> [b]
mapFold f = foldr ((\f a b -> f a : b) f) []

{-
Extension 3

Emulate a `filter` using a fold.
-}
filterFold :: (a -> Bool) -> [a] -> [a]
filterFold predicate = foldr ((\f a b -> if f a then a : b else b) predicate) []
