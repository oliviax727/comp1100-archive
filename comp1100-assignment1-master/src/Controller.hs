--- Copyright 2021 The Australian National University, All rights reserved

module Controller where

import CodeWorld
import Model
import View

import Data.Text (pack, unpack)

-- | Compute the new Model in response to an Event.
handleEvent :: Event -> Model -> Model
handleEvent event m@(Model ss t c) =
  case event of
    KeyPress key
      -- revert to an empty canvas
      | k == "Esc" -> emptyModel

      -- write the current model to the console
      | k == "E" -> trace (pack (show m)) m

      -- display the mystery image
      | k == "M" -> Model mystery t c

      | k == "Backspace" || k == "Delete" -> if not (null ss) then Model (tail ss) t c else Model ss t c  -- Drop the last added shape

      | k == " " -> if isPoly t then Model (toolToShape c (0, 0) t : ss) (nullTool t) c else Model ss t c  -- finish polygon vertices

      | k == "T" -> if isSel t && not (null ss) then Model (tail ss) (nextTool (SelectTool Nothing Nothing)) c else Model ss (nextTool t) c  -- Switch tool

      | k == "C" -> Model ss t (nextColour c)  -- Switch colour

      | k == "X" -> Model (flipX ss) t c  -- Flip by X-Axis

      | k == "Y" -> Model (flipY ss) t c  -- Flip by Y-Axis

      | k == "Q" -> if isSel t then Model (deleteShapes t ss) (SelectTool Nothing Nothing) c else Model ss t c -- Delete Selected Shapes

      | k == "W" -> if isSel t then Model (translateShapes (0, 1) t (tail ss)) (SelectTool Nothing Nothing) c else Model ss t c -- Translate Up

      | k == "A" -> if isSel t then Model (translateShapes (- 1, 0) t (tail ss)) (SelectTool Nothing Nothing) c else Model ss t c -- Translate Left

      | k == "S" -> if isSel t then Model (translateShapes (0, - 1) t (tail ss)) (SelectTool Nothing Nothing) c else Model ss t c -- Translate Down

      | k == "D" -> if isSel t then Model (translateShapes (1, 0) t (tail ss)) (SelectTool Nothing Nothing) c else Model ss t c -- Translate Right

      -- ignore other events
      | otherwise -> m
      where
        k = unpack key

    PointerPress p -> if isIncomplete t 
      then (if isSel t && not (null ss)
        then Model (tail ss) (appendPoint p t) c
        else Model ss (appendPoint p t) c) 
      else Model (toolToShape c p t : ss) (nullTool t) c -- Append Point to object

    PointerRelease p -> case t of
      PolygonTool _ -> Model ss t c
      ParallelogramTool _ _ -> Model ss t c
      SelectTool _ _ -> Model (toolToShape c p t : ss) (appendPoint p t) c -- Display selection window
      _ -> Model (toolToShape c p t : ss) (nullTool t) c -- Turn object into colourshape

    _ -> m

-- Cycles through colour options
nextColour :: ColourName -> ColourName
nextColour c = case c of
  Black -> Purple
  Purple -> Blue
  Blue -> Green
  Green -> Yellow
  Yellow -> Orange
  Orange -> Red
  Red -> Black
  Gray -> Gray

-- Apparently it's not defined
isNothing :: Maybe Point -> Bool
isNothing p = case p of
  Just _ -> False
  Nothing -> True

-- Line -> Polygon -> Rectangle -> Circle -> Parallelogram -> Square -> Selection -> Line
-- Cycles through tool options - this 'technically' fails part A
nextTool :: Tool -> Tool
nextTool t = case t of
  LineTool arg -> if isNothing arg then PolygonTool [] else LineTool arg
  PolygonTool list -> if null list then RectangleTool Nothing else PolygonTool list
  RectangleTool arg -> if isNothing arg then CircleTool Nothing else RectangleTool arg
  CircleTool arg -> if isNothing arg then ParallelogramTool Nothing Nothing else CircleTool arg
  ParallelogramTool arg1 arg2 -> if isNothing arg1 && isNothing arg2 then SquareTool Nothing else ParallelogramTool arg1 arg2
  SquareTool arg -> if isNothing arg then SelectTool Nothing Nothing else SquareTool arg
  SelectTool arg1 arg2 -> if isNothing arg1 && isNothing arg2 then LineTool Nothing else SelectTool arg1 arg2

appendPoint :: Point -> Tool -> Tool
appendPoint p t = case t of
  LineTool _ -> LineTool (Just p)
  SquareTool _ -> SquareTool (Just p)
  RectangleTool _ -> RectangleTool (Just p)
  CircleTool _ -> CircleTool (Just p)
  SelectTool Nothing _ -> SelectTool (Just p) Nothing
  SelectTool (Just arg) Nothing -> SelectTool (Just arg) (Just p)
  SelectTool _ _ -> SelectTool (Just p) Nothing
  PolygonTool arg -> PolygonTool (p:arg)
  ParallelogramTool Nothing _ -> ParallelogramTool (Just p) Nothing
  ParallelogramTool arg _ -> ParallelogramTool arg (Just p)

