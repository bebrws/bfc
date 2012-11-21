module Brainfrack (evalProgram) where

import Data.Word (Word8)
import Data.Char (ord, chr)
import Control.Monad (liftM)

type Program = String

replaceInList [] y _ = error "Index is too big for list"
replaceInList (x:xs) y 0 = y:xs
replaceInList (x:xs) y index = x:replaceInList xs y (index - 1)


findAllBrackets :: Program -> [(Int, Int)]
findAllBrackets program = findAllBrackets' program 0
  where
    findAllBrackets' program index =
      if length program <= index then
        []
      else
        case program !! index of
          '[' -> (index, findClosingBracket program (index + 1) 1) : (findAllBrackets' program (index + 1))
          _ -> findAllBrackets' program (index + 1)


findClosingBracket :: Program -> Int -> Int -> Int
findClosingBracket program index depth
  | depth == 0 = index - 1
  | otherwise =
    case instruction of
      '[' -> findClosingBracket program (index + 1) (depth + 1)
      ']' -> findClosingBracket program (index + 1) (depth - 1)
      _   -> findClosingBracket program (index + 1) depth
  where
    instruction = program !! index
    

reverseTuple :: [(a,b)] -> [(b,a)]
reverseTuple [] = []
reverseTuple ((x, y):rest) = (y, x) : reverseTuple rest


-- this could be faster using an array instead of a list of cells
-- todo: use word8 instead of Int for cells
-- todo: we need to terminate at the end of the program
evalProgram' :: Program -> Int -> Int -> [Int] -> IO ()
evalProgram' program instructionIndex cellIndex cells =
  case program !! instructionIndex of
    '>' -> evalProgram' program (instructionIndex+1) (cellIndex+1) cells
    '<' -> evalProgram' program (instructionIndex+1) (cellIndex-1) cells
    '+' ->
      evalProgram' program (instructionIndex+1) cellIndex cells'
      where
        updatedCell = (cells !! cellIndex) + 1
        cells' = replaceInList cells updatedCell cellIndex
    '-' ->
      evalProgram' program (instructionIndex+1) cellIndex cells'
      where
        updatedCell = (cells !! cellIndex) - 1
        cells' = replaceInList cells updatedCell cellIndex
    '.' -> do
      let charToPrint = chr (cells !! cellIndex)
      putStr [charToPrint]
      evalProgram' program (instructionIndex+1) cellIndex cells
    ',' -> do
      updatedCell <- liftM ord getChar
      let cells' = replaceInList cells updatedCell cellIndex
      evalProgram' program (instructionIndex+1) cellIndex cells
    '[' -> undefined
    ']' -> undefined
    _ -> return ()


evalProgram :: String -> IO ()
evalProgram program = evalProgram' program 0 0 [0 | _ <- [1 .. 30000]]
