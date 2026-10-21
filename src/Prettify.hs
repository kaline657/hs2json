
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
    deriving (Show)

-- Documento vazio
empty :: Doc
empty = Empty

-- Documento contendo um caractere
char :: Char -> Doc
char = Char

-- Documento contendo um texto
text :: String -> Doc
text "" = Empty
text s = Text s

-- Documento contendo um numero
double :: Double -> Doc
double = text . show

-- Quebra de linha
line :: Doc
line = Line

-- Concatenacao de documentos
(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y = Concat x y

infixr 6 <>



-- Concatena uma lista de documentos
hcat :: [Doc] -> Doc
hcat = foldr (<>) empty

-- Escolhe entre duas formas de representar um documento
group :: Doc -> Doc
group x = Union (flatten x) x

-- Substitui quebras de linha por espacos
flatten :: Doc -> Doc
flatten (Concat x y) = Concat (flatten x) (flatten y)
flatten Line = Char ' '
flatten (Union x _) = flatten x
flatten other = other

-- Junta documentos usando espacos ou quebras de linha

fsep :: [Doc] -> Doc
fsep [] = empty
fsep [x] = x
fsep (x:xs) = x </> fsep xs

-- Combina documentos com possibilidade de quebra de linha
(</>) :: Doc -> Doc -> Doc
x </> y = group (x <> softline <> y)

infixr 5 </>

-- Quebra de linha opcional
softline :: Doc
softline = group line

-- Adiciona pontuacao entre documentos
punctuate :: Doc -> [Doc] -> [Doc]
punctuate _ [] = []
punctuate _ [x] = [x]
punctuate p (x:xs) = (x <> p) : punctuate p xs

-- Transforma um documento em texto compacto
compact :: Doc -> String
compact x = transform [x]
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

-- Formata um documento respeitando a largura
pretty :: Int -> Doc -> String
pretty width x = best 0 [x]
  where
    best _ [] = ""
    best col (d:ds) =
        case d of
            Empty -> best col ds
            Char c -> c : best (col + 1) ds
            Text s -> s ++ best (col + length s) ds
            Line -> '\n' : best 0 ds
            Concat a b -> best col (a:b:ds)
            Union a b ->
                let left = best col (a:ds)
                    right = best col (b:ds)
                in if fits (width - col) left
                   then left
                   else right

    fits n _ | n < 0 = False
    fits _ "" = True
    fits _ ('\n':_) = True
    fits n (_:cs) = fits (n - 1) cs
