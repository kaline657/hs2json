
module Main where

import SimpleJSON
import PrettyJSON
import Prettify

main :: IO ()
main = do
    let pessoa = JObject
            [ ("nome", JString "Maria")
            , ("idade", JNumber 22)
            , ("estudante", JBool True)
            , ("disciplinas", JArray
                [ JString "Haskell"
                , JString "Programacao Funcional"
                ])
            ]

    putStrLn (pretty 80 (renderJValue pessoa))
