{-|
Module      : GPACalculator
Author      : Debashish Chakraborty, Your name and UID here
Date        : 04/02/2019
Description : This module contains functions to calculate GPA from grades and marks.
-}

module GPACalculator where

data Grade = Fail | Pass | Credit | Distinction | HighDistinction | Invalid
   deriving Show

type Course = String
type GP = Double
type GPA = Double
type Mark = Int

-- Convert marks to grade
-- | Exercise 3
-- >>> markToGrade 80
-- HighDistinction
--
-- >>> markToGrade (-10)
-- Invalid
--
markToGrade ::  Mark -> Grade
markToGrade mark
  | mark >= 80 && mark <= 100 = HighDistinction
  | mark >= 70 && mark <   80 = Distinction
  | mark >= 60 && mark <   70 = Credit
  | mark >= 50 && mark <   60 = Pass
  | mark >=  0 && mark <   50 = Fail
  | mark < 0 || mark > 100 = Invalid

-- Allows for courses to be included
-- | Exercise 4
-- >>> markToGrade' ("COMP1100", 80)
-- HighDistinction
--
markToGrade' :: (Course, Mark) -> Grade
markToGrade' (c, m) = markToGrade m

-- markToGrade but with supports
-- | Exercise 5
-- >>> markToGradeSafe 101
-- Nothing
--
-- >>> markToGradeSafe 10
-- Just Fail
--
markToGradeSafe ::  Mark -> Maybe Grade
markToGradeSafe m
  | m >= 0 && m <= 100 = Just (markToGrade m)
  | m < 0 || m > 100 = Nothing

-- Outputs discrete GPA associated with grade title
-- | Exercise 6
-- >>> maybeGradeToGPA (Just HighDistinction)
-- 7.0
--
-- >>> maybeGradeToGPA Nothing
-- 0.0
--
maybeGradeToGPA :: Maybe Grade -> GPA
maybeGradeToGPA (Just g) = case g of
  HighDistinction -> 7.0
  Distinction -> 6.0
  Credit -> 5.0
  Pass -> 4.0
  Fail -> 0.0
maybeGradeToGPA Nothing = 0.0

-- Converts mark to associated discrete GPA
-- | Exercise 7
-- >>> markToGPA 101
-- 0.0
--
-- >>> markToGPA 80
-- 7.0
--
-- >>> markToGPA 15
-- 0.0
--
markToGPA :: Mark -> GPA
markToGPA m = maybeGradeToGPA (markToGradeSafe m)
