module Scheduling where

data Day = Mon | Tue | Wed | Thu | Fri | Sat | Sun deriving (Eq, Show)

type Time = Double
type Rate = Double

type WorkPeriod = (Day, Time, Time)

-- | Returns true if weekend
--
-- >>> weekend Mon
-- False
-- >>> weekend Sat
-- True
--
weekend :: Day -> Bool
weekend day = case day of
    Sat -> True
    Sun -> True
    _ -> False

-- | Returns pay + overtime rates
--
-- >>> pay 20 (Sun, 4.0, 5.0)
-- 30.0
-- >>> pay 20 (Mon, 4.0, 5.5)
-- 30.0
--
pay :: Rate -> WorkPeriod -> Double
pay r (d, t1, t2) = if weekend d then 1.5 * r * (t2 - t1) else r * (t2 - t1)

type Schedule = [WorkPeriod]

-- | Returns pay + overtime rates over a week
--
-- >>> grossPay 20 [(Mon, 4.0, 5.5), (Sun, 4.0, 5.0)]
-- 60.0
-- >>> grossPay 20 [(Mon, 4.0, 5.5), (Tue, 4.0, 4.5)]
-- 40.0
--
grossPay :: Rate -> Schedule -> Double
grossPay r s
    | null s = 0
    | otherwise = pay r (head s) + grossPay r (tail s)

-- Returns hours for single period
hours :: WorkPeriod -> Double
hours (_, t1, t2) = t2 - t1

-- | Returns total hours
--
-- >>> totalHours [(Mon, 4.0, 5.5), (Sun, 4.0, 5.0)]
-- 2.5
-- >>> totalHours [(Mon, 4.0, 5.5), (Tue, 4.0, 4.5)]
-- 2.0
--
totalHours :: Schedule -> Double
totalHours s
    | null s = 0
    | otherwise = hours (head s) + totalHours (tail s)