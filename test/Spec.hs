
module Main where

import Prelude hiding ((<>))
import Test.QuickCheck
import SimpleJSON
import Prettify

-- Teste 1: recuperar uma string
prop_getString :: String -> Bool
prop_getString s =
    getString (JString s) == Just s

-- Teste 2: recuperar um booleano
prop_getBool :: Bool -> Bool
prop_getBool b =
    getBool (JBool b) == Just b

-- Teste 3: recuperar um numero inteiro
prop_getInt :: Int -> Bool
prop_getInt n =
    getInt (JNumber (fromIntegral n)) == Just n

-- Teste 4: recuperar um array
prop_getArray :: [Int] -> Bool
prop_getArray ns =
    let valores = map (JNumber . fromIntegral) ns
    in getArray (JArray valores) == Just valores

-- Teste 5: verificar valor nulo
prop_isNull :: Bool
prop_isNull = isNull JNull

-- Teste 6: documento vazio
prop_empty :: String -> Bool
prop_empty s =
    pretty 80 (text s <> empty) == s

-- Teste 7: concatenacao de documentos
prop_concat :: String -> String -> Bool
prop_concat a b =
    pretty 80 (text a <> text b) == a ++ b

-- Executa os testes
main :: IO ()
main = do
    quickCheck prop_getString
    quickCheck prop_getBool
    quickCheck prop_getInt
    quickCheck prop_getArray
    quickCheck prop_isNull
    quickCheck prop_empty
    quickCheck prop_concat
