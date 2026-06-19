import Test.Tasty
import Test.Tasty.HUnit
import System.Environment

import ApproximatingTwo

main :: IO ()
main = do
  setEnv "TASTY_TIMEOUT" "10s"
  defaultMain tests

tests :: TestTree
tests = testGroup "twoApprox" [units]

units :: TestTree
units = testGroup "Units"
    [
        testCase "Base cases" $
          map twoApprox [0,-3,-53,-80] @?= [1,0,0,0],
        testCase "Random positive values <= 10" $
          almostEqLists (map twoApproxTest [3,5,6,1]) (map twoApprox [3,5,6,1]) @?= True,
        testCase "Random positive values <= 80, with tolerance for off-by-one error" $
          almostEqLists (map twoApproxTest [64,34,15,51]) (map twoApprox [64,34,15,51])
          || almostEqLists (map twoApproxTest [64,34,15,51]) (map twoApprox [63,33,14,50])
          || almostEqLists (map twoApproxTest [64,34,15,51]) (map twoApprox [65,35,16,52])
          @?= True,
        testCase "Random positive values <= 80" $
          almostEqLists (map twoApproxTest [35,73,62,16]) (map twoApprox [35,73,62,16]) @?= True
    ]

-- Sample solution.
twoApproxTest :: Int -> Double
twoApproxTest x
  | x < 0 = 0
  | otherwise = 1 / (2^x) + twoApproxTest (x-1)

-- Due to floating-point precision errors, we need to allow student solutions
-- to be off up to some small amount. Epsilon chosen as ten times the
-- difference between largest error we could produce.
epsilon :: Double
epsilon = 0.0000000000000023

almostEq :: Double -> Double -> Bool
almostEq x y = abs(x-y) < epsilon

almostEqLists :: [Double] -> [Double] -> Bool
almostEqLists list1 list2 = case (list1,list2) of
  ([],[]) -> True
  ([],_)  -> False
  (_,[])  -> False
  (x:xs,y:ys) -> almostEq x y && almostEqLists xs ys