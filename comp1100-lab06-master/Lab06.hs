module Lab06 where

-- Lab 06 : More lists, Parametric polymorphism, recursive data types


-- ===== MORE LIST OPERATIONS ====== --

{-
Exercise 1

Write a function that takes a list of elements packed inside a `Maybe` type,
and returns a list containing the elements. Any `Nothing`'s present in the
original list should be discarded.
You will have to work out the type declaration. Make it as general as possible.

> unMaybe [Just 1, Nothing, Just 2]
[1,2]
> unMaybe [Nothing, Just "hello", Just "world"]
["hello","world"]
-}

-- | Removes Maybe
-- >>> unMaybe [Just 1, Nothing, Just 2]
-- [1,2]
-- >>> unMaybe [Nothing, Just "hello", Just "world"]
-- ["hello","world"]
--
unMaybe :: [Maybe a] -> [a]
unMaybe [] = []
unMaybe (x:xs) = case x of
    Nothing -> unMaybe xs
    Just a -> a : unMaybe xs


{-
Exercise 2

Write a parametric polymorphic function `join`, that takes two lists of any type,
and joins them together to return a list of the same type.
You will have to figure out the type declaration of the function yourself.
You should not use `++` or any other predefined functions.

>join [1,2,3] [4,5,6]
[1,2,3,4,5,6]
>join "hello" "world"
"helloworld"
-}

-- | join two lists
-- >>> join [1,2,3] [4,5,6]
-- [1,2,3,4,5,6]
-- >>> join "hello" "world"
-- "helloworld"
join :: [a] -> [a] -> [a]
join [] l = l
join (x:xs) l = x : join xs l

{-
Exercise 3

Using our new function `(++)` (or `join`), try to define `rev`, a function
that takes a list and returns the same list, reversed. Make sure the function
is polymorphic!

>rev "Hello, World!" 
"!dlroW ,olleH"
>rev [1,2,3]
[3,2,1]

-}

-- | reverse a list
-- >>> rev "Hello, World!" 
-- "!dlroW ,olleH"
-- >>> rev [1,2,3]
-- [3,2,1]
rev :: [a] -> [a]
rev [] = []
rev (x:xs) = join (rev xs) [x]

{-
Exercise 4

Write a function that takes two lists and performs a "riffle" shuffle,
alternating back and forth to return all elements from both lists.
If one list has more elements than the other, just add the rest of the 
non-empty list to the end.

>riffle [1,2,3] [4,5,6]
[1,4,2,5,3,6]
>riffle [1,2,3] [10,20,30,40,50,60]
[1,10,2,20,3,30,40,50,60]
>riffle ['h','s','e','l','l'] ['a','k']
"haskell"

-}

-- | Alternates between each element of the two lists
-- >>> riffle [1,2,3] [4,5,6]
-- [1,4,2,5,3,6]
-- >>> riffle [1,2,3] [10,20,30,40,50,60]
-- [1,10,2,20,3,30,40,50,60]
-- >>> riffle ['h','s','e','l','l'] ['a','k']
-- "haskell"
riffle :: [a] -> [a] -> [a]
riffle (x:xs) (y:ys) = x : y : riffle xs ys
riffle xs [] = xs
riffle [] ys = ys


{-
Exercise 5

Try writing a new function, `fastRev`, that reverses the list in a more
efficient manner. Evaluating `last (rev [1..10000])` should appear
to be instantaneous if you've written it correctly.

-}

-- The join function, and the use of a single list makes rev O(n^2). Using an accumulator makes it O(n)
fastRev :: [a] -> [a]
fastRev [] = []
fastRev l = transfer [] l
    where
        transfer :: [a] -> [a] -> [a]
        transfer l [] = l
        transfer l (x:xs) = transfer (x : l) xs

-- ==== RECURSIVE DATA TYPES ==== 

data Nat = Z | S Nat
    deriving Show 
    {- "deriving Show" tells Haskell to allow conversion from Nat to String,
     so we can print the result in the Terminal to look at -}

-- Example functions

isOne :: Nat -> Bool
isOne n = case n of
    Z     -> False
    S Z -> True
    S _ -> False

increment :: Nat -> Nat
increment = S

decrement :: Nat -> Nat
decrement n = case n of
    Z   -> error "decrement: Zero has no predecessor"
    S m -> m

