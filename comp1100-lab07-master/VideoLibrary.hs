{-|
Module  : IntroductionModule
Description : To indtroduce testing and modular development of Haskell code
Maintainer  : u7280249@anu.edu.au

-}
module VideoLibrary where

type Name = String
type Year = Int
type Availability = Bool

-- | The video takes a constroctor determening the format, and two parameters, name and year
data Video = Movie Name Year  -- ^ Movie format
  | Show Name Year   -- ^ TV Show format
  deriving (Show, Eq)

type Library = [(Video, Availability)]

library :: Library
library =
  [ (Show "Westworld" 2017, False)
  , (Movie "Harry Potter and the Prisoner of Azkaban" 2004, False)
  , (Show "Game of Thrones" 2011, True)
  , (Movie "Thor: Ragnarok" 2017, False)
  , (Movie "Avengers: Endgame" 2019, False)
  , (Show "Attack on Titan" 2009, True)
  , (Show "Stranger Things" 2016, False)
  , (Movie "Star Wars: The Force Awakens" 2015, True)
  , (Show "The Walking Dead" 2010, True)
  , (Movie "Deadpool" 2016, True)
  ]
  
-- | Checks if a video is available in a given library
-- >>> checkAvailability library "Avengers: Endgame"
-- False
--
-- >>> checkAvailability library "Deadpool"
-- True
--
-- >>> checkAvailability library "Westworld"
-- False
--
-- >>> checkAvailability [] "Deadpool"
-- False
--
checkAvailability :: Library -> Name -> Availability
checkAvailability [] _ = False
checkAvailability ((vid, av):lib) name = if checkName vid name then av else checkAvailability lib name
  where
  -- | Checks if a name corresponds to a given video
  checkName :: Video -> Name -> Bool
  checkName video n = case video of
    Movie vidname _ -> vidname == n
    Show vidname _ -> vidname == n

-- | Returns a library of all available videos in a library. Returning a library type is useful as it's more modular.
-- >>> printAvailableList library
-- [(Show "Game of Thrones" 2011,True),(Show "Attack on Titan" 2009,True),(Movie "Star Wars: The Force Awakens" 2015,True),(Show "The Walking Dead" 2010,True),(Movie "Deadpool" 2016,True)]
--
-- >>> printAvailableList []
-- []
--
-- >>> printAvailableList [(Movie "Thor: Ragnarok" 2017, False)]
-- []
--
printAvailableList :: Library -> Library
printAvailableList [] = []
printAvailableList ((vid, av):lib) = if av then (vid, av) : printAvailableList lib else printAvailableList lib