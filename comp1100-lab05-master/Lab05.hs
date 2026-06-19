{-|
Module      : Lab05
Author      : Jane Doe, u1234567
Date        : 05/01/2019
Description : Recursion and Lists
-}

module Lab05 where

{-
Exercise 1: sumNumbers

Computes the sum of all numbers up to and including n.

sumNumbers 1 = 1
sumNumbers 2 = 3
sumNumbers 3 = 6
sumNumbers 4 = 10
...
-}

sumNumbers :: Integer -> Integer
sumNumbers n
    | n < 0 = error "positive or zero values only"
    | n == 0 = 0
    | otherwise = n + sumNumbers (n - 1)

{-
Exercise 2: factorial

Computes n!, the product of all positive integers less than
or equal to n.

Fix it so it doesn't infinite loop on negative inputs.
-}

factorial :: Integer -> Integer
factorial n
    | n < 0 = error "positive or zero values only"
    | n == 0 = 1
    | otherwise = n * factorial (n-1)

{-
Exercise 3: rangeSum

Takes two integers, and returns the sum
of all integers from the first to the second, inclusive.

rangeSum 1 5 = 1 + 2 + 3 + 4 + 5 = 15
rangeSum 3 6 = 3 + 4 + 5 + 6 = 18
rangeSum 5 3 = ??? (what would be a sensible definition here?).
-}

rangeSum :: Integer -> Integer -> Integer
rangeSum a b
    | a < b = sumNumbers b - sumNumbers (a - 1)
    | a > b = sumNumbers a - sumNumbers (b - 1)
    | otherwise = a

{-

Exercise 4: rangeSumEx

Takes two integers, and returns the
sum of all integers from the first to the second, inclusive of the first,
but exclusive of the second.

rangeSumEx 2 4 = 2 + 3 = 5
rangeSumEx 3 6 = 3 + 4 + 5 = 12

-}

rangeSumEx :: Integer -> Integer -> Integer
rangeSumEx a b
    | a < b = sumNumbers (b - 1) - sumNumbers (a - 1)
    | a > b = sumNumbers (a - 1) - sumNumbers (b - 1)
    | otherwise = 0

{-

Exercise 5: fibonacci

Takes an integer n, and returns the nth fibonacci number.

fibonacci 0 = 0
fibonacci 1 = 1
fibonacci 2 = 1
fibonacci 3 = 2
fibonacci 4 = 3
fibonacci 5 = 5
fibonacci 6 = 8
fibonacci 30 = 832040

The Fibonacci sequence F_n is as follows: 0,1,1,2,3,5,8,13,21,...
The pattern that the sequence follows is that the first two terms are defined
to be zero and one respectively, and then each
successive term is the sum of the previous two.

-}

fibonacci :: Integer -> Integer
fibonacci n
    | n < 0 = error "Negative values are not accepted"
    | n == 0 = 0
    | n == 1 = 1
    | otherwise = fibonacci (n - 1) + fibonacci (n - 2)

{-
copy

Given an integer n and a charaacter c, returns a string of c's,
that is n long.
-}

copy :: Integer -> Char -> String
copy n c
    |n < 0 = error "copy: Cannot have negative copies of a character"
    |n == 0 = []
    |otherwise = c : copy (n-1) c

{-

Exercise 6: rangeList

Takes two integers `n` and `m`,
and returns a list of all numbers between `n` to `m` inclusive.

> rangeList 1 10
[1,2,3,4,5,6,7,8,9,10]
> rangeList (-2) 2
[-2,-1,0,1,2]
-}

rangeList :: Integer -> Integer -> [Integer]
rangeList a b
    | a > b = error "The second argument must be larger"
    | a == b = [a]
    | otherwise = a : rangeList (a + 1) b

{-
sumList

Computes the sum of all integers in the list.
-}

sumList :: [Integer] -> Integer
sumList list = case list of
    []   -> 0
    x:xs -> x + sumList xs

{-
Exercise 7: lengthList

Computes the length of a list of integers.

> lengthList [1,2,3,4]
4
> lengthList []
0
-}

lengthList :: [a] -> Integer
lengthList [] = 0
lengthList (_:xs) = 1 + lengthList xs

