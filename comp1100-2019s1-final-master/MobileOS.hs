module MobileOS where

-- Type declarations for popular mobile operating systems.
-- DO NOT EDIT THESE TYPE DECLARATIONS.

data OSName = Android | IOS
  deriving (Eq, Show)

type ReleaseNumber = Int

data MobileOS = OS OSName ReleaseNumber
  deriving (Eq, Show)

-- | latestRelease:
-- Given an OSName as input,
-- return a MobileOS according to the following specification:
--
-- >>> latestRelease Android
-- OS Android 9
--
-- >>> latestRelease IOS
-- OS IOS 12

latestRelease :: OSName -> MobileOS
latestRelease = undefined

-- | validRelease:
-- Given a MobileOS as input,
-- return True if
-- - its ReleaseNumber is greater than or equal to 1, AND
-- - its ReleaseNumber is less than or equal to that of the latestRelease
-- return False otherwise
--
-- Note that while you may use your solution to latestRelease in this answer,
-- it is NOT necessary to do so.
--
-- Examples:
--
-- >>> validRelease (OS Android 0)
-- False
--
-- >>> validRelease (OS Android 5)
-- True
--
-- >>> validRelease (OS Android 10)
-- False

validRelease :: MobileOS -> Bool
validRelease = undefined