module Lab09 where
    
import Data.Char
import DrawTree
-- Week 9 Trees
-- David Quarel 12/02/2019

-- data BinaryTree a = Null | Node (BinaryTree a) a (BinaryTree a)
--    deriving Show

tree1 :: BinaryTree Integer
tree1 = Node (Node (Node Null 2 (Node Null 11 Null)) 4 (Node (Node Null 0 Null) 
    1 (Node Null (-3) Null))) 5 (Node (Node (Node Null (-4) Null) 8 
    (Node Null 7 Null)) 3 Null)

{-
Exercise 1: treeSize

Counts the number of elements in a tree
-}

treeSize :: BinaryTree a -> Int
treeSize Null = 0
treeSize (Node left _ right) = 1 + treeSize right + treeSize left

{-
Exercise 2: treeDepth

Write a function that computes the depth of a tree, which is defined as
the length of the longest path from the root node down to any leaf.
-}

-- | Depth of binary tree
-- >>> treeDepth Null
-- 0
-- >>> treeDepth (Node Null 3 Null)
-- 1
-- >>> treeDepth (Node (Node Null 1 Null) 2 (Node Null 3 Null))
-- 2
-- >>> treeDepth (Node Null 1 (Node Null 2 (Node Null 3 Null)))
-- 3
treeDepth :: BinaryTree a -> Int
treeDepth Null = 0
treeDepth (Node left _ right) = 1 + max (treeDepth left) (treeDepth right)

{-
Exercise 3: flattentree

Write a function that takes a tree, and returns a list containing
all the elements from that tree. We call such an operation **flattening**
a tree.
-}

-- | Returns a list of all elements in the tree
-- >>> flattenTree Null
-- []
-- >>> flattenTree (Node Null 3 Null)
-- [3]
-- >>> flattenTree (Node (Node Null 1 Null) 2 (Node Null 3 Null))
-- [2,1,3]
-- >>> flattenTree (Node Null 1 (Node Null 2 (Node Null 3 Null)))
-- [1,2,3]
flattenTree :: BinaryTree a -> [a]
flattenTree Null = []
flattenTree (Node left x right) = x : (flattenTree left ++ flattenTree right)

{-
Exercise 4: leavesTree

Write a function that takes a tree, and returns a list containing
only the elements in leaf nodes.
-}

-- | Returns a list of all leaves of the tree
-- >>> leavesTree Null
-- []
-- >>> leavesTree (Node Null 3 Null)
-- [3]
-- >>> leavesTree (Node (Node Null 1 Null) 2 (Node Null 3 Null))
-- [1,3]
-- >>> leavesTree (Node Null 1 (Node Null 2 (Node Null 3 Null)))
-- [3]
leavesTree :: BinaryTree a -> [a]
leavesTree Null = []
leavesTree (Node Null x Null) = [x]
leavesTree (Node left _ right) = leavesTree left ++ leavesTree right


{-
Exercise 5: treeMap

Write a function that works analogously to `map`, by applying a function
to each node in a tree.
-}

-- | Performs a function on every element of the binary tree
-- >>> treeMap (*2) (Node Null 3 (Node Null 5 Null))
-- Node Null 6 (Node Null 10 Null)
treeMap :: (a -> b) -> BinaryTree a -> BinaryTree b
treeMap f (Node left x right) = Node (treeMap f left) (f x) (treeMap f right)
treeMap _ Null = Null

{-
Exercise 6: elemTree

Write a function that takes an `Integer`, and checks if it is
present inside a tree of `Integer`'s.
-}

-- | Generalised function to tell if element is in tree
-- >>> elemTree 2 Null
-- False
-- >>> elemTree 3 (Node Null 4 (Node Null 3 Null))
-- True
elemTree :: Eq a => a -> BinaryTree a -> Bool
elemTree _ Null = False 
elemTree y (Node left x right) = x == y || elemTree y left || elemTree y right

{- 
Exercise 7: treeMaximum

Write two functions, to find the minimum and maximum element in a tree
of type `Integer`.
-}

-- | Max/Min element in tree
-- >>> treeMaximum tree1
-- 11
-- >>> treeMinimum tree1
-- -4
treeMaximum :: BinaryTree Integer -> Integer
treeMaximum Null = error "No elements in tree"
treeMaximum (Node left x right) = case (left, right) of
  (Null, Null) -> x
  (Null, r) -> max x (treeMaximum r)
  (l, Null) -> max x (treeMaximum l)
  (l, r) -> max (max (treeMaximum r) (treeMaximum l)) x

treeMinimum :: BinaryTree Integer -> Integer
treeMinimum Null = error "No elements in tree"
treeMinimum (Node left x right) = case (left, right) of
  (Null, Null) -> x
  (Null, r) -> min x (treeMinimum r)
  (l, Null) -> min x (treeMinimum l)
  (l, r) -> min (min (treeMinimum r) (treeMinimum l)) x

-- =========== ROSE TREES ============

data RoseTree a = RoseNode a [RoseTree a]
    deriving Show

