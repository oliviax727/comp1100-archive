module Advanced where

-- Polynomial Evaluation

-- polyEval [a0, a1, a2, ..., an] x = a0 + a1*x + a2*x^2 + ... an*x^n
polyEval :: [Double] -> Double -> Double
polyEval = undefined

-- | hornerEval : Same as polyEval, but uses Horner's rule
-- to speed up computation time
hornerEval :: [Double] -> Double -> Double
hornerEval = undefined

-- | isPrime : Checks if a number is prime. Try to be efficient!
isPrime :: Integer -> Bool
isPrime = undefined

-- | factor : Returns a prime factorisation of an input number.
factor :: Integer -> [Integer] 
factor = undefined

type Distance = Double
type City = (Double, Double)
type Route = [City]

-- | tsp (travelling salesperson problem) : Takes a list of cities
-- (represented by coordinate points) and returns the list shuffled,
-- such that visiting each city in the order returned minimises the
-- total travel cost (eucledian distance)
tsp :: [City] -> Route
tsp = undefined

-- | cost : Returns the total distance for a particular route
cost :: Route -> Distance
cost = undefined

-- | distance : Returns the distance between two cities
dist :: City -> City -> Distance
dist = undefined
