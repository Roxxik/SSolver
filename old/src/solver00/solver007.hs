module Main (main) where
 
import Control.Monad (unless)
import Prelude hiding (Left, Right)
import System.IO (BufferMode (NoBuffering), hSetBuffering, isEOF, stdout)
import Data.List
 
type Stone = Int
 
data Direction =  Up
				| Right
				| Down
				| Left
 
main :: IO ()
main = do
	hSetBuffering stdout NoBuffering 	-- stdout nicht Buffern!
	processInput respond				-- Springe in Hauptschleife und rufe dort
										-- immer `respond` auf.

processInput :: (String -> Char) -> IO ()
processInput f = do
	finished <- isEOF
	unless finished $ do
		getLine >>= putChar . f
		processInput f

-------------------------------------------------------------------------------
 
 
respond :: String -> Char
respond = dirToKey . makeMove . parseBoard
 
dirToKey :: Direction -> Char
dirToKey Up = 'n'
dirToKey Down = 's'
dirToKey Left = 'w'
dirToKey Right = 'e'
 
parseBoard :: String -> [[Stone]]
parseBoard input = read (modifiedInput) :: [[Stone]]
	where
	modifiedInput = '[': tail (init input) ++ "]"
 
-------------------------------------------------------------------------------
 
makeMove :: [[Stone]] -> Direction
makeMove xs = chooseMove $ scoreBoardRekur xs 7

chooseMove :: [Int] -> Direction
chooseMove (u:l:d:r:x)| u == maximum[u,l,d,r] = Up
					  | l == maximum[u,l,d,r] = Left
					  | d == maximum[u,l,d,r] = Down
					  | r == maximum[u,l,d,r] = Right

scoreBoard :: [[Stone]] -> [Int]
scoreBoard xs = mapDir f xs
	where f d xs = if isMovable xs d then scoring (move xs d) else 0

scoreBoardRekur :: [[Stone]] -> Int -> [Int]
scoreBoardRekur xs 0 = scoreBoard xs
scoreBoardRekur xs n = mapDir f (xs, n)
	where f d (xs, n) = if isMovable xs d then avgOfLst((scoring ys) : (scoreBoardRekur ys (n-1))) else 0
		where ys = move xs d

mapDir :: (Direction -> a -> b) -> a -> [b]
mapDir f a = (f Up a) : (f Left a) : (f Down a) : (f Right a) : []

avgOfLst :: [Int] -> Int
avgOfLst xs = round(fromIntegral(sum xs) / fromIntegral(length(filter (/= 0)xs)))

isMovable :: [[Stone]] -> Direction -> Bool
isMovable xs d = xs /= move xs d

joinStones :: [Stone] -> [Stone]
joinStones [] = []
joinStones [x] = [x]
joinStones (x:y:xs) | x == y = x+y : joinStones xs ++ [0]
					| otherwise = x : joinStones (y:xs)

move :: [[Stone]] -> Direction -> [[Stone]]
move [] _ = []
move (xs:xss) Left = (joinStones(snd ys)++fst ys) : move xss Left
	where ys = partition (== 0) xs
move xss Right = map reverse $ move (map reverse xss) Left
move xss Up = transpose $ move (transpose xss) Left
move xss Down = transpose $ move (transpose xss) Right

maximumf :: Ord b => (a -> b) -> [a] -> a
maximumf f xs =  foldl1 (maxf f) xs

maxf :: Ord b => (a -> b) -> a -> a -> a
maxf f x y | f x >= f y = x
		   | otherwise = y

scoring :: [[Stone]] -> Int
scoring xs = scoreFlow xs * countZeros xs

scoreSmoothness :: [[Stone]] -> Int
scoreSmoothness xs = avgOfLst[scoreSmoothnessHor xs, (scoreSmoothnessHor.transpose) xs]

scoreSmoothnessHor :: [[Stone]] -> Int
scoreSmoothnessHor xs = sum $ map scoreSmoothnessRow xs

scoreSmoothnessRow :: [Stone] -> Int
scoreSmoothnessRow []  = 0
scoreSmoothnessRow [x] = 0
scoreSmoothnessRow (x:xs) | x == (head xs) = 1 + scoreSmoothnessRow xs
						  | otherwise = scoreSmoothnessRow xs

scoreFlow :: [[Stone]] -> Int
scoreFlow xs = maximum $ map (scoreFlowBoth (<=)) [xs, map reverse xs] ++ map (scoreFlowBoth (>=)) [xs, map reverse xs]

scoreFlowBoth :: (Stone -> Stone -> Bool) -> [[Stone]] -> Int
scoreFlowBoth f xs = avgOfLst[scoreFlowHor f xs, ((scoreFlowHor f).transpose) xs]

scoreFlowHor :: (Stone -> Stone -> Bool) -> [[Stone]] -> Int
scoreFlowHor f xs = sum $ map (scoreFlowRow f) xs

scoreFlowRow :: (Stone -> Stone -> Bool) -> [Stone] -> Int
scoreFlowRow _ []  = 0
scoreFlowRow _ [x] = 0
scoreFlowRow f (x:xs) | f x (head xs) = 1 + scoreFlowRow f xs
					  | otherwise	  = scoreFlowRow f xs

countZeros :: [[Stone]] -> Int
countZeros xs = sum $ map countZerosRow xs

countZerosRow :: [Stone] -> Int
countZerosRow r = sum[1|x<-r, (x==0)]


{- old routines


scoring :: [[Stone]] -> Int
scoring xs = avgOfLst[(scoreFlow xs),(countZeros xs)*0]


makeMove :: [[Stone]] -> Direction
makeMove d = 	if isMovable d Up then Up else
				if isMovable d Left then Left else
				if isMovable d Right then Right else
				Down
-}
