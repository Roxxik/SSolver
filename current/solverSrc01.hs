module Main (main) where

import Control.Monad (forever)
import Prelude hiding (Left, Right)
import System.IO (BufferMode (NoBuffering), hSetBuffering, isEOF, stdout)
import Data.List

type Stone = Int
type Board = [[Stone]]
type Neighbour = (Stone,[Stone])
type Neighbourhood = [[Neighbour]]
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
makeMove xs = chooseMoove xs

chooseMove :: Board -> Direction
chooseMove xs = if isMovable xs Down then Down else
				if isMovable xs Left then Left else
				if isMovable xs Right then Right else Up
--chooseMoove (u:l:d:r:xs)| u == y = Up
--						| l == y = Left
--						| d == y = Down
--						| r == y = Right
--	where y = maximum[u,l,d,r]

scoreBoard :: Board -> [Int]
scoreBoard xs = mapDir f xs
	where f d xs = if isMovable xs d then scoring (move xs d) else 0

scoreBoardRekur :: Board -> Int -> [Int]
scoreBoardRekur xs 0 = scoreBoard xs
scoreBoardRekur xs n = mapDir f (xs, n)
	where f d (xs, n) = if isMovable xs d then (rekurScoring rekurScoreMethod d xs n) else 0

rekurScoring :: Int -> Direction -> Board -> Int -> Int
rekurScoring p d xs n	| p == 0 = avgInt((scoring ys) : (scoreBoardRekur ys (n-1)))
						| p == 1 = avgInt[(scoring ys), avgInt(scoreBoardRekur ys (n-1))]
						| p == 2 = avgInt(scoreBoardRekur ys (n-1))
							where ys = move xs d

mapDir :: (Direction -> a -> b) -> a -> [b]
mapDir f a = (f Up a) : (f Left a) : (f Down a) : (f Right a) : []

scoring :: Board -> Int
scoring xs = scoreFlow xs * countZeros xs -- / scoreSmoothness xs

avgInt :: [Int] -> Int
avgInt xs = round(fromIntegral(sum xs) / fromIntegral(length(filter (/= 0)xs)))
{-
maxBoard :: Board -> Int
maxBoard xs = length xs

maxTile :: Board -> Stone
maxTile xs = (maximum.(map maximum)) xs

tilePos :: Stone -> Board -> (Int,Int)
tilePos y xs | isJust z = (fromJust z, (map (tilePosRow y) xs)!!(fromJust z))
			 | otherwise = (-1,-1)
	where z = findIndex (/= -1) (map (tilePosRow y) xs)

tilePosRow :: Stone -> [Stone] -> Int
tilePosRow y xs = if isJust z then fromJust z else -1
	where z = elemIndex y xs

isTileMovable :: (Int, Int) -> Board -> Direction -> Bool
isTileMovable (a,b) xs d = getTile xs (a,b) /= getTile (move xs d) (a,b)

getTile :: Board -> (Int,Int) -> Stone
getTile xs (a,b) = xs!!a!!b

maxCornered :: Board -> Int
maxCornered xs = maximum[getTile xs (a,b)|a<-[0,high],b<-[0,high]]
	where high = maxBoard xs -1
-}
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

prepNeighbours :: Board -> Neighbourhood
prepNeighbours [] = []
prepNeighbours xs = map (map (\x -> (x,[]))) xs

getNeighbours :: Board -> Neighbourhood
getNeighbours = getNeighboursBoth . prepNeighbours

getNeighboursBoth :: Neighbourhood -> Neighbourhood
getNeighboursBoth = transpose . getNeighboursHor . transpose . getNeighboursHor

getNeighboursHor :: Neighbourhood -> Neighbourhood
getNeighboursHor = (map reverse) . (map getNeighboursRow) . (map reverse) . (map getNeighboursRow)

getNeighboursRow :: [Neighbour] -> [Neighbour]
getNeighboursRow [] = []
getNeighboursRow (y:[]) = y : []
getNeighboursRow (x:y:xs) = x : getNeighboursRow ((fst y, fst x:(snd y)):xs) 

scoreNeighbour :: Neighbour -> Int
scoreNeighbour (x,ys) = avgInt $ map round (map ((\z y -> (max z y) / (min z y)) (fromIntegral x)) cs)
	where cs = map fromIntegral ys

scoreSmoothness :: Board -> Int
scoreSmoothness xs = sum(map (sum.(map scoreNeighbour)) (getNeighbours xs) )

--scoreMono :: Board -> Int

scoreFlow :: Board -> Int
scoreFlow xs = maximum $ map (scoreFlowBoth (<=)) [xs, map reverse xs] ++ map (scoreFlowBoth (>=)) [xs, map reverse xs]

scoreFlowBoth :: (Stone -> Stone -> Bool) -> Board -> Int
scoreFlowBoth f xs = avgInt[scoreFlowHor f xs, ((scoreFlowHor f).transpose) xs]

scoreFlowHor :: (Stone -> Stone -> Bool) -> Board -> Int
scoreFlowHor f xs = sum $ map (scoreFlowRow f) xs

scoreFlowRow :: (Stone -> Stone -> Bool) -> [Stone] -> Int
scoreFlowRow _ []  = 0
scoreFlowRow _ [x] = 0
scoreFlowRow f (x:xs)	| f x (head xs) = 1 + scoreFlowRow f xs
					  	| otherwise	  = scoreFlowRow f xs

countZeros :: Board -> Int
countZeros xs = sum $ map countZerosRow xs

countZerosRow :: [Stone] -> Int
countZerosRow r = sum[1|x<-r, (x==0)]

rekurScoreMethod = 0
rekurDepth = 5
