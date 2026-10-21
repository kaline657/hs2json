
module SimpleJSON where

-- Representacao dos tipos de valores JSON
data JValue
    = JString String
    | JNumber Double
    | JBool Bool
    | JNull
    | JObject [(String, JValue)]
    | JArray [JValue]
    deriving (Eq, Show)
