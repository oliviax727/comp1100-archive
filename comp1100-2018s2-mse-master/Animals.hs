module Animals where

data Species
  = Cockatoo
  | Kookaburra
  | Rosella
  | Penguin
  -- ^ Birds
  | Kangaroo
  | Koala
  | Platypus
  | Possum
  -- ^ Mammals
  | Crocodile
  | Taipan
  | Tuatara
  | Turtle
  -- ^ Reptiles
  | Redback
  | Huntsman
  | Scorpion
  | Tick
  -- ^ Arachnids
  deriving (Enum, Eq, Show)

data Class
  = Bird -- Cockatoo, Kookaburra, Rosella, Penguin
  | Mammal -- Kangaroo, Koala, Platypus, Possum
  | Reptile -- Crocodile, Taipan, Tuatara, Turtle
  | Arachnid -- Redback, Huntsman, Scorpion, Tick
  deriving (Enum, Eq, Show)

-- | classOfSpecies:
-- Given a species, return its biological class according to the following
-- table mapping classes to species:
--
-- Birds:     Cockatoo, Kookaburra, Rosella, Penguin
-- Mammals:   Kangaroo, Koala, Platypus, Possum
-- Reptiles:  Crocodile, Taipan, Tuatara, Turtle
-- Arachnids: Redback, Huntsman, Scorpion, Tick
--
-- Examples:
--
-- >>> classOfSpecies Platypus
-- Mammal
--
-- >>> classOfSpecies Redback
-- Arachnid
classOfSpecies :: Species -> Class
classOfSpecies s
  | s == Cockatoo || s == Kookaburra || s== Rosella || s== Penguin = Bird
  | s== Kangaroo || s== Koala || s== Platypus || s== Possum = Mammal
  | s== Crocodile || s== Taipan || s== Tuatara || s== Turtle = Reptile
  | s== Redback || s== Huntsman || s== Scorpion || s== Tick = Arachnid

-- | isSpeciesInClass
-- Given a biological class and a species, return True if that species is in
-- the given biological class, and False if not.
--
-- Examples:
--
-- >>> isSpeciesInClass Crocodile Reptile
-- True
--
-- >>> isSpeciesInClass Penguin Arachnid
-- False
isSpeciesInClass :: Species -> Class -> Bool
isSpeciesInClass s c = c == classOfSpecies s
