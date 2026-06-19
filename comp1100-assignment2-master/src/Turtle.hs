{-|
Module      : Turtle
Description : The main module used for producing turtle objects
Maintainer  : u7280249@anu.edu.au

It also contains all functions pertaining to L-Systems.

-}

module Turtle where

import CodeWorld hiding (polygon)

type Radians = Double

-- | The commands that we can send to our turtle.
data TurtleCommand
  = Forward -- ^ Drive forward the current number of units,
            -- drawing a line if the pen is down.
  | PenUp -- ^ Set the pen into the "Up" position. Calls to 
          -- Forward will not draw until a call to PenDown.
  | PenDown -- ^ Set the pen into the "Down" position. Calls to 
            -- Forward will draw until a call to PenUp.
  | Turn Radians -- ^ Turn the turtle. Positive values are
                 -- anticlockwise; negative values are clockwise.
  | Accelerate Double -- ^ Multiply the step size by the given factor 
  deriving (Eq, Show)

-- Task 1: Drawing Shapes

-- | Draws a triangle, returning pen to it's initial state
triangle :: Double -> [TurtleCommand]
triangle x =
  [ Accelerate x, PenDown
  , Forward, Turn (2 * pi / 3)
  , Forward, Turn (2 * pi / 3)
  , Forward, Turn (2 * pi / 3)
  , PenUp, Accelerate (1 / x)
  ]

-- | Draws an n-gon, returning pen to it's initial state
polygon :: Int -> Double -> [TurtleCommand]
polygon n x =
  [Accelerate x, PenDown] ++
  polyAcc (fromIntegral n) n [] ++
  [PenUp, Accelerate (1 / x)]
  where
    -- | Helper function for producing a polygon from turtle commands
    polyAcc :: Double -> Int -> [TurtleCommand] -> [TurtleCommand]
    polyAcc _ 0 l = l
    polyAcc sides i l =
      polyAcc sides (i-1) (l ++ [Forward, Turn (2 * pi / sides)])


-- Task 2: Interpreting Turtle Commands

-- ^ Pen <Old Position> <New/Current Position> <Direction> <Speed> <is it Down?>
data Pen = Pen Point Point Radians Double Bool
  deriving (Eq, Show)

-- | Initial pen state
initialPen :: Pen
initialPen = Pen (0, 0) (0, 0) (pi / 2) 1.0 False

-- | Function that applies a turtle command to a pen
affectPen :: Pen -> TurtleCommand -> Pen
affectPen pen t =
  case pen of
  Pen _ (x2, y2) r v d ->
    case t of
    Accelerate a -> Pen (x2, y2) (x2, y2) r (v * a) d
    Turn a -> Pen (x2, y2) (x2, y2) (r + a) v d
    PenUp -> Pen (x2, y2) (x2, y2) r v False
    PenDown -> Pen (x2, y2) (x2, y2) r v True
    Forward -> Pen (x2, y2) (x2 + (v * cos r), y2 + (v * sin r)) r v d

-- | Turns a series of turtle commands into a codeworld picture
runTurtle :: [TurtleCommand] -> Picture
runTurtle = turtleAcc initialPen
  where
    -- | An accumulator fucntion to store the value of the pen
    turtleAcc :: Pen -> [TurtleCommand] -> Picture
    turtleAcc _ [] = blank
    turtleAcc p (x:xs) =
      case p of
        Pen old new _ _ down ->
          createLine old new down & turtleAcc (affectPen p x) xs

    -- | Helper function that creates a line given the pen is down
    createLine :: Point -> Point -> Bool -> Picture
    createLine x y d = if d then polyline [x, y] else blank


-- Task 3: Self-similar drawings

data LSystem a = LSystem [a] [(a, [a])] -- ^ LSystem <Seed> <Production Rules>

-- | Generic alphabet that can be used for both the Hilbert/Sierpinski Alphabets.
-- Using +/- causes errors so R/L is used instead
data TurtleAlphabet = T | F | A | B | P | N
  deriving (Show, Eq)

-- | Interprets an arbitrary L-System (MUST HOLD Eq PROPERTY)
interpretLSystem :: Eq a => LSystem a -> Int -> [a]
interpretLSystem sys n
  | n == 0 = case sys of
    LSystem str _ -> str
  | n > 0 =
    case sys of
    LSystem str prod ->
      interpretLSystem (LSystem (expand str prod) prod) (n - 1)
  | otherwise =
    error "The iteration value must be an integer greater than or equal to zero"
  where
    -- | Performs an iteration on the L-System
    expand :: Eq a => [a] -> [(a, [a])] -> [a]
    expand [] _ = []
    expand (s:ss) rule = expandSingle s rule ++ expand ss rule

    -- | Performs a production rule on a single L-System token
    expandSingle :: Eq a => a -> [(a, [a])] -> [a]
    expandSingle s [] = [s]
    expandSingle s (r:rs) = case r of
      (token, sub) -> if token == s then sub else expandSingle s rs

type SierpinskiAlphabet = TurtleAlphabet

-- | Sierpinski Curve L-System
sierpinskiSystem :: LSystem SierpinskiAlphabet
sierpinskiSystem = LSystem [T] [(T, [T,F,A,T,P,F,A,N,T,N,F,A,P]), (A, [F,A,A])]

-- | Constructs a Sierpinski Triangle using an L-System
sierpinski :: Int -> [TurtleCommand]
sierpinski n =
  PenDown : Turn (pi / 6) : foldr (\x y -> alphabetToCommand x ++ y) [] (interpretLSystem sierpinskiSystem n)
  where
    -- | Converts a sierpinski token to it's equvalent turtle command
    alphabetToCommand :: SierpinskiAlphabet -> [TurtleCommand]
    alphabetToCommand a = case a of
      T -> foldr (\x y -> alphabetToCommand x ++ y) [] [F,P,F,P,F,P]
      F -> [Forward]
      P -> [Turn (2 * pi / 3)]
      N -> [Turn (- 2 * pi / 3)]
      _ -> []


type HilbertAlphabet = TurtleAlphabet

-- | Hilbert Curve L-System
hilbertSystem :: LSystem HilbertAlphabet
hilbertSystem =
  LSystem [A] [(A, [P,B,F,N,A,F,A,N,F,B,P]), (B, [N,A,F,P,B,F,B,P,F,A,N])]

-- | Constructs an order n hilbert curve using an L-System
hilbert :: Int -> [TurtleCommand]
hilbert n =
  PenDown : foldr (\x y -> alphabetToCommand x ++ y) [] (interpretLSystem hilbertSystem n)
  where
    -- | Converts a hilbert token to it's equvalent turtle command
    alphabetToCommand :: HilbertAlphabet -> [TurtleCommand]
    alphabetToCommand a = case a of
      F -> [Forward]
      P -> [Turn (pi / 2)]
      N -> [Turn (-pi / 2)]
      _ -> []