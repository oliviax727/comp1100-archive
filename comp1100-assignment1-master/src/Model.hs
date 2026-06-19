--- Copyright 2021 The Australian National University, All rights reserved

module Model where

import CodeWorld

data Shape
  -- | The Line constructor holds the start and end coordinates of the line
  = Line Point Point
  -- | For the Polygon, a list of vertices
  | Polygon [Point]
  -- | Coordinates of opposite corners
  | Rectangle Point Point
  -- | Opposite points on the circumference
  | Circle Point Point
  -- | Coordinates of midpoints on opposite sides of the square  
  | Square Point Point
  -- | Coordinates of opposite corners, then a third corner
  | Parallelogram Point Point Point
  deriving (Show)

type ColourShape = (ColourName, Shape)


data Tool
  = LineTool (Maybe Point)
  | PolygonTool [Point]
  | RectangleTool (Maybe Point)
  | CircleTool (Maybe Point)
  | ParallelogramTool (Maybe Point) (Maybe Point)
  | SquareTool (Maybe Point)
  | SelectTool (Maybe Point) (Maybe Point) -- Task 5.1 and 5.3
  deriving (Eq, Show)

data ColourName
  = Black
  | Purple
  | Blue
  | Green
  | Yellow
  | Orange
  | Red
  | Gray -- Only for selection
  deriving (Eq, Show, Enum)

data Model = Model [ColourShape] Tool ColourName
  deriving (Show)

-- | Starting Model for when CodeWorld first starts up.
emptyModel :: Model
emptyModel = Model [] (LineTool Nothing) Black

-- | A mysterious image. Quack.
mystery :: [ColourShape]
mystery =
 [
     (Purple,
     Line (-6.876404494382022,-0.7415730337078652) 
          (-4.98876404494382,-1.8426966292134832)),
     (Purple,
     Line (-7.213483146067416,-0.7191011235955056) 
          (-4.606741573033708,-1.4606741573033708)),
     (Purple,
     Line (-7.033707865168539,-0.7415730337078652)
          (-4.426966292134831,-0.898876404494382)),
     (Purple,
     Line (5.370786516853933,-0.898876404494382)
          (3.640449438202247,-1.9775280898876404)),
     (Purple,
     Line (5.573033707865169,-1.101123595505618)
          (3.303370786516854,-1.4382022471910112)),
     (Purple,
     Line (5.707865168539326,-0.9887640449438202)
          (2.9887640449438204,-0.651685393258427)),
     (Orange,
     Polygon [
          (-2.1123595505617976,2.6741573033707864),
          (-0.7865168539325843,2.269662921348315),
          (0.2247191011235955,2.359550561797753),
          (1.348314606741573,2.696629213483146),
          (-0.1348314606741573,3.191011235955056),
          (-0.8764044943820225,3.258426966292135)
             ]),
     (Black,
     Square (0.8314606741573034,5.01123595505618)
            (1.101123595505618,4.449438202247191)),
     (Black,
     Square (-2.0,4.876404494382022)
            (-1.4831460674157304,4.404494382022472)),
     (Red,
     Parallelogram (0.7191011235955056,-7.348314606741573) 
                   (1.4157303370786516,-6.426966292134831) 
                   (2.539325842696629,-6.382022471910112)),
     (Red,
     Parallelogram (-4.247191011235955,-6.808988764044944) 
                   (-2.853932584269663,-6.179775280898877) 
                   (-1.2808988764044944,-6.49438202247191)),
     (Yellow,
     Circle (-5.101123595505618,-0.7640449438202247)
            (4.808988764044944,-3.2808988764044944)),
     (Yellow,
     Circle (-3.0786516853932584,4.943820224719101) 
            (2.4719101123595504,1.7752808988764044)),
     (Blue,
     Rectangle (-10.089887640449438,-6.224719101123595) 
               (10.067415730337078,-9.910112359550562))
     ]
