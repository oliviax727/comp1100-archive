module Cities where

data City
  = Ballarat
  | Brisbane
  | Canberra
  | Melbourne
  | Newcastle
  | Sydney
  | Wollongong
  deriving (Enum,Eq,Show)

data State
  = ACT
  | NSW
  | QLD
  | VIC
  deriving (Enum,Eq,Show)

-- CITIES BY STATE
-- ACT: Canberra
-- NSW: Sydney, Newcastle, Wollongong
-- QLD: Brisbane
-- VIC: Melbourne, Ballarat

-- | stateOfCity: Given a City, return the State in which it is located,
--                according to the table CITIES BY STATE above
-- Examples:
-- >>> stateOfCity Brisbane
-- QLD
-- >>> stateOfCity Newcastle
-- NSW
stateOfCity :: City -> State
stateOfCity c = case c of
  Ballarat -> VIC
  Brisbane -> QLD
  Canberra -> ACT
  Melbourne -> VIC
  Newcastle -> NSW
  Sydney -> NSW
  Wollongong -> NSW

-- | isCityInState: Given a City and a State,
--   return True if the city is in that state
--   and False if it is not.
-- Examples:
-- >>> isCityInState Melbourne VIC
-- True
-- >>> isCityInState Newcastle VIC
-- False
isCityInState :: City -> State -> Bool
isCityInState c s = s == stateOfCity c