
module Main where

import Prelude hiding ((<>))
import Test.QuickCheck
import SimpleJSON
import Prettify
import PrettyJSON
import Data.Char (ord)
import Numeric (showHex)

-- Gerador de valores JSON aleatorios
instance Arbitrary JValue where
    arbitrary = sized gerarJValue

gerarJValue :: Int -> Gen JValue
gerarJValue n
    | n <= 0 = oneof valoresSimples
    | otherwise =
        frequency
            [ (5, oneof valoresSimples)
            , (2, gerarArray)
            , (2, gerarObjeto)
            ]
  where
    valoresSimples =
        [ JString <$> arbitrary
        , JNumber <$> choose (-1000, 1000)
        , JBool <$> arbitrary
        , pure JNull
        ]

    gerarArray = do
        elementos <- resize (n `div` 2) $
            listOf (gerarJValue (n `div` 2))
        return (JArray elementos)

    gerarObjeto = do
        campos <- resize (n `div` 2) $
            listOf $ do
                chave <- arbitrary
                valor <- gerarJValue (n `div` 2)
                return (chave, valor)
        return (JObject campos)

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

-- Teste 8: recuperar valores JSON de arrays
prop_getArrayJValue :: JValue -> Bool
prop_getArrayJValue valor =
    getArray (JArray [valor]) == Just [valor]

-- Teste 9: recuperar valores JSON de objetos
prop_getObjectJValue :: JValue -> Bool
prop_getObjectJValue valor =
    getObject (JObject [("chave", valor)])
        == Just [("chave", valor)]

-- Teste 10: escapar aspas em strings
prop_escapeAspas :: Bool
prop_escapeAspas =
    pretty 80 (renderJValue (JString "Ola \"Maria\""))
        == "\"Ola \\\"Maria\\\"\""

-- Teste 11: escapar quebra de linha
prop_escapeNovaLinha :: Bool
prop_escapeNovaLinha =
    pretty 80 (renderJValue (JString "Ola\nMundo"))
        == "\"Ola\\nMundo\""

-- Teste 12: preservar caracteres Unicode comuns
prop_unicode :: Bool
prop_unicode =
    pretty 80 (renderJValue (JString "ação"))
        == "\"ação\""

-- Teste 13: objetos e arrays vazios
prop_vazios :: Bool
prop_vazios =
    pretty 80 (renderJValue (JArray [])) == "[]"
    &&
    pretty 80 (renderJValue (JObject [])) == "{}"

-- Teste 14: array aninhado com indentacao
prop_arrayAninhado :: Bool
prop_arrayAninhado =
    let valor = JArray [JArray [JBool True]]
        resultado = pretty 80 (renderJValue valor)
    in resultado ==
        "[\n    [\n        true\n    ]\n]"

-- Teste 15: objetos com caracteres especiais nas chaves
prop_chaveEspecial :: Bool
prop_chaveEspecial =
    let valor = JObject [("nome\"com aspas", JNull)]
        resultado = pretty 80 (renderJValue valor)
    in resultado ==
        "{\n    \"nome\\\"com aspas\": null\n}"

-- Teste 16: caracteres de controle em JSON
prop_controle :: Bool
prop_controle =
    let c = '\x0001'
        resultado = pretty 80 (renderJValue (JString [c]))
        h = showHex (ord c) ""
        esperado = "\"\\u" ++ replicate (4 - length h) '0' ++ h ++ "\""
    in resultado == esperado

-- Executa os testes automatizados
main :: IO ()
main = do
    quickCheck prop_getString
    quickCheck prop_getBool
    quickCheck prop_getInt
    quickCheck prop_getArray
    quickCheck prop_isNull
    quickCheck prop_empty
    quickCheck prop_concat
    quickCheck prop_getArrayJValue
    quickCheck prop_getObjectJValue
    quickCheck prop_escapeAspas
    quickCheck prop_escapeNovaLinha
    quickCheck prop_unicode
    quickCheck prop_vazios
    quickCheck prop_arrayAninhado
    quickCheck prop_chaveEspecial
    quickCheck prop_controle
