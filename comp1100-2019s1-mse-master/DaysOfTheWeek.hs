module DaysOfTheWeek where

data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
  deriving (Eq,Show)

-- | isWeekend:
-- Given an input of type Day,
-- return True if it is Saturday or Sunday
-- return False if it is Monday, Tuesday, Wednesday, Thursday, or Friday.
--
-- No type signature for isWeekend has been provided;
-- you must work this out for yourself.
--
-- Examples:
--
-- >>> isWeekend Monday
-- False
--
-- >>> isWeekend Saturday
-- True

isWeekend :: Day -> Bool
isWeekend d
  | d == Saturday || d == Sunday = True
  | otherwise = False