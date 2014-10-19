module Main (main) where
 
import Control.Monad (unless)
import Prelude hiding (Left, Right)
import System.IO (BufferMode (NoBuffering), hSetBuffering, isEOF, stdout)
 
type Stone = Int
 
data Direction = Up
				| Right
				| Down
				| Left
 
-- Main, was sonst?
main :: IO ()
main = do
	hSetBuffering stdout NoBuffering -- stdout nicht Buffern!
	processInput respond -- Springe in Hauptschleife und rufe dort
-- immer `respond` auf.
 
-- Hauptschleife, liest die Eingabezeile und kümmert sich um die Ausgabe
processInput :: (String -> Char) -> IO ()
processInput f = do
	finished <- isEOF
	unless finished $ do
		getLine >>= putChar . f
		processInput f
 
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
 
makeMove :: [[Stone]] -> Direction
makeMove d = Up
