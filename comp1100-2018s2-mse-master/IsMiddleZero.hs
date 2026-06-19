module IsMiddleZero where

import Prelude

-- | isMiddleZero:
-- Given a triple of the type (Int,Int,Int), 
-- return True if its second element is equal to 0, and False otherwise. 
--
-- Examples:
--
-- >>> isMiddleZero (3,2,0) 
-- False
--
-- >>> isMiddleZero (0,3,5)
-- False
--
-- >>> isMiddleZero (0,0,0)
-- True
--
-- >>> isMiddleZero (7,0,7)
-- True
--
-- >>> isMiddleZero (2,0,3) == isMiddleZero (7,0,6)
-- True
--
-- >>> isMiddleZero (2,3,3) == isMiddleZero (7,2,6)
-- True
isMiddleZero :: (Int, Int, Int) -> Bool
isMiddleZero (a, b, c) = b == 0
