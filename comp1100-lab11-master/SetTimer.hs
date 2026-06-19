import System.IO
import Data.Char
import Data.List

import System.CPUTime
import Text.Printf

-- Modify these import statements as required.
import SetsWithLists
-- import SetsWithTrees

time :: IO t -> IO t
time function = do
    start <- getCPUTime
    value <- function
    end   <- getCPUTime
    let diff = (fromIntegral (end - start)) / (10 ^ (12 :: Int))
    _ <- printf "\tComputation time: %0.3f sec\n" (diff :: Double)
    return value

readTextFileAsWords :: String -> IO [String]
readTextFileAsWords filename = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle
  let linesInFile = lines contents
  let wordsInFile = 
          concatMap (words . (filter (\c -> isAlpha c || c == ' ' || c == '\'' || c == '-'))) linesInFile
  let lcWordsInFile = map (map toLower) wordsInFile
  return lcWordsInFile

buildSmallListsOfSize :: Ord a => Int -> [a] -> [[a]]
buildSmallListsOfSize size list =
    case list of
      [] -> []
      xs -> first : buildSmallListsOfSize size rest
        where
          (first, rest) = splitAt size xs

main :: IO ()
main = do
  -- Say hello.
  putStrLn "\n\t\tDown The Rabbit Hole!\n"
  
  -- Parse the initial texts.
  putStrLn "- Reading in Alice's Adventures In Wonderland (AAIW)."
  aliceWords <- readTextFileAsWords "alice-in-wonderland.txt"
  putStrLn "- Reading in Through The Looking Glass (TTLG)."
  glassWords <- readTextFileAsWords "through-the-looking-glass.txt"
  putStr "\n"
  
  -- Create sets using addElement
  putStrLn "- Creating single set for AAIW by using addElement for each word in the file."
  let aliceSet = foldr addElement emptySet aliceWords
  let aliceSetSize = (setSize aliceSet) :: Integer
  putStr "\tWords in AAIW: "
  time $ putStrLn $ show aliceSetSize
  putStrLn "- Creating single set for TTLG by using addElement for each word in the file."
  let glassSet = foldr addElement emptySet glassWords
  let glassSetSize = (setSize glassSet) :: Integer
  putStr "\tWords in TTLG: "
  time $ putStrLn $ show glassSetSize
  putStr "\n"

  -- Create sets using addElement in order
  putStrLn "- Creating single set for AAIW by adding words using addElement in alphabetical order."
  let aliceSetSorted = foldr addElement emptySet (sort aliceWords)
  let aliceSetSizeSorted = (setSize aliceSetSorted) :: Integer
  putStr "\tWords in AAIW: "
  time $ putStrLn $ show aliceSetSizeSorted
  putStrLn "- Creating single set for TTLG by adding words using addElement in alphabetical order."
  let glassSetSorted = foldr addElement emptySet (sort glassWords)
  let glassSetSizeSorted = (setSize glassSetSorted) :: Integer
  putStr "\tWords in TTLG: "
  time $ putStrLn $ show glassSetSizeSorted
  putStr "\n"

  -- Create sets by progressive unioning of small sets
  putStrLn "- Creating single set for AAIW by unioning sublists of size 300."
  let aliceSmallLists = buildSmallListsOfSize 300 aliceWords
  let aliceSmallSets = map (foldr addElement emptySet) aliceSmallLists
  let aliceSet_2 = foldr setUnion emptySet aliceSmallSets
  putStr "\tWords in AAIW: "
  time $ putStrLn $ show $ ((setSize aliceSet_2) :: Integer)
  
  putStrLn "- Creating single set for TTLG unioning sublists of size 300."
  let glassSmallLists = buildSmallListsOfSize 300 glassWords
  let glassSmallSets = map (foldr addElement emptySet) glassSmallLists
  let glassSet_2 = foldr setUnion emptySet glassSmallSets
  putStr "\tWords in AAIW: "
  time $ putStrLn $ show $ ((setSize glassSet_2) :: Integer)
  putStr "\n"

  
  

  -- Calculate all words in both AAIW and TTLG, the hard way using contains
  putStrLn "- Working out how many words appear in both texts, using contains."
  let bothLists = nub $ aliceWords ++ glassWords
  putStr "\tDistinct words in either AAIW or TTLG: "
  putStrLn $ (show (length bothLists))
  let wordsInBoth = [ word | word <- bothLists
                      , aliceSet `containsElement` word
                      , glassSet `containsElement` word ]
  let sharedSize = length $ wordsInBoth
  putStr "\tWords in both AAIW and TTLG: "
  time $ putStrLn $ show sharedSize
  putStr "\n"


  putStrLn "- Checking whether each small set is equal to any other small set."
  let combinedSmallSets = aliceSmallSets ++ glassSmallSets
  let equalityChecks = [ (set1,set2) | set1 <- combinedSmallSets
                        , set2 <- combinedSmallSets
                        , set1 `setEquals` set2 ]
  putStr "\tNumber of combinations of equal sets: "
  time $ putStrLn $ show $ length $ equalityChecks
  putStr "\n"

  -- ==============================================================
  -- This part won't run unless you've also got the 1130 extensions.
  -- ==============================================================

  -- Return both sets to the empty set by removing elements individually
  putStrLn "- Removing all elements from AAIW set, one by one."
  let aliceBackToEmpty = foldr removeElement aliceSet (reverse aliceWords)
  let aliceSetSizeEmpty = (setSize aliceBackToEmpty) :: Integer
  putStr "\tWords in AAIW after all inputs removed (should be 0): "
  time $ putStrLn $ show aliceSetSizeEmpty

  putStrLn "- Removing all elements from TTLG set, one by one."
  let glassBackToEmpty = foldr removeElement glassSet (reverse glassWords)
  let glassSetSizeEmptyOneByOne = (setSize glassBackToEmpty) :: Integer
  putStr "\tWords in TTLG after all inputs removed (should be 0): "
  time $ putStrLn $ show glassSetSizeEmptyOneByOne
  putStr "\n"

  -- Return both sets to empty by taking the progressive (and left-associative) set
  -- difference of the smaller sets created above.
  putStrLn "- Removing all elements from AAIW set, by repeatedly taking set difference."
  let aliceEmptyDifference = foldl setDifference aliceSet aliceSmallSets
  let aliceSetSizeEmptyDifference = (setSize aliceEmptyDifference) :: Integer
  putStr "\tWords in AAIW after all inputs removed (should be 0): "
  time $ putStrLn $ show aliceSetSizeEmptyDifference
  
  putStrLn "- Removing all elements from TTLG set, by repeatedly taking set difference."
  let glassEmptyDifference = foldl setDifference glassSet glassSmallSets
  let glassSetSizeEmptyDifference = (setSize glassEmptyDifference) :: Integer
  putStr "\tWords in TTLG after all inputs removed (should be 0): "
  time $ putStrLn $ show glassSetSizeEmptyDifference
  putStr "\n"
                          
  putStrLn "- Working out how many words appear in both texts, using set intersection."
  putStr "\tDistinct words in either AAIW or TTLG: "
  putStrLn $ show $ (setSize :: Set a -> Integer) $ aliceSet `setUnion` glassSet
  let sharedSizeIntersect = (setSize :: Set a -> Integer) $ aliceSet `setIntersection` glassSet
  putStr "\tWords in both AAIW and TTLG: "
  time $ putStrLn $ show sharedSizeIntersect
  putStr "\n"
