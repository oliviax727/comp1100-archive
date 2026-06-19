module LastChar where

import Prelude hiding (last)

-- ^ DO NOT CHANGE ANY CODE ABOVE THIS LINE
-- | lastChar:
-- Given a non-empty String, return its last character wrapped as a Maybe value.
-- Otherwise, return Nothing.
--
-- Examples:
--
-- >>> lastChar []
-- Nothing
--
-- >>> lastChar "abc"
-- Just 'c'
--
-- >>> lastChar "a"
-- Just 'a'
--
-- >>> lastChar ""
-- Nothing
lastChar :: String -> Maybe Char
lastChar [] = Nothing
lastChar [c] = Just c
lastChar (_:s) = lastChar s
