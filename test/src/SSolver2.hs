module Main (main) where
--SSolver

import Control.Monad (unless)
import Prelude hiding (Left, Right)
import System.IO (BufferMode (NoBuffering), hSetBuffering, isEOF, stdout)
import Data.List

type Stone = Int
type Board = [[Stone]]
type Depth = Int
type Score = Int
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

parseBoard :: String -> Board
parseBoard input = read (modifiedInput) :: Board
	where
	modifiedInput = '[': tail (init input) ++ "]"

-------------------------------------------------------------------------------
makeMove :: Board -> Direction
makeMove xs = chooseMoove $ scoreBoardRekur xs rekurDepth

chooseMoove :: [Score] -> Direction
chooseMoove (u:l:d:r:xs)| u == y = Up
						| l == y = Left
						| d == y = Down
						| r == y = Right
	where y = maximum[u,l,d,r]

rekurDepth = 5

scoreBoard :: Board -> [Score]
scoreBoard xs = mapDir f xs
	where f d xs = if isMovable xs d then scoring (move xs d) else 0

scoreBoardRekur :: Board -> Depth -> [Score]
scoreBoardRekur xs 0 = scoreBoard xs
scoreBoardRekur xs n = mapDir f (xs, n)
	where f d (xs, n) = if isMovable xs d then rekurScoring d xs n else 0

rekurScoring :: Direction -> Board -> Depth -> Score
rekurScoring d xs n = avgInt((scoring ys) : (scoreBoardRekur ys (n-1)))
							where ys = move xs d

mapDir :: (Direction -> a -> b) -> a -> [b]
mapDir f a = (f Up a) : (f Left a) : (f Down a) : (f Right a) : []

scoring :: Board -> Score
scoring xs = scoreFlow xs * countZeros xs * if length (possibleMoves xs) > 1 then 2 else 1

avgInt :: [Score] -> Score
avgInt xs = round(fromIntegral(sum xs) / fromIntegral(length(filter (/= 0) xs)))

directions :: [Direction]
directions = [Down, Left, Right, Up]

possibleMoves :: Board -> [Direction]
possibleMoves xs = [d | d <- directions,isMovable xs d]

isMovable :: Board -> Direction -> Bool
isMovable xs d = xs /= move xs d

joinStones :: [Stone] -> [Stone]
joinStones [] = []
joinStones [x] = [x]
joinStones (x:y:xs) | x == y = x+y : joinStones xs ++ [0]
					| otherwise = x : joinStones (y:xs)

move :: Board -> Direction -> Board
move [] _ = []
move (xs:xss) Left = (joinStones(snd ys)++fst ys) : move xss Left
	where ys = partition (== 0) xs
move xss Right = map reverse $ move (map reverse xss) Left
move xss Up = transpose $ move (transpose xss) Left
move xss Down = transpose $ move (transpose xss) Right

scoreFlow :: Board -> Int
scoreFlow xs = maximum $ map (scoreFlowBoth (<=)) [xs, map reverse xs] ++ map (scoreFlowBoth (>=)) [xs, map reverse xs]

scoreFlowBoth :: (Stone -> Stone -> Bool) -> Board -> Score
scoreFlowBoth f xs = avgInt[scoreFlowHor f xs, ((scoreFlowHor f).transpose) xs]

scoreFlowHor :: (Stone -> Stone -> Bool) -> Board -> Score
scoreFlowHor f xs = sum $ map (scoreFlowRow f) xs

scoreFlowRow :: (Stone -> Stone -> Bool) -> [Stone] -> Score
scoreFlowRow _ []  = 0
scoreFlowRow _ [x] = 0		--wtf hab ich mir dabei gedacht???
scoreFlowRow f (x:xs)	| f x (head xs) = 1 + scoreFlowRow f xs
					  	| otherwise	  = scoreFlowRow f xs

countZeros :: Board -> Score
countZeros xs = sum $ map countZerosRow xs

countZerosRow :: [Stone] -> Score
countZerosRow r = sum[1|x<-r, (x==0)]
