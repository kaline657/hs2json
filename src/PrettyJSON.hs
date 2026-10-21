
module PrettyJSON
    ( renderJValue
    ) where

import SimpleJSON
import Prettify
import Prelude hiding ((<>))
import Data.Char (ord)
import Numeric (showHex)

-- Converte um valor JSON em um documento
renderJValue :: JValue -> Doc

-- Representa um valor booleano
renderJValue (JBool True) = text "true"
renderJValue (JBool False) = text "false"

-- Representa um valor nulo
renderJValue JNull = text "null"

-- Representa um numero
renderJValue (JNumber n) = double n

-- Representa uma string
renderJValue (JString s) = string s

-- Representa um array JSON
renderJValue (JArray a) =
    series '[' ']' renderJValue a

-- Representa um objeto JSON
renderJValue (JObject o) =
    series '{' '}' field o
  where
    field (name, value) =
        string name <> text ": " <> renderJValue value

-- Converte uma string em documento JSON
string :: String -> Doc
string s = char '"' <> hcat (map oneChar s) <> char '"'

-- Trata caracteres especiais
oneChar :: Char -> Doc
oneChar c =
    case c of
        '"'  -> text "\\\""
        '\\' -> text "\\\\"
        '\b' -> text "\\b"
        '\f' -> text "\\f"
        '\n' -> text "\\n"
        '\r' -> text "\\r"
        '\t' -> text "\\t"
        _
            | ord c < 0x20 -> hexEscape c
            | otherwise -> char c

-- Representa caracteres de controle
hexEscape :: Char -> Doc
hexEscape c =
    text "\\u" <> text (replicate (4 - length h) '0' ++ h)
  where
    h = showHex (ord c) ""

-- Organiza os elementos de arrays e objetos JSON
series :: Char -> Char -> (a -> Doc) -> [a] -> Doc
series open close item values =
    char open <> elements <> char close
  where
    elements =
        case values of
            [] -> empty
            _  -> line <> fsep (punctuate (char ',') (map item values)) <> line
