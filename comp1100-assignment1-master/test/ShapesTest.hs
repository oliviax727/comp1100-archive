module Main where

import Controller
import Model
import View
import Testing

-- | The list of all tests to run.
tests :: [Test]
tests = toolLabelTests ++ nextColourTests ++ nextToolTests

toolLabelTests :: [Test]
toolLabelTests =
  [ Test "LineTool"
      (assertEqual (toolToLabel (LineTool Nothing))
       "Line... click-drag-release")
  , Test "PolygonTool"
      (assertEqual (toolToLabel (PolygonTool []))
      "Polygon... click 3 or more times then spacebar")
  , Test "RectangleTool"
      (assertEqual (toolToLabel (RectangleTool Nothing))
      "Rectangle... click-drag-release between opposite corners")
  , Test "CircleTool"
      (assertEqual (toolToLabel (CircleTool Nothing))
      "Circle... click-drag-release from opposite points on the circumfrence")
  , Test "ParallelogramTool"
      (assertEqual (toolToLabel (ParallelogramTool Nothing Nothing))
      "Parallelogram... click three points, each adjacent to the next")
  , Test "SquareTool"
      (assertEqual (toolToLabel (SquareTool Nothing))
      "Square... click-drag-release between midpoints of opposite sides")
  ]

nextColourTests :: [Test]
nextColourTests =
  [ Test "Black -> Purple" (assertEqual (nextColour Black) Purple)
  , Test "Purple -> Blue" (assertEqual (nextColour Purple) Blue)
  , Test "Blue -> Green" (assertEqual (nextColour Blue) Green)
  , Test "Green -> Yellow" (assertEqual (nextColour Green) Yellow)
  , Test "Yellow -> Orange" (assertEqual (nextColour Yellow) Orange)
  , Test "Orange -> Red" (assertEqual (nextColour Orange) Red)
  , Test "Red -> Black" (assertEqual (nextColour Red) Black)
  ]

-- | Tests for nextTool, including tests that it doesn't cycle tools
-- midway through a draw.
nextToolTests :: [Test]
nextToolTests =
  [ Test "Line -> Polygon"
      (assertEqual (nextTool (LineTool Nothing)) (PolygonTool []))
  , Test "Polygon -> Rectangle"
      (assertEqual (nextTool (PolygonTool [])) (RectangleTool Nothing))
  , Test "Rectangle -> Circle"
      (assertEqual (nextTool (RectangleTool Nothing)) (CircleTool Nothing))
  , Test "Circle -> Parallelogram"
      (assertEqual (nextTool (CircleTool Nothing)) (ParallelogramTool Nothing Nothing))
  , Test "Parallelogram -> Square"
      (assertEqual (nextTool (ParallelogramTool Nothing Nothing)) (SquareTool Nothing))
  , Test "Square -> Line"
        (assertEqual (nextTool (SquareTool Nothing)) (LineTool Nothing))
  , Test "Line (in use) -> Line"
      (assertEqual (nextTool (LineTool (Just (0,1)))) (LineTool (Just (0,1))))
  , Test "Polygon (in use) -> Polygon"
      (assertEqual (nextTool (PolygonTool [(2,3)])) (PolygonTool [(2,3)]))
  , Test "Rectangle (in use) -> Rectangle"
      (assertEqual (nextTool (RectangleTool (Just (4,5)))) (RectangleTool (Just (4,5))))
  , Test "Circle (in use) -> Circle"
      (assertEqual (nextTool (CircleTool (Just (6,7)))) (CircleTool (Just (6,7))))
  , Test "Parallelogram (in use, first point) -> Parallelogram"
      (assertEqual (nextTool (ParallelogramTool (Just (8,9)) Nothing)) 
      (ParallelogramTool (Just (8,9)) Nothing))
  , Test "Parallelogram (in use, second point) -> Parallelogram"
      (assertEqual (nextTool (ParallelogramTool Nothing (Just (0,1))))
      (ParallelogramTool Nothing (Just (0,1)))) 
  , Test "Parallelogram (in use, both points) -> Parallelogram"
      (assertEqual (nextTool (ParallelogramTool (Just (1,1)) (Just (2,2)))) 
      (ParallelogramTool (Just (1,1)) (Just (2,2))))
  , Test "Square (in use, first point) -> Square"
      (assertEqual (nextTool (SquareTool (Just (1,1)))) 
      (SquareTool (Just (1,1))))
  ]

-- | A Haskell program starts by running the computation defined by
-- 'main'. We run the list of tests that we defined above.
main :: IO ()
main = runTests tests
