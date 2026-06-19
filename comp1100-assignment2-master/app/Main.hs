{-# LANGUAGE OverloadedStrings #-}

module Main where

import CodeWorld
import TestPattern
import qualified Turtle as Turtle

data Mode
  = Triangle
  | Polygon Int
  | Comp1100
  | Hi
  | Sierpinski Rescaled Int -- ^ The Cantor set has been replaced with the sierpinski triangle
  | Hilbert Rescaled Int

type Rescaled = Bool

main :: IO ()
main = interactionOf Comp1100 unchanging handleEvent render

unchanging :: Double -> Mode -> Mode
unchanging _ mode = mode

handleEvent :: Event -> Mode -> Mode
handleEvent (KeyPress k) mode
  | k == "M" = Comp1100
  | k == "I" = Hi
  | k == "S" = Sierpinski True 2
  | k == "H" = Hilbert True 2
  | k == "T" = Triangle
  | k == "P" = case mode of
      Polygon _ -> mode
      _ -> Polygon 5
  | k == "-" = case mode of
      Polygon n -> Polygon (max (pred n) 3)
      Sierpinski p n -> Sierpinski p (max (pred n) 0)
      Hilbert p n -> Hilbert p (max (pred n) 0)
      _ -> mode
  | k == "=" = case mode of
      Polygon n -> Polygon (succ n)
      Sierpinski p n -> Sierpinski p (succ n)
      Hilbert p n -> Hilbert p (succ n)
      _ -> mode
  | k == "Z" = case mode of
      Sierpinski p n -> Sierpinski (not p) n
      Hilbert p n -> Hilbert (not p) n
      _ -> mode
handleEvent _ mode = mode

render :: Mode -> Picture
render mode = picture & coordinatePlane
  where
    c = coloured red -- INPUT CHANGED FOR SERPINSKI TRIANGLE
    if' p a b
      | p = a
      | otherwise = b  
    picture = case mode of
             Triangle -> c $ Turtle.runTurtle $ Turtle.triangle 4
             Polygon n -> c $ Turtle.runTurtle $ Turtle.polygon n 4
             Comp1100 -> c $ Turtle.runTurtle comp1100
             Hi -> c $ Turtle.runTurtle hi
             Hilbert p n -> c $ if' p 
                          (rotated (- pi/2) . translated (10 - (10 / (2 ** fromIntegral n))) (-10  + (10 / (2 ** fromIntegral n))) . scaled (20 * 2 ** (- fromIntegral n)) (20 * 2 ** (- fromIntegral n))) id $
                          Turtle.runTurtle $ Turtle.hilbert n
             Sierpinski p n -> c $ if' p (scaled (10 * 2 ** (- fromIntegral n)) (10 * 2 ** (- fromIntegral n))) id $
                          Turtle.runTurtle $ Turtle.sierpinski n -- INPUT CHANGED FOR SERPINSKI TRIANGLE
