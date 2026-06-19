module ListComp where

import System.IO.Unsafe

fizzBuzz :: Integer -> [Integer]
fizzBuzz = undefined

myMap :: (a -> b) -> [a] -> [b]
myMap = undefined

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter = undefined

thickDiagonal :: Integer -> [(Integer, Integer)]
thickDiagonal n = undefined

pythagoreanTriples :: Integer -> [(Integer, Integer, Integer)]
pythagoreanTriples = undefined

suggestWord :: String -> [String] -> [String]
suggestWord = undefined

--don't worry about this
dictionary :: [String]
dictionary = lines $ unsafePerformIO $ readFile "dictionary.txt"
