{-
(Excersise 1)

Listed Type Clases (All are show/read except Integer -> Integer):
Eq Ord Enum Bounded Num Foldable

Data Type:        Deriving Type Classes:

Integer         Eq, Ord, Enum, Num
Double          Eq, Ord, Num
Char          Eq, Ord, Enum
Bool          Eq, Ord, Enum, Bounded
(Integer, Integer)    Eq
(Integer, Double)     Eq
String          Eq, Foldable
[Integer]         Eq, Foldable
Integer -> Integer    None
Maybe Integer       Eq

-}

module Lab10 where

import DrawTree
-- Week 10 Type Classes 
-- David Quarel 16/02/2019

{-
Exercise 2:

What are the types of these functions?
(Don't just cheat and punch it in GHCi. Try to work it out yourself.)
-}

cow :: (Foldable t, Eq a) => Bool -> a -> t a -> Bool
cow x y z = x && elem y z

foo :: (Foldable t1, Foldable t2, Eq a, Eq (t1 a)) => a -> t1 a -> t2 (t1 a) -> Bool
foo x y z = elem x y && elem y z

bar :: Num a => a -> Maybe a -> a
bar x y = case y of
  Nothing -> x
  Just z  -> x + z

snap :: (Ord a, Show a) => a -> a -> String
snap x y
  |x > y = show x
  |otherwise = show y

{-
Exercise 3A, 3B: Defining equality and ordering on Nat

Using the template given, define all the functions required for
`Nat` to be a member of `Eq` and `Ord`.

DO NOT USE "deriving Eq" or "deriving Ord". 
You should define the instances of (==) and (<=) yourself.
-}

-- | Natural encoding
-- >>> (S (S Z)) == (S (S Z))
-- True
-- >>> (S (S Z)) == (S Z)
-- False
-- >>> (S (S Z)) > (S Z)
-- True
-- >>> (S (S Z)) <= (S (S Z))
-- True
-- >>> (S (S Z)) < (S Z)
-- False
data Nat = Z | S Nat
  deriving (Show)

instance Eq Nat where
  (==) Z Z = True
  (==) x y = case (x, y) of
    (S nx, S ny) -> nx == ny
    _ -> False

  (/=) x y = not $ (==) x y

instance Ord Nat where
  (<=) x y = (==) x y || (<) x y
  (>=) x y = (==) x y || (>) x y

  (<) x y = case (x, y) of
    (S nx, S ny) -> (<) nx ny
    (Z, S _) -> True
    _ -> False
  
  (>) x y = case (x, y) of
    (S nx, S ny) -> (>) nx ny
    (S _, Z) -> True
    _ -> False

-- ======= BINARY SEARCH TREES =========

--data BinaryTree a = Null | Node (BinaryTree a) a (BinaryTree a)
--  deriving Show

type BSTree a = BinaryTree a

notBSTree :: BinaryTree Integer
notBSTree = Node (Node (Node Null 1 Null) 3 (Node Null 2 Null))
          5
         (Node (Node Null 6 Null) 7 (Node Null 9 Null))

-- I've tried my best to textually display the tree in a nice way
-- Sorry if it's more confusing now

goodTree :: BSTree Integer
goodTree =  Node 
        (Node
          (Node 
            (Node 
                Null 
              1 
                Null) 
          3 
            (Node 
                Null 
              5 
                Null))
        7
          (Node   
            (Node 
                Null 
              10 
                Null) 
          12 
            (Node 
                Null 
              13 
                Null)))
      15

        (Node 
          (Node
            (Node 
                Null 
              16 
                Null) 
          17 
            (Node 
                Null 
              18 
                Null))
        23
          (Node
            (Node 
                Null 
              25 
                Null) 
          26 
            (Node 
                Null 
              31 
                Null)))

badTree :: BSTree Integer
badTree = Node (Node Null 1 Null) 3
      (Node (Node Null 5 Null) 7
        (Node (Node Null 10 Null) 12
          (Node (Node Null 13 Null) 15
            (Node (Node Null 16 Null) 17
              (Node (Node Null 18 Null) 23
                (Node (Node Null 25 Null) 26
                    (Node Null 31 Null)))))))

smallTree :: BSTree Integer
smallTree = Node (Node Null 1 Null) 5 (Node Null 10 Null)

{-
Exercise 4: elemBSTree

Rewrite the `elemTree` function from Lab 9 before, but this time you may assume
that the input tree satisfies the binary search ordering constraint. Do
not use the same function as before, you should be able to search more
efficiently, as we did in the example above.

-}

-- | Element of ordered tree
-- >>> elemBSTree 5 goodTree
-- True
-- >>> elemBSTree 30 goodTree
-- False
elemBSTree :: (Ord a) => a -> BSTree a -> Bool
elemBSTree _ Null = False
elemBSTree x (Node left y right)
  | x == y = True
  | x < y = elemBSTree x left
  | otherwise = elemBSTree x right

{-
Exercise 5: treeBSMax

Rewrite the `treeMaximum` and `treeMinimum` functions, again assuming
the input tree is a binary search tree. Be efficient!
-}

-- | Max/Min of BSTree
-- >>> treeBSMax goodTree
-- 31
-- >>> treeBSMin goodTree
-- 1
treeBSMax :: (Ord a) => BSTree a -> a
treeBSMax Null = error "Null input"
treeBSMax (Node Null x Null) = x
treeBSMax (Node _ _ right) = treeBSMax right

treeBSMin :: (Ord a) => BSTree a -> a
treeBSMin Null = error "Null input"
treeBSMin (Node Null x Null) = x
treeBSMin (Node left _ _) = treeBSMin left

{-
Exercise 6: isBSTree

Write a function 
that takes a `BinaryTree Integer` as input, and checks if the
binary search constraint holds.
-}

-- | Determines if it's a Binary Search Tree
-- >>> isBSTree goodTree
-- True
-- >>> isBSTree badTree
-- True
-- >>> isBSTree notBSTree
-- False
isBSTree :: (Ord a) => BinaryTree a -> Bool
isBSTree Null = True
isBSTree (Node left x right) = case (left, right) of
  (Null, Null) -> True
  (Node _ l _, Null) -> l < x && isBSTree left && isBSTree right
  (Null, Node _ r _) -> r > x && isBSTree left && isBSTree right
  (Node _ l _, Node _ r _) -> l < x && r > x && isBSTree left && isBSTree right

{-
Exercise 7: treeInsert

Write a function that takes a binary search tree, and an element, and inserts
that element into the tree, ensuring the binary search property still holds.
(If the element is already in the tree, leave the tree unchanged.)
-}

-- | Inserts an element into a tree
-- >>> treeInsert smallTree 3
-- Node (Node Null 1 (Node Null 3 Null)) 5 (Node Null 10 Null)
-- >>> treeInsert smallTree 20
-- Node (Node Null 1 Null) 5 (Node Null 10 (Node Null 20 Null))
-- >>> treeInsert smallTree 1
-- Node (Node Null 1 Null) 5 (Node Null 10 Null)
treeInsert :: (Ord a) => BSTree a -> a -> BSTree a
treeInsert Null n = Node Null n Null
treeInsert (Node left x right) n
  | n > x = Node left x (treeInsert right n)
  | n < x = Node (treeInsert left n) x right
  | otherwise = Node left x right

{-    
Exercise 8: flattenTreeOrd

Write a function
that flattens a binary search tree, but preserves the ordering.
(That is, when a binary search tree is flattened, the resulting list
should be sorted.)
-}

-- | Flattens an ordered tree
-- >>> flattenTreeOrd smallTree
-- [1,5,10]
-- >>> flattenTreeOrd notBSTree
-- [1,3,2,5,6,7,9]
flattenTreeOrd :: BSTree a -> [a]
flattenTreeOrd Null = []
flattenTreeOrd (Node left x right) = flattenTreeOrd left ++ [x] ++ flattenTreeOrd right


-- =========== EXTENSIONS =============

{-
Extension 1

Write a function
that takes a binary search tree, and an element, and removes it from the tree
(if it is present).
-}

-- | Removes any element from a BS Tree
-- >>> treeDelete (Node (Node Null 1 (Node Null 2 Null)) 3 (Node Null 4 (Node Null 5 Null))) 5
-- Node (Node Null 1 (Node Null 2 Null)) 3 (Node Null 4 Null)
--
-- >>> treeDelete (Node (Node Null 1 (Node Null 2 Null)) 3 (Node Null 4 (Node Null 5 Null))) 3
-- Node (Node Null 1 Null) 2 (Node Null 4 (Node Null 5 Null))
--
treeDelete :: (Ord a) => BSTree a -> a -> BSTree a
treeDelete Null _ = Null
treeDelete (Node left x right) n
  | n > x = Node left x (treeDelete right n)
  | n < x = Node (treeDelete left n) x right
  | otherwise = case (left, right) of
    (Node {}, Null) -> left
    (Null, Node {}) -> right
    (Node ll l lr, Node {}) -> Node (Node ll l (treeDelete lr (treeBSMax lr))) (treeBSMax lr) right
    _ -> Null


{-
Extension 2 (Tricky, Optional for everyone)

Write a function
that takes a binary search tree of integers, and rearranges the structure
of the tree so it is now balanced.
You may have to do some research as to how to implement this.
(Really Tricky: Do it without flattening the entire tree and rebuilding it
from scratch.)
-}

treeDepth :: BinaryTree a -> Int
treeDepth Null = 0
treeDepth (Node left _ right) = 1 + max (treeDepth left) (treeDepth right)

treeSize :: BinaryTree a -> Int
treeSize Null = 0
treeSize (Node left _ right) = 1 + treeSize right + treeSize left

isBalanced :: BinaryTree a -> Bool
isBalanced t = treeSize t > maxElements (treeDepth t - 1)
  where
  maxElements :: Int -> Int
  maxElements n
    | n > 0 = (2 ^ (n - 1)) + maxElements (n-1)
    | otherwise = n

-- | Balances an ordered tree
-- >>> treeBalance (Node (Node Null 1 (Node Null 2 Null)) 3 (Node Null 4 (Node Null 5 Null)))
-- Node (Node Null 1 (Node Null 2 Null)) 3 (Node Null 4 (Node Null 5 Null))
--
-- >>> treeBalance badTree
-- Node (Node (Node (Node Null 1 Null) 3 (Node Null 5 Null)) 7 (Node (Node Null 10 Null) 12 (Node Null 13 Null))) 15 (Node (Node (Node Null 16 Null) 17 (Node Null 18 Null)) 23 (Node (Node Null 25 Null) 26 (Node Null 31 Null)))
--
treeBalance :: (Ord a) => BSTree a -> BSTree a
treeBalance Null = Null
treeBalance tree@(Node left x right) = if isBalanced $ Node left x right then Node left x right else
  case (left, right) of
    (Node ll l lr, Null) -> Node (treeBalance ll) l (treeBalance (Node lr x Null))
    (Null, Node rl r rr) -> Node (treeBalance (Node Null x rl)) r (treeBalance rr)
    (Node ll l lr, Node rl r rr) ->
      if isBalanced left
        then treeBalance (Node (treeBalance (Node left x rl)) r (treeBalance rr))
        else (if isBalanced right
          then treeBalance(Node (treeBalance ll) l (treeBalance (Node lr x right)))
          else Node (treeBalance left) x (treeBalance right)
          )
    _ -> tree -- Already Balanced

-- | Balances an ordered tree by constructing a new tree from scratch
-- >>> treeBalanceTotalRes (Node (Node Null 1 (Node Null 2 Null)) 3 (Node Null 4 (Node Null 5 Null)))
-- Node (Node (Node Null 1 Null) 2 Null) 3 (Node (Node Null 4 Null) 5 Null)
--
-- >>> treeBalanceTotalRes badTree
-- Node (Node (Node (Node Null 1 Null) 3 (Node Null 5 Null)) 7 (Node (Node Null 10 Null) 12 (Node Null 13 Null))) 15 (Node (Node (Node Null 16 Null) 17 (Node Null 18 Null)) 23 (Node (Node Null 25 Null) 26 (Node Null 31 Null)))
--
treeBalanceTotalRes :: (Ord a) => BSTree a -> BSTree a
treeBalanceTotalRes = expandTree . flattenTreeOrd
  where
    expandTree :: [a] -> BSTree a
    expandTree [] = Null
    expandTree xs = case splitList (floor . (/2) . fromIntegral . length $ xs) xs [] of
      (left, c, right) -> Node (expandTree left) c (expandTree right)

    splitList :: Int -> [a] -> [a] -> ([a], a, [a])
    splitList n (x:xs) ys
      | n == 0 = (reverse ys, x, xs)
      | n > 0 = splitList (n - 1) xs (x:ys)
      | otherwise = error "Negative value"

{-
Extension 3

Define each of the functions necessary for the Nat type (defined above) 
such that it can be part of the Num typeclass.
-}

-- | Num instance of Natural encodings
-- >>> (S Z) + (S (S Z))
-- S (S (S Z))
-- >>> (S Z) - (S Z)
-- Z
-- >>> (S (S Z)) * (S (S (S Z)))
-- S (S (S (S (S (S Z)))))
-- >>> abs (S (S Z)) * signum (S (S Z)) == (S (S Z))
-- True
-- >>> (fromInteger 2) :: Nat
-- S (S Z)
instance Num Nat where
  (+) x y = case (x, y) of
    (Z, _) -> y
    (_, Z) -> x
    (_, S py) -> (+) (S x) py
  (-) x y = if x < y
    then
      error "Naturals can't be negative"
    else
      case (x, y) of
        (_, Z) -> x
        (S px, S py) -> (+) px py
        _ -> error "Naturals can't be negative"
  (*) x y = case (x, y) of
    (S _, S py) -> x + (*) x py
    _ -> Z
  abs x = x
  signum x = if x == Z then x else S Z
  fromInteger n
    | n < 0 = error "Naturals can't be negative"
    | n == 0 = Z
    | otherwise = S $ fromInteger $ n - 1

{-
Extension 4

We  define two trees to be equal if they share 
the same elements, with the same ordering once flattened.
Add an instance of equality for binary trees that satisfies this condition.
-}

-- | Checks if two trees are equal, given a weaker equality definition
-- >>> goodTree == badTree
-- True
instance (Eq a) => Eq (BinaryTree a) where
  (==) a b = orderedListEq $ zip (flattenTreeOrd a) (flattenTreeOrd b)
    where
      orderedListEq :: Eq a => [(a, a)] -> Bool
      orderedListEq = foldr (\(x, y) xs -> x == y && xs) True