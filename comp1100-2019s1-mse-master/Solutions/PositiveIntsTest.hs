import Test.Tasty
import Test.Tasty.HUnit
import System.Environment

import PositiveInts

main :: IO ()
main = do
  setEnv "TASTY_TIMEOUT" "10s"
  defaultMain tests

tests :: TestTree
tests = testGroup "PositiveInts" [units]

units :: TestTree
units = testGroup "Units"
    [
        testCase "startPositive [] is False" $
           startPositive [] @?= False,
        testCase "startPositive correct on positive and negative singletons" $
           map startPositive [[23],[-70]] @?= [True,False],
        testCase "startPositive False on list starting with 0" $
           map startPositive [[0],[0,-90,4,-54,69,37,-18,-5,-52],[0,-75,-33,-11,-54,30,-29,88]] @?= [False,False,False],
        testCase "startPositive correct on cases where last sign agrees with first" $
           map startPositive [[63,-67,-54,-15,-78,1,87,99,71],[-76,-76,55,56,87,20,-97,-53,-98,41,91,-91]] @?= [True,False],
        testCase "startPositive True on positive cases where last sign disagrees with first" $
           map startPositive [[86,64,-71],[14,58,20,24,96,58,93,0]] @?= [True,True],
        testCase "startPositive False on negative cases where last sign disagrees with first" $
           map startPositive [[-100,-82,-60,-42,-34,50,73,-67,-81,46,81],[-1,13,-35,14,-10,-87,-39,0]] @?= [False,False],
        testCase "countPositive [] is 0" $
           countPositive [] @?= 0,
        testCase "countPositive is correct on a case without zero" $
           countPositive [81,87,-75,5,60,61,24,62,30,-51,60,67] @?= 10,
        testCase "countPositive is correct on a case with zero in the list, and a positive final element" $
           countPositive [68,-23,-54,0,-43,63,27] @?= 3,
        testCase "countPositive is correct on a case with zero in the list, and a negative final element" $
           countPositive [-8,42,-88,-3,58,0,40,-24,-51,-64,24,-51] @?= 4
    ]