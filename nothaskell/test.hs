import Control.Monad (unless)
import Prelude hiding (Left, Right)
import System.IO (BufferMode (NoBuffering), hSetBuffering, isEOF, stdout)
import Data.List
 
type Stone = Int
 
data Direction =  Up
				| Right
				| Down
				| Left


makeMove :: [[Stone]] -> Direction
makeMove xs = chooseMove $ scoreBoardRekur xs 4

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



scoring :: [[Stone]] -> Int
scoring xs = scoreFlow xs + if countZeros xs <= 3 then -10 else 0

scoreFlow :: [[Stone]] -> Int
scoreFlow xs = maximum $ map scoreFlowBothUp [xs, map reverse xs] ++ map scoreFlowBothDown [xs, map reverse xs]

scoreFlowBothUp :: [[Stone]] -> Int
scoreFlowBothUp xs = avgOfLst[scoreFlowHorUp xs, (scoreFlowHorUp.transpose) xs]

scoreFlowHorUp :: [[Stone]] -> Int
scoreFlowHorUp xs = sum $ map scoreFlowRowUp xs

scoreFlowRowUp :: [Stone] -> Int
scoreFlowRowUp [] = 0
scoreFlowRowUp [x] = 0
scoreFlowRowUp (x:xs) | x <= head xs = 1 + scoreFlowRowUp xs
					  | otherwise    = scoreFlowRowUp xs

scoreFlowBothDown :: [[Stone]] -> Int
scoreFlowBothDown xs = avgOfLst[scoreFlowHorDown xs, (scoreFlowHorDown.transpose) xs]

scoreFlowHorDown :: [[Stone]] -> Int
scoreFlowHorDown xs = sum $ map scoreFlowRowDown xs

scoreFlowRowDown :: [Stone] -> Int
scoreFlowRowDown [] = 0
scoreFlowRowDown [x] = 0
scoreFlowRowDown (x:xs) | x >= head xs = 1 + scoreFlowRowDown xs
						| otherwise    = scoreFlowRowDown xs

countZeros :: [[Stone]] -> Int
countZeros xs = sum $ map countZerosRow xs

countZerosRow :: [Stone] -> Int
countZerosRow r = sum[1|x<-r, (x==0)]
