
module Prettify
    ( Doc
    , empty
    , char
    , text
    , double
    , line
    , (<>)
    , hcat
    , fsep
    , punctuate
    , compact
    , pretty
    , nest
    ) where

import Prelude hiding ((<>))

-- Representacao de um documento
data Doc
    = Empty
    | Char Char
    | Text String
    | Line
    | Concat Doc Doc
    | Union Doc Doc
    | Nest Int Doc
    deriving (Show)

empty :: Doc
empty = Empty

char :: Char -> Doc
char = Char

text :: String -> Doc
text "" = Empty
text s = Text s

double :: Double -> Doc
double = text . show

line :: Doc
line = Line

-- Concatena dois documentos
(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y = Concat x y

infixr 6 <>

-- Concatena uma lista de documentos
hcat :: [Doc] -> Doc
hcat = foldr (<>) empty

-- Define a indentacao de um documento
nest :: Int -> Doc -> Doc
nest n doc = Nest (max 0 n) doc

-- Escolhe entre duas representacoes
group :: Doc -> Doc
group x = Union (flatten x) x

-- Remove quebras de linha opcionais
flatten :: Doc -> Doc
flatten (Concat x y) = Concat (flatten x) (flatten y)
flatten (Nest n x) = Nest n (flatten x)
flatten Line = Char ' '
flatten (Union x _) = flatten x
flatten other = other

-- Junta documentos com separacao
fsep :: [Doc] -> Doc
fsep [] = empty
fsep [x] = x
fsep (x:xs) = x </> fsep xs

(</>) :: Doc -> Doc -> Doc
x </> y = group (x <> softline <> y)

infixr 5 </>

softline :: Doc
softline = group line

-- Adiciona pontuacao entre documentos
punctuate :: Doc -> [Doc] -> [Doc]
punctuate _ [] = []
punctuate _ [x] = [x]
punctuate p (x:xs) = (x <> p) : punctuate p xs

-- Gera texto sem escolher alternativas de largura
compact :: Doc -> String
compact doc = transform [doc]
  where
    transform [] = ""
    transform (d:ds) =
        case d of
            Empty -> transform ds
            Char c -> c : transform ds
            Text s -> s ++ transform ds
            Line -> '\n' : transform ds
            Concat a b -> transform (a:b:ds)
            Union _ b -> transform (b:ds)
            Nest _ x -> transform (x:ds)

-- Formata respeitando a largura e a indentacao
pretty :: Int -> Doc -> String
pretty width doc = best 0 [(0, doc)]
  where
    best _ [] = ""
    best col ((indent, d):ds) =
        case d of
            Empty -> best col ds

            Char c ->
                c : best (col + 1) ds

            Text s ->
                s ++ best (col + length s) ds

            Line ->
                '\n' : replicate indent ' '
                ++ best indent ds

            Concat a b ->
                best col ((indent, a):(indent, b):ds)

            Nest n x ->
                best col ((indent + n, x):ds)

            Union a b ->
                let left = best col ((indent, a):ds)
                    right = best col ((indent, b):ds)
                in if fits (width - col) left
                   then left
                   else right

    fits n _ | n < 0 = False
    fits _ "" = True
    fits _ ('\n':_) = True
    fits n (_:cs) = fits (n - 1) cs
