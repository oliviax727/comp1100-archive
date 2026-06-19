module Types where

-- There is already a type using these keywords,
-- so we wish to not import it.
import Prelude hiding (Either, Left, Right)

-- The sum data type is representing the disjoint union
-- of two sets, tagged with either Left or Right, so
-- we can tell which set it came from.
data Sum a b = Left a | Right b
    deriving Show

-- | sumApply : Takes two functions, the first can take type `a` as input,
-- and the second can take type `b` as input. Also takes a disjoint union
-- of `a` and `b` as input. If the input was of the form `Left a`,
-- extract the variable of type `a` and apple the first function.
-- Else, apply the second function to the argument in `Right b`.
-- >>> sumApply length (*2) (Left "hello")
-- 5
-- >>> sumApply length (*2) (Right 10)
-- 20
sumApply :: (a -> c) -> (b -> c) -> Sum a b -> c
sumApply l _ (Left x) = l x
sumApply _ r (Right x) = r x

-- fromLeft : Takes a sum union, and extracts the `a` from `Left a`.
-- If the input was `Right b`, throw an error.
fromLeft :: Sum a b -> a
fromLeft (Left a) = a
fromLeft _ = error "Left constructors only"

-- fromRight : Takes a sum union, and extracts the `b` from `Right b`.
-- If the input was `Left a`, throw an error.
fromRight :: Sum a b -> b
fromRight (Right b) = b
fromRight _ = error "Right constructors only"

-- | lefts :Takes a list of sum unions, and returns a list containing
-- only the left elements.
-- >>> lefts [Left "hello", Right 5, Left "world", Right 10]
-- ["hello","world"]
-- >>> rights [Left "hello", Right 5, Left "world", Right 10]
-- [5,10]
lefts :: [Sum a b] -> [a]
lefts [] = []
lefts (x:xs) = case x of
    Left a -> a : lefts xs
    _ -> lefts xs

-- rights :Takes a list of sum unions, and returns a list containing
-- only the right elements.
rights :: [Sum a b] -> [b]
rights [] = []
rights (x:xs) = case x of
    Right b -> b : rights xs
    _ -> rights xs

-- | `sumMap` : Takes a list of sums, and two functions, and maps
-- the appropriate function onto each element.
-- (Hint: This function should be easy once you've written `sumApply`)
-- >>> sumMap length (*2) [Left "yes", Right 7, Left "no", Right 9]
-- [3,14,2,18]
sumMap :: (a -> c) -> (b -> c) -> [Sum a b] -> [c]
sumMap l r = map $ sumApply l r

-- | `sumExtract` : Takes a list of sums, and returns a tuple
-- of two lists, seperating all the Left a and Right b elements.
-- >>> sumExtract [Left "yes", Right 7, Left "no", Right 9]
-- (["yes","no"],[7,9])
sumExtract :: [Sum a b] -> ([a], [b])
sumExtract l = (lefts l, rights l) 

-- This data type represents construction workers
-- Each worker has a name, an age, and a job.
-- A crew is a list of workers.
data Job = Digger | Driver | Builder | Foreman | Manager 
    deriving (Show, Eq)
data Worker = Worker Name Age Job
    deriving (Show, Eq)
type Name = String
type Age = Int


type Crew = [Worker]

apolloCrew :: Crew 
apolloCrew = [Worker "Alice" 26 Driver,
            Worker "Bob" 21 Digger,
            Worker "Charlie" 34 Foreman,
            Worker "Daniel" 24 Digger,
            Worker "Eve" 31 Builder,
            Worker "Frank" 38 Manager,
            Worker "Grace" 34 Builder]


-- | `reassign` : Takes a worker, and gives them a new job.
-- >>> reassign (Worker "James" 35 Digger) Driver
-- Worker "James" 35 Driver
reassign :: Worker -> Job -> Worker
reassign (Worker n a _) = Worker n a

-- | `birthday` : A worker has had a birthday today! Increase their age by one.
-- >>> birthday (Worker "Rachael" 23 Foreman)
-- Worker "Rachael" 24 Foreman
birthday :: Worker -> Worker
birthday (Worker n a j) = Worker n (a+1) j

-- `isOnCrew` : Checks if a particular worker is on a crew.
isOnCrew :: Worker -> [Worker] -> Bool
isOnCrew = elem


-- | `findSenior` : Finds and returns the name of the most senior (oldest) worker on a crew.
-- >>> findSenior apolloCrew
-- "Frank"
findSenior :: [Worker] -> Name
findSenior [] = error "Empty crew"
findSenior [x] = getName x
    where
        getName :: Worker -> Name
        getName (Worker n _ _) = n

findSenior (x:y:ls) = if getAge x > getAge y then findSenior (x:ls) else findSenior (y:ls)
    where
        getAge :: Worker -> Age
        getAge (Worker _ a _) = a

-- `filterJob` : Given a crew, returns all workers that match a given job.
filterJob :: Crew -> Job -> Crew
filterJob c j = filter (hasJob j) c
    where
        hasJob :: Job -> Worker -> Bool
        hasJob j1 (Worker _ _ j2) = j1 == j2


type Dollars = Int

-- Define a sensible type for PayRate, and then define the wages that ACC pays.

type PayRate = (Job -> Dollars)

apolloWages :: PayRate
apolloWages j = case j of
    Digger -> 20
    Driver -> 25
    Builder -> 40
    Foreman -> 80
    Manager -> 120

-- | `crewCost` : Given a crew, and a payrate, and a number of hours, determines how much
-- it would cost to hire the crew for that duration of time.
-- >>> crewCost apolloCrew apolloWages 8
-- 2760
crewCost :: Crew -> PayRate -> Int -> Int
crewCost c pr h = foldr (\x y -> h * wage x pr + y) 0 c
    where
        wage :: Worker -> PayRate -> Int
        wage (Worker _ _ j) pr = pr j