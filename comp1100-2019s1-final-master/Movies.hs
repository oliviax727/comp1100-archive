module Movies where

-- Type declarations for Movies.
-- Each Movie has
--  a String as title;
--  a censor's Rating (one of five possible values of the sum type below);
--  an Int as duration (in minutes).
-- DO NOT EDIT THESE TYPE DECLARATIONS.

data Rating = G | PG | M | MA15 | R18
  deriving (Eq, Ord, Show)

data Movie = Movie String Rating Int

-- | show:
-- We would like to print a movie's details in a prettier format.
--
-- Make Movie an instance of Show
-- by following exactly the following example specifications:
--
-- >>> Movie "X-Men: Dark Phoenix" M 114
-- X-Men: Dark Phoenix (M, 114 minutes)
--
-- >>> Movie "Rocketman" M 121
-- Rocketman (M, 121 minutes)

instance Show Movie where

  show = undefined

-- An example list of Movies, for testing purposes.
-- There is no need to edit this.

currentMovies :: [Movie]
currentMovies = [
  Movie "X-Men: Dark Phoenix" M 114,
  Movie "Rocketman" M 121,
  Movie "Aladdin" PG 121,
  Movie "Godzilla: King of the Monsters" M 132,
  Movie "John Wick: Chapter 3 Parabellum" MA15 130,
  Movie "Red Joan" M 101,
  Movie "Asterix: The Secret of the Magic Potion" PG 105,
  Movie "Avengers: Endgame" M 180,
  Movie "Brightburn" MA15 95,
  Movie "2040" G 110,
  Movie "Pokemon: Detective Pikachu" PG 104,
  Movie "Swimming with Men" M 94
  ]

-- | unrestrictedTitles
-- Given a list of Movies as input,
-- return the titles only of all Movies with Rating G, PG, or M
-- (i.e. no titles of Movies with Rating MA15 or R18).
-- Do not reorder the list.
--
-- Note that it is NOT necessary to complete show
-- before attempting this question.
--
-- Examples:
--
-- >>> unrestrictedTitles []
-- []
--
-- >>> unrestrictedTitles [Movie "X-Men: Dark Phoenix" M 114]
-- ["X-Men: Dark Phoenix"]
--
-- >>> unrestrictedTitles currentMovies
-- ["X-Men: Dark Phoenix","Rocketman","Aladdin","Godzilla: King of the Monsters","Red Joan","Asterix: The Secret of the Magic Potion","Avengers: Endgame","2040","Pokemon: Detective Pikachu","Swimming with Men"]

unrestrictedTitles :: [Movie] -> [String]
unrestrictedTitles = undefined