-- | A rose tree of things
-- >>> roseSize things
-- 27
-- >>> length (roseLeaves things)
-- 16
-- >>> length (roseFlatten things)
-- 27
things :: RoseTree String
things = 
    RoseNode "thing" [
        RoseNode "animal" [
            RoseNode "cat" [], RoseNode "dog" []
        ],
        
        RoseNode "metal" [
            RoseNode "alloy" [
                RoseNode "steel" [], RoseNode "bronze" []
            ],
            RoseNode "element" [
                RoseNode "gold" [], RoseNode "tin" [], RoseNode "iron" []
            ]
        ],
        
        RoseNode "fruit" [
            RoseNode "apple" [
                RoseNode "Granny Smith" [], RoseNode "Pink Lady" []
            ],
            RoseNode "banana" [],
            RoseNode "orange" []
        ],

        RoseNode "astronomical object" [
            RoseNode "Planet" [
                RoseNode "Earth" [], RoseNode "Mars" []
            ],
            RoseNode "Star" [
                RoseNode "The Sun" [], RoseNode "Sirius" []
            ],
            RoseNode "Galaxy" [
                RoseNode "Milky Way" []
            ]
        ]
    ] 

{-
Exercise 8: roseSize

Write a function
that counts the number of elements in a rosetree.
-}

roseSize :: RoseTree a -> Int
roseSize (RoseNode _ []) = 1
roseSize (RoseNode y (x:xs)) = roseSize x + roseSize (RoseNode y xs)

{-
Exercise 9: roseLeaves

Write a function
that returns a list of all leaves of the rosetree.
-}

roseLeaves :: RoseTree a -> [a]
roseLeaves (RoseNode y []) = [y]
roseLeaves (RoseNode _ [x]) = roseLeaves x
roseLeaves (RoseNode y (x:xs)) = roseLeaves x ++ roseLeaves (RoseNode y xs)

{-
Exercise 10: roseFlatten

Write a function
that returns a list of all elements in the rosetree.
-}

roseFlatten :: RoseTree a -> [a]
roseFlatten (RoseNode y []) = [y]
roseFlatten (RoseNode y (x:xs)) = roseFlatten x ++ roseFlatten (RoseNode y xs)



-- Turns strings into all upper case
allCaps :: String -> String
allCaps = map toUpper

{-
Exercise 11: roseMap

Write a function
that takes a function, and applies it to every element of a rosetree.
Test the result by mapping the function `allCaps` to the rosetree `things`.
All the elements should now be written in uppercase.
-}

-- | Performs a function on every item in a rose tree
roseMap :: (a -> b) -> RoseTree a -> RoseTree b
roseMap f (RoseNode x []) = RoseNode (f x) []
roseMap f (RoseNode x xs) = RoseNode (f x) (map (roseMap f) xs)

{-
Exercise 12: binaryTreeToRose

Write a function
that converts a binary tree to a rosetree. The new rosetree should
have the same structure as the binary tree.

-}

-- | Converts a binary tree to a rose
-- >>> binaryTreeToRose (Node (Node Null 1 Null) 2 (Node Null 3 Null))
-- RoseNode 2 [RoseNode 1 [],RoseNode 3 []]
binaryTreeToRose :: BinaryTree a -> RoseTree a
binaryTreeToRose Null = error "Cannot convert an empty tree"
binaryTreeToRose (Node left x right) = case (left, right) of
  (Null, Null) -> RoseNode x []
  (Null, r) -> RoseNode x [binaryTreeToRose r]
  (l, Null) -> RoseNode x [binaryTreeToRose l]
  (l, r) -> RoseNode x [binaryTreeToRose l, binaryTreeToRose r]

-- =========== EXTENSIONS =============

{-

Extension 1

Write a function 
that verifies if a tree is **balanced**, that is, there is no other way to
restructure the tree such that it has smaller depth.
-}

balancedTree :: BinaryTree Integer
balancedTree = Node (Node (Node Null 2 Null) 1 Null) 3 (Node (Node Null 5 Null) 4 Null)

-- | Checks if a tree can have a smaller depth
-- >>> isBalanced tree1
-- True
-- >>> isBalanced balancedTree
-- True
-- >>> isBalanced (Node Null 4 (Node Null 3 Null))
-- True
-- >>> isBalanced (Null)
-- True
-- >>> isBalanced (Node Null 3 Null)
-- True
-- >>> isBalanced (Node Null 1 (Node Null 2 (Node Null 3 Null)))
-- False
-- >>> isBalanced (Node (Node Null 3 Null) 1 (Node (Node Null 5 Null) 2 (Node Null 4 (Node Null 6 Null))))
-- False
isBalanced :: BinaryTree a -> Bool
isBalanced t = treeSize t > maxElements (treeDepth t - 1)
  where
    maxElements :: Int -> Int
    maxElements n
      | n > 0 = (2 ^ (n - 1)) + maxElements (n-1)
      | otherwise = n

-- | Checks if the tree is balanced
--   (in the sense that there is an equal
--   distribution of nodes on either side)
-- >>> isBalancedAdv tree1
-- False
-- >>> isBalancedAdv (Node Null 4 (Node Null 3 Null))
-- False
-- >>> isBalancedAdv (Null)
-- True
-- >>> isBalancedAdv (Node Null 3 Null)
-- True
-- >>> isBalancedAdv (Node Null 1 (Node Null 2 (Node Null 3 Null)))
-- False
-- >>> isBalancedAdv (Node (Node Null 3 Null) 1 (Node (Node Null 5 Null) 2 (Node Null 4 (Node Null 6 Null))))
-- False
-- >>> isBalancedAdv (Node (Node Null 1 Null) 2 (Node Null 3 Null))
-- True
-- >>> isBalancedAdv balancedTree
-- True
-- >>> isBalancedAdv (Node (Node (Node (Node Null 6 Null) 2 Null) 1 Null) 3 (Node (Node Null 5 Null) 4 (Node Null 7 Null)))
-- False
isBalancedAdv :: BinaryTree a -> Bool
isBalancedAdv Null = True
isBalancedAdv (Node left x right) = isBalanced (Node left x right) && treeSize left == treeSize right