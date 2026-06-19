import Test.Tasty
import Test.Tasty.HUnit
import System.Environment

import Participants

main :: IO ()
main = do
  setEnv "TASTY_TIMEOUT" "10s"
  defaultMain tests

tests :: TestTree
tests = testGroup "Participants" [units]

units :: TestTree
units = testGroup "Units"
    [
        testCase "nameOf correct on Players" $
           nameOf (Player "navn" "hold") @?= "navn",
        testCase "nameOf correct on Players" $
           nameOf (Player "navn" "hold") @?= "navn",
        testCase "nameOf correct on Referees" $
           nameOf (Referee "navn") @?= "navn",
        testCase "nameOf correct on Referees" $
           nameOf (Referee "navn") @?= "navn",
        testCase "nameOf correct on all Participants" $
           map nameOf [Player "navn et" "hold", Referee "navn to"] @?= ["navn et", "navn to"],
        testCase "teamOf correct on Players" $
           teamOf (Player "navn" "hold") @?= Just "hold",
        testCase "teamOf correct on Players" $
           teamOf (Player "navn" "hold") @?= Just "hold",
        testCase "teamOf correct on Referees" $
           teamOf (Referee "navn") @?= Nothing,
        testCase "teamOf correct on Referees" $
           teamOf (Referee "navn") @?= Nothing,
        testCase "teamOf correct on all Participants" $
           map teamOf [Player "navn et" "hold", Referee "navn to"] @?= [Just "hold", Nothing],
        testCase "teamOf correct on all Participants" $
           map teamOf [Player "navn et" "hold", Referee "navn to"] @?= [Just "hold", Nothing]
    ]