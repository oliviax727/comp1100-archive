{-|
Module      : Season
Author      : Debashish Chakraborty, Your name and UID here
Date        : 29/01/2019
Description : This module contains functions to check characteristics of 
              different seasons.
-}
module Season where

data Season = Spring | Summer | Autumn | Winter
    deriving Show

-- Finds if given season is cold
-- | IsCold
-- >>> isCold Winter
-- True
--
-- >>> isCold Summer
-- False
--
isCold :: Season -> Bool
isCold season = case season of
    Winter -> True
    _ -> False
