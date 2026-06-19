{-|
Module      : TestPattern
Description : Stores the information for some test turtle patterns
Maintainer  : u7280249@anu.edu.au

The comp1100 Turtle command list was not produced by the maintainer.

-}

module TestPattern where

import Turtle

-- | A more complex example to test your interpreter.
comp1100 :: [TurtleCommand]
comp1100 = concat [start, c, o, m, p, one, one, o, o]
  where
    start = concat [j 1.5, l, j 9.25, r]
    c = concat
      [ r, j 1.5
      , l, j 0.5
      , l, l', f d
      , r', f 1
      , r', f d
      , r', f 2
      , r', f d
      , r', f 1
      , r', f d
      , r', j 2.5
      , l, j 1
      , l
      ]
    o = concat
      [ r, j 1.5
      , l, j 0.5
      , l, l', f d
      , r', f 1
      , r', f d
      , r', f 2
      , r', f d
      , r', f 1
      , r', f d
      , r', f 2
      , j 0.5
      , l, j 1
      , l
      ]
    m = concat
      [ l, j 0.5, r
      , f 3
      , r, r', f (d * 2)
      , l, f (d * 2)
      , r, r', f 3
      , l, j 1, l
      ]
    p = concat
      [ l, j 0.5, r
      , f 2.5
      , r', f d
      , r', f 1
      , r', f d
      , r', f 1
      , r', f d
      , r', f 1
      , r', f d
      , r, r', j 3
      , r, j 1.5
      , l, l
      ]
    one = concat 
      [ r, f 1
      , l, l, f 0.5
      , r, f 3
      , l, l', f d
      , j d
      , l', j 2
      , l, j 2.5
      , l
      ]

    f a = [PenDown, Accelerate a, Forward, Accelerate (1/a), PenUp]
    j a = [PenUp, Accelerate a, Forward, Accelerate (1/a), PenDown]

    -- Left/Right turns, 90 degrees. Primed versions (the ones with an
    -- ' after: l', r') are 45 degrees.
    l = [Turn (pi / 2)]
    l' = [Turn (pi / 4)]
    r = [Turn (-pi / 2)]
    r' = [Turn (-pi / 4)]

    -- Diagonal length of a right-angle triangle with both sides 0.5
    d = sqrt (2)/2

-- | Another test graphic (made blind)
hi :: [TurtleCommand]
hi = concat [start, h, i]
  where
    start = concat
      [ j 1, l, j 3.75, r, r', l']
    
    h = concat
      [ f 5, r
      , r, j 2.5
      , l, f 2.5
      , l, j 2.5
      , r, r
      , f 5, l
      , j 2.5
      ]
    
    i = concat
      [ f 2.5, r
      , r, j 1.25
      , r, f 5
      , r, j 1.25
      , r, r
      , f 2.5
      ]

    f a = [PenDown, Accelerate a, Forward, Accelerate (1/a), PenUp]
    j a = [PenUp, Accelerate a, Forward, Accelerate (1/a), PenDown]

    l = [Turn (pi / 2)]
    l' = [Turn (pi / 4)]
    r = [Turn (-pi / 2)]
    r' = [Turn (-pi / 4)]