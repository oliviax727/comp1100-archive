import Test.Tasty
import Test.Tasty.HUnit
import System.Environment

import DaysOfTheWeek

main :: IO ()
main = do
  setEnv "TASTY_TIMEOUT" "10s"
  defaultMain tests

tests :: TestTree
tests = testGroup "isWeekend" [units]

units :: TestTree
units = testGroup "Units"
    [
        testCase "isWeekend True on Sunday" $
          isWeekend Sunday @?= True,
        testCase "isWeekend False on Tuesday and Wednesday" $
          map isWeekend [Tuesday,Wednesday] @?= [False,False],
        testCase "isWeekend False on Thursday and Friday" $
          map isWeekend [Thursday,Friday] @?= [False,False],
        testCase "isWeekend correct on provided doctests" $
           map isWeekend [Monday,Saturday] @?= [False,True],
        testCase "isWeekend correct on days excepting provided doctests" $
           map isWeekend [Tuesday,Wednesday,Thursday,Friday,Sunday] @?= [False,False,False,False,True]
    ]