module Trees where 

data BinaryTree a = Null | Node (BinaryTree a) a (BinaryTree a)
    deriving Show

type BSTree a = BinaryTree a

-- I wonder what this function does.
treeMystery :: BSTree a -> BSTree a
treeMystery tree = case tree of
    Null -> Null
    Node left x right -> Node (treeMystery right) x (treeMystery left)

-- =====================================


data Person = Me | My Ancestor
data Ancestor = Father | Mother | Grand Ancestor 
    
type FamilyTree = BinaryTree Name
type Name = String


-- | Takes a family tree, and returns all the names of matching ancestors
ancestors :: Person -> FamilyTree -> [Name]
ancestors = undefined

-- | Takes a family tree, and a name, and returns what kind of ancestor they are,
-- | if they can be found.
kindAncestor :: FamilyTree -> Name -> Maybe Person
kindAncestor = undefined


-- | The family tree of David Quarel (that's me!) 3 generations back
david :: FamilyTree
david = 
    Node 
        (Node 
            (Node 
                (Node Null "Luigi Quarel" Null) 
                "Luigi Quarel" 
                (Node Null "Rosa Randazzo" Null)
            ) 
            "John Quarel" 
            (Node 
                (Node Null "Alfredo Parisotto" Null)
                "Maria Parisotto" 
                (Node Null "Assunta Karsun" Null)
            )
        ) 
        "David Quarel"
        (Node 
            (Node 
                (Node Null "Joseph Corcoran" Null ) 
                "Mark Corcoran" 
                (Node Null "Mary O'Sullivan" Null)
            ) 
            "Helen Corcoran" 
            (Node 
                (Node Null "Kyran Dunn" Null) 
                "Clare Dunn" 
                (Node Null "Charlotte Ohlin" Null)
            )
        ) 


-- | The family tree of Prince George of Cambridge
-- | Only includes royal bloodline
george :: FamilyTree
george = Node georgeDad "Prince George of Cambridge"
            (Node Null "Catherine, Duchess of Cambridge" Null)
        where
        georgeDad = Node willDad "Prince William, Duke of Cambridge" 
                (Node Null "Diana Spencer" Null)
            where
            willDad = Node (Node Null "Phillip, Duke of Edinburgh" Null) 
                        "Charles, Prince of Wales"
                        charlesMum
                where
                charlesMum = Node lizzieDad "Elizabeth II" 
                                (Node Null "Elizabeth Bowes-Lyon" Null)
                    where
                    lizzieDad = Node georgeVIDad "George VI" 
                            (Node Null "Mary of Teck" Null)
                        where
                        georgeVIDad = Node georgeVDad "George V" 
                                (Node Null "Alexandra of Denmark" Null)

                            where
                            georgeVDad = Node 
                                            (Node Null "Queen Victoria" Null) 
                                            "Edward VII" 
                                            (Node Null "Albert, Prince Consort" Null)