{-
Exercise 8: firstList, lastList

Returns the first/last element of a list respectively.

> firstList [3,1,2,4]
3
> lastList [3,1,2,4]
4
-}

firstList :: [a] -> a
firstList [] = error "Empty List"
firstList (x:_) = x

lastList :: [a] -> a
lastList [] = error "Empty List"
lastList [x] = x
lastList (_:xs) = lastList xs


{-
Exercise 9: prepend, append

`prepend` takes a `Char`, and a `String`, and adds the `Char` to the front
of the String

> prepend 'h' "ello"
"hello"

`append` takes a `Char` and a `String`, and adds the `Char` to the end
of the `String`

> append 'd' "worl"
"world"
-}

prepend :: Char -> String -> String
prepend c s = c : s

append :: Char -> String -> String
append c [] = [c]
append c [s] = s : [c]
append c (s:xs) = s : append c xs

{-
Exercise 10: swapFirstTwo, swapLastTwo}

swapFirstTwo swaps the first two integers in a list of integers, if they exist.

>swapFirstTwo [1]
[1]
>swapFirstTwo [1,2,3]
[2,1,3]

swapLastTwo swaps the last two integers in a list of integers, if they exist.

>swapLastTwo [1]
[1]
>swapLastTwo [1,2,3]
[1,3,2]
-}

swapFirstTwo :: [a] -> [a]
swapFirstTwo (x:y:xs) = y:x:xs
swapFirstTwo (x:xs) = x:xs
swapFirstTwo [] = []

swapLastTwo :: [a] -> [a]
swapLastTwo [] = []
swapLastTwo [x, y] = [y, x]
swapLastTwo (x:xs) = x : swapLastTwo xs

{-

Exercise 11: find
Checks if a given element is inside a list or not.

>find 3 [1,2,3,4,5]
True
>find 9 [6,7,2]
False

-}


find :: Integer -> [Integer] -> Bool
find _ [] = False
find x [y]
    | x == y = True
    | otherwise = False
find x (y:xs)
    | x == y = True
    | otherwise = find x xs

-- EXTENSIONS --


{-
Example of how to write a recursive function using a helper function
to make the problem easier to solve.
-}

sumPoly :: Integer -> Integer
sumPoly n
  |n == 0 = 0
  |otherwise = poly n + sumPoly (n-1)
    where
    poly :: Integer -> Integer
    poly x = x*x + 3*x + 5

{-
Extension 1: gridList

Takes two `Integer` inputs,
`x` and `y`, and returns a list of tuples representing the coordinates
of each cell from `(1,1)` to `(x,y)`.

> gridList 3 3
[(1,1),(2,1),(3,1),(1,2),(2,2),(3,2),(1,3),(2,3),(3,3)]
-}

axisList :: Integer -> Integer -> [(Integer,Integer)]
axisList x 1 = [(x, 1)]
axisList x y = (x, y) : axisList x (y - 1)

gridList :: Integer -> Integer -> [(Integer,Integer)]
gridList 1 y = axisList 1 y
gridList x y = merge (axisList x y) (gridList (x - 1) y)
    where
    merge :: [a] -> [a] -> [a]
    merge xs [] = xs
    merge [] ys = ys
    merge (x:xs) (y:ys) = x : y : merge xs ys

{-
Extension 2: fastFib

Rewrite the fibonacci function so it runs quicker.
If you've done it correctly, try computing fastFib 100000.
Should take under a second.
-}

fastFib :: Integer -> Integer
fastFib n = fib 1 1 n
    where
    fib :: Integer -> Integer -> Integer -> Integer
    fib _ _ 0 = 0
    fib _ _ 1 = 1
    fib _ _ 2 = 2
    fib x y 3 = x + y
    fib x y z = fib (x + y) x (z - 1)

{-
This is a faster version, as it only recurs with one function call, instead of two. This means that the 'evaluation pathway' of the original function will grow at a much faster rate than this one.

fib -call-> fib -call-> fib ...
vs.
fib -call-> fib -call-> fib ...
                -call-> fib ...
    -call-> fib -call-> fib ...
                -call-> fib ...

By switching the values every step, and adding the first parameters, the result is the fibonacci numbers entering as arguments for the fib function.

fib 1 1 5 -> fib 2 1 4 -> fib 3 2 3 -> 5
-}
