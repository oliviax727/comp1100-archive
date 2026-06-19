module Participants where

type Team = String
type Name = String

-- The Participants in a sporting event are either
-- Players, who have a Name and a Team, or
-- Referees, who have a Name only.

data Participant = Player Name Team
                 | Referee Name
  deriving (Eq,Show)

-- | nameOf:
-- Given an input of type Participant,
-- return that participant's name.
--
-- Examples:
--
-- >>> nameOf (Player "Kieran Read" "All Blacks")
-- "Kieran Read"
--
-- >>> nameOf (Referee "Nigel Owens")
-- "Nigel Owens"

nameOf :: Participant -> Name
nameOf p = case p of
  Player n _ -> n
  Referee n -> n

-- | teamOf:
-- Given an input of type Participant,
-- use a Maybe type to return the participant's team if they are a player;
-- return Nothing if they are a referee.
--
-- Note that it is NOT necessary to complete nameOf
-- before attempting this question.
--
-- Examples:
--
-- >>> teamOf (Player "Kieran Read" "All Blacks")
-- Just "All Blacks"
--
-- >>> teamOf (Referee "Nigel Owens")
-- Nothing

teamOf :: Participant -> Maybe Team
teamOf p = case p of
  Player _ t -> Just t
  Referee _ -> Nothing