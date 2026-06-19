-- 80 chars
-- M1tWLm3QqaIUR1kzWjBK1ddqkqZlHi6gdswvOHQchJQwsTTEhf1PeIiHvYnMgv99h4EyBSvYGdnU

{-|
Module      : AI
Description : AIs for Othello
Copyright   : (c) 2020 Your Name Here
License     : AllRightsReserved
-}
module AI where

import Othello
import Eliminator

-- | Type of AI functions you can choose to write.
data AIFunc
  = NoLookahead (GameState -> Move)
    -- ^ Simple AIs that do not need lookahead.
  | WithLookahead (GameState -> Int -> Move)
    -- ^ AIs that want to look ahead. The assignment framework will
    -- call the function over and over with increasing integer
    -- arguments @1, 2, 3, ...@ until your AI's time limit is up.

-- | The table of all AIs that your assignment provides. The AI named
-- "default" in this table is the one your tutor will dedicate most of
-- their attention to marking.
ais :: [(String, AIFunc)]
ais = [ ("firstLegalMove", NoLookahead firstLegalMove)
      , ("greedy", NoLookahead greedy)
      , ("eliminator", WithLookahead eliminator)
      , ("default", WithLookahead (abpai heuristic))
      -- Same AI here just for ease of terminal calling
      , ("abpai", WithLookahead (abpai heuristic))
      , ("oldabpai", WithLookahead (abpai simpleHeuristic))
      ]

-- | A very simple AI, which picks the first move returned by the
-- 'legalMoves' function. AIs can rely on the 'legalMoves' list being
-- non-empty; if there were no legal moves, the framework would have
-- ended the game.
firstLegalMove :: GameState -> Move
firstLegalMove st = head (legalMoves st)

-- | Greedy AI for benchmarking
greedy :: GameState -> Move
greedy st =
  (\l -> maximize l $ map ((`heuristic` True) . applyMove st) l)
    $ legalMoves st

-- | The simple eliminator AI
eliminator :: GameState -> Int -> Move
eliminator = flip singleStateMove

-- | AI using Alpha-Beta Pruning but performing it on moves one layer deep
abpai :: (Maybe GameState -> Bool -> Int) -> GameState -> Int -> Move
abpai h st n =
  (\l -> maximize l $ map (headABPrune h n . (`Node` []) . applyMove st) l)
  $ legalMoves st

deJust :: Maybe a -> a
deJust (Just a) = a
deJust Nothing = error "Cannot deJust"

{-

This code was sourced externally and was reverse-engineered into haskell code.
It still required a process of research, haskell programmign from scratch,
and an understansing of the algorithim to properly use.
The sources are cited in the technical report as footnotes.
It is displayed here to give the marker an understanding of how the program was
developed, also to show that I did use external sources when produced the
assignment.

function alphabeta(node, depth, α, β, maximizingPlayer) is
  if depth = 0 or node is a terminal node then
    return the heuristic value of node
  if maximizingPlayer then
    value := −∞
    for each child of node do
      value := max(value, alphabeta(child, depth − 1, α, β, FALSE))
      α := max(α, value)
      if α ≥ β then
        break (* β cutoff *)
    return value
  else
    value := +∞
    for each child of node do
      value := min(value, alphabeta(child, depth − 1, α, β, TRUE))
      β := min(β, value)
      if β ≤ α then
        break (* α cutoff *)
    return value

(* Initial call *)
alphabeta(origin, depth, −∞, +∞, TRUE)
-}

-- | Performs an AB-Pruning on a root node
headABPrune :: Heuristic -> Int -> GTree -> Int
headABPrune h n gt = abPrune h gt n (inf+1) inf False --True

