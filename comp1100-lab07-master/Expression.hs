module Expression where

-- | A token is plus, minus or a number
data Token = Plus 
       | Minus
       | Num Double
       | Times
       | DividedBy
       | Power
  deriving (Show, Eq)

-- | Expression is a list of tokens
type Expression = [Token]

-- | The `tokenise` function reads a string to return a list of tokens
-- >>> tokenise "3.2 + 2.3"
-- [Num 3.2,Plus,Num 2.3]
tokenise :: String -> Expression
tokenise ""   = []
tokenise (c:cs) = case c of
  '+' -> Plus    : tokenise cs
  '-' -> Minus   : tokenise cs
  '*' -> Times   : tokenise cs
  '/' -> DividedBy   : tokenise cs
  '^' -> Power   : tokenise cs
  _ | c `elem` ['0' .. '9'] -> case reads (c:cs) of
      [(value, rest)] -> Num value : tokenise rest
      _         -> error "Could not read number"
    | c `elem` [' ', '\t'] -> tokenise cs
    | otherwise -> error "Unknown Symbol"

-- | The `showExpression` function reads a list of tokens to return a string
-- >>> showExpression [Num 3.2,Plus,Num 2.3]
-- "3.2 + 2.3"
showExpression :: Expression -> String
showExpression []   = ""
showExpression (e:es) = case e of
  Plus    -> " + "  ++ showExpression es
  Minus   -> " - "  ++ showExpression es
  Times   -> " * "  ++ showExpression es
  DividedBy   -> " / "  ++ showExpression es
  Power   -> " ^ "  ++ showExpression es
  Num x   -> show x ++ showExpression es

-- | `evalStringExpression` evaluates a string containing a valid numberical 
-- expression and returns the evaluated expression
-- >>> evalStringExpression "- 3.2 - 4.2 + 5.3 - 6.3"
-- "-8.4"
-- >>> evalStringExpression "2 ^ - 1 - 5.3 - 6.3"
-- "-11.1"
-- >>> evalStringExpression "3.2 - 4.2 - 5.3 - 6.3"
-- "-12.6"
-- >>> evalStringExpression "- 3.2 - 4.2 - 5.3 - 6.3"
-- "-19.0"
-- >>> evalStringExpression "3 ^ 4 - 5.3 - 6.3"
-- "69.4"
-- >>> evalStringExpression "4 * 8 + - 4 / 2"
-- "30.0"
evalStringExpression :: String -> String
evalStringExpression s = showExpression (eval (tokenise s))

-- | Evaluates an encoded expression
eval :: Expression -> Expression
eval exp = reduce Plus (reduce Times (reduce DividedBy (reduce Power (removeMinus (Num 0:Plus:exp)))))
  where
    -- | Combines an operation and condensation
    reduce :: Token -> Expression -> Expression
    reduce t e = operate t (condense t e)

    -- | Performs an operation on all of the condensed tokens
    operate :: Token -> Expression -> Expression
    operate t [e1, e2] = case (e1, e2) of
      (Num _, Num _) -> [op (tokenToFunc t) e1 e2]
      _ -> [e1, e2]
    operate t (e1:e2:e) = case (e1, e2) of
      (Num _, Num _) -> operate t (op (tokenToFunc t) e1 e2 : e)
      _ -> e1 : operate t (e2:e)
    operate _ e = e
    
    -- | Condenses and expression by removing all plus/minus tokens
    condense :: Token -> Expression -> Expression
    condense t (e1:e2:es) =
      case e1 of
      Num x -> e1 : condense t (e2:es)
      e -> if t == e then condense t (e2:es) else e : condense t (e2:es)
    condense _ ex = ex

    -- | Removes all minus operands due to unary/binary duality
    removeMinus :: Expression -> Expression
    removeMinus [e1, e2] = case e1 of 
      Minus -> [op (-) (Num 0) e2]
      _ -> [e1, e2]
    removeMinus (e1:e2:e3:es) =
      case e2 of 
      Minus ->
        case e3 of
        Num _ ->
          case e1 of
          Num _ -> e1 : removeMinus (Plus:op (-) (Num 0) e3:es)
          _ -> removeMinus (e1:op (-) (Num 0) e3:es)
        Minus -> removeMinus (e1:e2:es)
        Plus -> removeMinus (e1:e2:es)
        _ -> removeMinus (e1:e3:es)
      _ -> e1 : removeMinus (e2:e3:es)
    removeMinus e = e

    -- | Combines two numbers together given a specified operation
    op :: (Double -> Double -> Double) -> Token -> Token -> Token
    op f xt yt = case xt of
      Num x -> case yt of
        Num y -> Num (f x y)
        _ -> xt
      _ -> xt
    
    -- | Helper function converting a token to it's corresponsing operation
    tokenToFunc :: Token -> Double -> Double -> Double
    tokenToFunc t = case t of
      Minus -> (-)
      Plus -> (+)
      Times -> (*)
      DividedBy -> (/)
      Power -> (**)