{-
Exercise 6

Try and write a function `natEq` that checks if two natural numbers are
equal. What should the type be?

>natEq (S Z) (S Z)
True
>natEq (S (S Z)) (S Z)
False
-}

-- | checks if nat encoding is equaly
-- >>> natEq (S Z) (S Z)
-- True
-- >>> natEq (S (S Z)) (S Z)
-- False
natEq :: Nat -> Nat -> Bool
natEq Z Z = True
natEq (S n1) (S n2) = natEq n1 n2
natEq _ _ = False


{-
Exercise 7

Try and define addition on natural numbers.
What should the type be?

>addNat Z (S Z)
(S Z)
>addNat (S (S Z)) (S (S (S Z)))
S (S (S (S (S Z))))
-}

-- | adds two encoded naturals
-- >>> addNat Z (S Z)
-- S Z
-- >>> addNat (S (S Z)) (S (S (S Z)))
-- S (S (S (S (S Z))))
addNat :: Nat -> Nat -> Nat
addNat Z n = n
addNat a b = addNat (decrement a) (increment b)

{-
Exercise 8
Write a function that checks if a natural number is even.

>isNatEven Z
True
>isNatEven (S Z)
False
>isNatEven (S (S Z))
True
-}

-- | Checks if the encoded natural is even
-- >>> isNatEven Z
-- True
-- >>> isNatEven (S Z)
-- False
-- >>> isNatEven (S (S Z))
-- True
isNatEven :: Nat -> Bool
isNatEven n = even (natToInt n)

{-
Exercise 9
Write functions that can convert from an `Integer` to a `Nat`, and back again.

-}
natToInt :: Nat -> Integer
natToInt Z = 0
natToInt a = 1 + natToInt (decrement a)

-- | Integer to Natural Encoding
-- >>> natToInt (intToNat 0)
-- 0
-- >>> natToInt (intToNat 5)
-- 5
intToNat :: Integer -> Nat
intToNat n
    | n == 0 = Z
    | n > 0 = S (intToNat (n - 1))
    | otherwise = error "value must be positive"


-- =========== EXTENSIONS ==========

{-
Extension 1: 

Write a function `powerset` that takes a list, and generates all possible sublists,
ignoring ordering of the elements in the sublists.
The order that the sublists are listed also doesn't matter.

powerset [1,2,3]
[[1,2],[1,2,3],[1],[1,3],[2],[2,3],[],[3]]
powerset [1,2,3,4]
[[], [1], [2], [3], [4], [1,2], [1,3], [1,4], [2,3], [2,4], [3,4], [1,2,3], [1,2,4], [1,3,4], [2,3,4], [1,2,3,4]]
-}

powerset :: [a] -> [[a]]
powerset [] = [[]]
powerset (x:xs) = join (comboset x (powerset xs)) (powerset xs)
    where
        comboset :: a -> [[a]] -> [[a]]
        comboset _ [] = []
        comboset x [y] = [join [x] y]
        comboset x (y:ys) = join [x] y : comboset x ys

{-
Extension 2:

Write a function that accepts a list of positive integers and a target sum.
which returns all sub-sequences of the original list that add up to the
target sum.

>rucksack [3,7,5,9,13,17] 30 
[[13,17],[3,5,9,13]]
-}

-- Assuming that the powerset function works
rucksack :: [Integer] -> Integer -> [[Integer]]
rucksack l n = sumCheck (powerset l) n
    where
        sumCheck :: [[Integer]] -> Integer -> [[Integer]]
        sumCheck [] _ = []
        sumCheck (x:xs) n = if n == sumList x then x : sumCheck xs n else sumCheck xs n

        sumList :: [Integer] -> Integer
        sumList [] = 0
        sumList (x:xs) = x + sumList xs


{-
Extension 3:

Try to come up with a definition for all integers, such that
each number has a unique representation.
-}

-- I know that having two pre-defined data types is technically 'cheating', but it's still a valid solution

-- Here, Xp stands for 1 and Xe stands for -1
-- P stands for 'Plus 1', N stands for 'Minus 1'
data PInt = Xp | P PInt
    deriving Show
data NInt = Xe | N NInt
    deriving Show

-- Xo Stands for 0, Pe/Ne is the same as P/N
data IntEn = Xo | Pe PInt | Ne NInt
    deriving Show

-- There is no -(-2), as all negative integers are recursively defined as decrements of -1
-- Similarly, there is no -0, as 0 is always Xo