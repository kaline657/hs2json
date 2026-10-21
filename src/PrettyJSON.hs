
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

-- Representa valores booleanos
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

-- Organiza arrays e objetos com indentacao
series :: Char -> Char -> (a -> Doc) -> [a] -> Doc
series open close item values =
    case values of
        [] -> char open <> char close
        _  ->
            char open
            <> nest 4 (line <> elementos)
            <> line
            <> char close
  where
    elementos =
        fsep (punctuate (char ',') (map item values))
