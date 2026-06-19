module Trees where

-- Type declarations for trees.
-- DO NOT EDIT THESE TYPE DECLARATIONS.

data RoseTree a = RoseNode a [RoseTree a]

data BinaryTree a = Null | Node (BinaryTree a) a (BinaryTree a)
  deriving Show

-- | isBinary:
-- given a RoseTree as input,
-- return True if its structure is binary - no node has more than two children.
-- Return False otherwise.
--
-- Examples:
--
-- >>> isBinary (RoseNode 1 [])
-- True
--
-- >>> isBinary (RoseNode 1 [RoseNode 2 [],RoseNode 3 [],RoseNode 4 []])
-- False
--
-- >>> isBinary (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- True

isBinary :: RoseTree a -> Bool
isBinary = undefined

-- | roseToBinary:
-- Given a RoseTree as input,
-- return a BinaryTree with a similar node structure in the following sense:
-- the first child (if any) of each node as the left subtree;
-- the second child (if any) of each node as the right subtree;
-- but all other children pruned away.
--
-- Note that it is NOT necessary to complete isBinary
-- before attempting this question;
-- roseToBinary should return a BinaryTree on any input.
--
-- Examples:
--
-- >>> roseToBinary (RoseNode 1 [])
-- Node Null 1 Null
--
-- >>> roseToBinary (RoseNode 1 [RoseNode 2 [],RoseNode 3 [],RoseNode 4 []])
-- Node (Node Null 2 Null) 1 (Node Null 3 Null)
--
-- >>> roseToBinary (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- Node (Node (Node (Node Null 2 Null) 3 Null) 4 (Node Null 5 Null)) 1 Null

roseToBinary :: RoseTree a -> BinaryTree a
roseToBinary = undefined

-- | isPath:
-- Given a list and a RoseTree as inputs,
-- return True if the list corresponds to a 'path' through the tree.
-- Return False otherwise.
-- A path is a sequence of nodes where each node is the parent of the next node.
--
-- Note that it is NOT necessary to complete the previous two functions
-- before attempting this question.
--
-- Examples:
--
-- >>> isPath [] (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- True
--
-- >>> isPath [1,4,3,2] (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- True
--
-- >>> isPath [4,3] (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- True
--
-- >>> isPath [3,5] (RoseNode 1 [RoseNode 4 [RoseNode 3 [RoseNode 2 []],RoseNode 5 []]])
-- False

isPath :: Eq a => [a] -> RoseTree a -> Bool
isPath = undefined