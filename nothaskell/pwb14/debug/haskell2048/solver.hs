data Direction = North | West | South | East
type Tile = Int
type Board = [[Tile]]

solve :: (String -> String)
solve = (makeStep.setupBoard)

prepareString :: String -> String
prepareString [] = []

setupBoard :: String -> Board
setupBoard [] = []
setupBoard x = read x


makeStep :: Board -> String




main = do
	processIt



processIt
 interact (solve f)