nullTool :: Tool -> Tool
nullTool t = case t of
  LineTool _ -> LineTool Nothing
  SquareTool _ -> SquareTool Nothing
  RectangleTool _ -> RectangleTool Nothing
  CircleTool _ -> CircleTool Nothing
  PolygonTool _ -> PolygonTool []
  ParallelogramTool _ _ -> ParallelogramTool Nothing Nothing
  _ -> t

-- Checks the properties of the tool, for completed parallellograms, polygons, and selections
isIncomplete :: Tool -> Bool
isIncomplete t = case t of
  ParallelogramTool _ arg2 -> isNothing arg2
  _ -> True

isPoly :: Tool -> Bool
isPoly t = case t of
  PolygonTool a -> length a > 2
  _ -> False

isSel :: Tool -> Bool
isSel t = case t of
  SelectTool arg1 arg2 -> not (isNothing arg1 && isNothing arg2)
  _ -> False

-- Translate ColourShapes
translateShape :: Point -> ColourShape -> ColourShape
translateShape p (c, s)= case s of
  Line a b -> (c, Line (vecAdd p a False) (vecAdd p b False))
  Square a b -> (c, Square (vecAdd p a False) (vecAdd p b False))
  Circle a b -> (c, Circle (vecAdd p a False) (vecAdd p b False))
  Rectangle a b -> (c, Rectangle (vecAdd p a False) (vecAdd p b False))
  Parallelogram x y z -> (c, Parallelogram (vecAdd p x False) (vecAdd p y False) (vecAdd p z False))
  Polygon a -> (c, Polygon (vecsAdd p a False))

-- Determine if point(s) is in range
pointInRange :: Point -> Point -> Point -> Bool
pointInRange (x1, y1) (x2, y2) (a, b) =
  ((x1 <= a && a <= x2) || (x1 >= a && a >= x2)) &&
  ((y1 <= b && b <= y2) || (y1 >= b && b >= y2))

pointsInRange :: Point -> Point -> [Point] -> Bool
pointsInRange _ _ [] = True
pointsInRange r1 r2 [x] = pointInRange r1 r2 x
pointsInRange r1 r2 (x:xs) = pointInRange r1 r2 x && pointsInRange r1 r2 xs

-- Determine if shape lies in selected range
shapeInRange :: Point -> Point -> ColourShape -> Bool
shapeInRange r1 r2 (_, t) = case t of
  Line a b -> pointInRange r1 r2 a && pointInRange r1 r2 b
  Square a b -> pointsInRange r1 r2 (squarePoints a b)
  Circle a b -> pointInRange r1 r2 a && pointInRange r1 r2 b && pointsInRange r1 r2 (squareInCircle a b) -- Cannot completely detect circles in range
  Rectangle a b -> pointInRange r1 r2 a && pointInRange r1 r2 b
  Parallelogram a b c -> pointInRange r1 r2 a && pointInRange r1 r2 b && pointInRange r1 r2 c && pointInRange r1 r2 (vecAdd (vecAdd a c False) b True)
  Polygon a -> pointsInRange r1 r2 a

-- Translate a set of shapes in a given range
-- The first argument is the vector translation
translateShapes :: Point -> Tool -> [ColourShape] -> [ColourShape]
translateShapes _ _ [] = []
translateShapes p (SelectTool (Just r1) (Just r2)) [s] = if shapeInRange r1 r2 s then [translateShape p s] else [s]
translateShapes p (SelectTool (Just r1) (Just r2)) (x:xs)
  | shapeInRange r1 r2 x = translateShape p x : translateShapes p (SelectTool (Just r1) (Just r2)) xs
  | otherwise = x : translateShapes p (SelectTool (Just r1) (Just r2)) xs
translateShapes _ _ ss = ss

-- Delete a set of shapes in a given range
deleteShapes :: Tool -> [ColourShape] -> [ColourShape]
deleteShapes _ [] = []
deleteShapes (SelectTool (Just r1) (Just r2)) [s] = [s | not (shapeInRange r1 r2 s)]
deleteShapes (SelectTool (Just r1) (Just r2)) [x, y]
  | shapeInRange r1 r2 x && shapeInRange r1 r2 y = []
  | shapeInRange r1 r2 y = [x]
  | shapeInRange r1 r2 x = [y]
  | otherwise = [x, y]
deleteShapes (SelectTool (Just r1) (Just r2)) (x:y:xs)
  | shapeInRange r1 r2 x = deleteShapes (SelectTool (Just r1) (Just r2)) (y:xs)
  | shapeInRange r1 r2 y = deleteShapes (SelectTool (Just r1) (Just r2)) (x:xs)
  | otherwise = x:y:deleteShapes (SelectTool (Just r1) (Just r2)) xs
deleteShapes _ ss = ss