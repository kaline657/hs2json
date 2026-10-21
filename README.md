
# hs2json — Projeto Haskell

Projeto desenvolvido para a Avaliação da Unidade 2 da disciplina de Programação Funcional.

## Objetivo

Implementar uma biblioteca em Haskell para representar valores JSON e gerar documentos formatados.

## Funcionalidades

- Representação dos tipos JSON: String, Number, Bool, Null, Object e Array.
- Funções para acessar valores JSON com segurança.
- Construção de documentos usando o módulo Prettify.
- Conversão de valores JSON em texto.
- Formatação com largura configurável.
- Testes automatizados usando QuickCheck.

## Estrutura do projeto

```text
hs2json/
├── src/
│   ├── SimpleJSON.hs
│   ├── Prettify.hs
│   └── PrettyJSON.hs
├── test/
│   ├── Spec.hs
│   └── TesteManual.hs
├── hs2json.cabal
├── .gitignore
└── README.md
```

## Requisitos

- GHC (testado com 9.10.3)
- Cabal (testado com 3.16.1.0)
- QuickCheck (instalado pelo Cabal)

## Como compilar

No terminal, dentro da pasta do projeto:

```bash
cabal build
```

## Como executar o exemplo

```bash
cabal run hs2json-demo
```

## Como executar os testes

```bash
cabal test --test-show-details=direct
```

O arquivo `test/Spec.hs` contém sete propriedades QuickCheck para verificar o comportamento das funções implementadas.

## Módulos

### SimpleJSON.hs

Define o tipo JValue e suas funções de acesso.

### Prettify.hs

Implementa a estrutura Doc, operações de concatenação e formatação de documentos.

### PrettyJSON.hs

Transforma valores JValue em documentos Doc, permitindo sua renderização como texto JSON.

## Controle de versão

O desenvolvimento é registrado por commits incrementais no GitHub, documentando as principais funcionalidades, correções e testes.

Repositório: https://github.com/kaline657/hs2json
