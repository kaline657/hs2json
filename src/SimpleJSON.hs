
module SimpleJSON
    ( JValue(..)
    , getString
    , getInt
    , getDouble
    , getBool
    , getObject
    , getArray
    , isNull
    ) where

-- Representacao dos tipos de valores JSON
data JValue
    = JString String
    | JNumber Double
    | JBool Bool
    | JNull
    | JObject [(String, JValue)]
    | JArray [JValue]
    deriving (Eq, Show)


-- Acessa um valor do tipo String
getString :: JValue -> Maybe String
getString (JString s) = Just s
getString _ = Nothing

-- Acessa um valor inteiro
getInt :: JValue -> Maybe Int
getInt (JNumber n)
    | isInfinite n || isNaN n = Nothing
    | n == fromInteger (round n) = Just (round n)
    | otherwise = Nothing
getInt _ = Nothing

-- Acessa um numero decimal
getDouble :: JValue -> Maybe Double
getDouble (JNumber n) = Just n
getDouble _ = Nothing

-- Acessa um valor booleano
getBool :: JValue -> Maybe Bool
getBool (JBool b) = Just b
getBool _ = Nothing

-- Acessa um objeto JSON
getObject :: JValue -> Maybe [(String, JValue)]
getObject (JObject obj) = Just obj
getObject _ = Nothing

-- Acessa um array JSON
getArray :: JValue -> Maybe [JValue]
getArray (JArray arr) = Just arr
getArray _ = Nothing

-- Verifica se um valor JSON e nulo
isNull :: JValue -> Bool
isNull JNull = True
isNull _ = False
