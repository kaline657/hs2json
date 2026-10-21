
module PrettyJSON
    ( renderJValue
    ) where

import SimpleJSON
import Prettify
import Prelude hiding ((<>))

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
renderJValue (JString s) = text (show s)

-- Representa um array JSON
renderJValue (JArray a) =
    series '[' ']' renderJValue a

-- Representa um objeto JSON
renderJValue (JObject o) =
    series '{' '}' field o
  where
    field (name, value) =
        text (show name) <> text ": " <> renderJValue value



-- Organiza os elementos de arrays e objetos JSON
series :: Char -> Char -> (a -> Doc) -> [a] -> Doc
series open close item values =
    char open <> elements <> char close
  where
    elements =
        case values of
            [] -> empty
            _  -> line <> fsep (punctuate (char ',') (map item values)) <> line