-- | AB-Prunes a single node
-- This function was reverse engineered with understanding of the operation.
abPrune :: Heuristic -> GTree -> Int -> Int -> Int -> Bool -> Int
abPrune hf (Node gs _) depth a b mp = case (depth, mp) of
  (0, _) -> hf gs mp
  (_, True) -> maxPrune hf (inf+1) (expandNode gs) depth a b mp
  (_, False) -> minPrune hf inf (expandNode gs) depth a b mp
  where
    -- | This attempts to maximise the alpha-value from
    -- a list of GTrees by pruning lower branches
    maxPrune :: Heuristic -> Int -> [GTree] -> Int -> Int -> Int -> Bool -> Int
    maxPrune _ v [] _ _ _ _ = v
    maxPrune h v (g:gt) d alpha beta p =
      maxAlpha
        h (max v $ abPrune h g (d-1) alpha beta (not p)) gt d alpha beta p

    -- | This checks if a >= b, also allowing to
    -- repeat the process for the next set of values
    maxAlpha :: Heuristic -> Int -> [GTree] -> Int -> Int -> Int -> Bool -> Int
    maxAlpha h v gt d alpha beta p =
      if max v alpha >= beta then v else maxPrune h v gt d (max v alpha) beta p

    -- | Near-Identical operation, but now minimizing beta
    minPrune :: Heuristic -> Int -> [GTree] -> Int -> Int -> Int -> Bool -> Int
    minPrune _ v [] _ _ _ _ = v
    minPrune h v (g:gt) d alpha beta p =
      minBeta
        h (min v $ abPrune h g (d-1) alpha beta (not p)) gt d alpha beta p

    -- | Near-Identical operation, but now minimizing beta
    minBeta :: Heuristic -> Int -> [GTree] -> Int -> Int -> Int -> Bool -> Int
    minBeta h v gt d alpha beta p =
      if max v beta <= alpha then v else minPrune h v gt d alpha (max v beta) p

    -- | Get list of possible gamestates from node
    expandNode :: Maybe GameState -> [GTree]
    expandNode (Just g) = map ((`Node` []) . applyMove g) $ legalMoves g
    expandNode Nothing = []

-- | The weighted board heuristic
heuristic :: Maybe GameState -> Bool -> Int
heuristic (Just (GameState bds (Turn p) b)) mp =
    if mp then sumBoard (currentScore b p) (heuristicBoard bds b p)
    else sumBoard
      (currentScore b $ otherPlayer p) (heuristicBoard bds b $ otherPlayer p)
heuristic (Just (GameState _ (GameOver o) _)) mp = case o of
  Draw -> 0
  Winner _ -> if mp then inf else inf + 1
heuristic Nothing _ = 0

-- | Sums all of the elements in a board,
-- multiplying it by the a given amplitude
sumBoard :: Int -> [[Double]] -> Int
sumBoard n p = n * ((floor $ 10000 * sum (map sum p)) :: Int)

-- | Produces a weighted board, given the maximising player
heuristicBoard :: Bounds -> Board -> Player -> [[Double]]
heuristicBoard bds b p = boardmap bds b p 0
  where
      boardmap :: Bounds -> [[Maybe Player]] -> Player -> Int -> [[Double]]
      boardmap _ [] _ _ = []
      boardmap bounds (r:rs) cp row =
        rowmap bounds r cp (0, row) : boardmap bounds rs cp (row+1)

      rowmap :: Bounds -> [Maybe Player] -> Player -> Position -> [Double]
      rowmap _ [] _ _ = []
      rowmap bounds (c:cs) cp pos@(x, y) =
        hfunc bounds c cp pos : rowmap bounds cs cp (x+1, y)
      
      hfunc :: Bounds -> Maybe Player -> Player -> Position -> Double
      hfunc bounds mp cp pos = amp 1 mp (Just cp) * bias bounds pos


-- | Amplitude scaling factor
amp :: Int -> Maybe Player -> Maybe Player -> Double
amp n p1 p2
  | p1 == Nothing = 0
  | p1 == p2 = fromIntegral n
  | otherwise = - fromIntegral n

-- | Applies a bias to a particular point
-- (Unit form - Amplitude is applied elsewhere)
bias :: Bounds -> Position -> Double
bias (b1, b2) p = 0.5 * (1 + cos (2 * w * r p)) * cos (w * r p)
  where
    -- | Gets the frequency of cosine function
    w :: Double
    w = 2 * pi / r (b1 - 1, b2 - 1)

    -- | Gets radial position of a point from centre
    r :: (Int, Int) -> Double
    r (x, y) = sqrt (cp x b1 ** 2 + cp y b2 ** 2)

    -- | Puts position in relation to the centre
    cp :: Int -> Int -> Double
    cp x y = fromIntegral x - (fromIntegral y - 1) / 2


-- | Creates a simple heuristic
simpleHeuristic :: Maybe GameState -> Bool -> Int
simpleHeuristic (Just (GameState _ (Turn p) b)) mp =
  if mp then currentScore b p else currentScore b $ otherPlayer p
simpleHeuristic (Just (GameState _ (GameOver o) _)) mp = case o of
  Draw -> 0
  Winner _ -> if mp then inf else inf + 1
simpleHeuristic Nothing _ = 0

-- | Upper int limit, inf + 1 = lower limit
inf :: Int
inf = (2 ^ (63 :: Int)) - 1