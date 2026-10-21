# hs2json — Projeto Haskell
Link da apresentação em Drive: https://drive.google.com/file/d/1DE4fUnzRuThKgcBoZtFA8pd7h_oT3fTv/view?usp=drivesdk
Projeto desenvolvido para a Avaliação da Unidade 2 da disciplina de Programação Funcional.

## Objetivo

Implementar uma biblioteca em Haskell para representar valores JSON, acessar seus dados com segurança e gerar documentos formatados.

## Funcionalidades

- Representação dos tipos JSON: String, Number, Bool, Null, Object e Array.
- Funções de acesso aos valores JSON utilizando `Maybe`.
- Validação de números inteiros, incluindo verificação de limites.
- Tratamento de caracteres especiais e Unicode.
- Formatação de objetos e arrays com indentação.
- Controle da largura de formatação dos documentos.
- Geração de valores JSON aleatórios utilizando QuickCheck.
- 16 propriedades de teste automatizadas.

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
- QuickCheck (instalado automaticamente pelo Cabal)
- Git para clonar o repositório

## Como instalar

Clone o repositório:

```bash
git clone https://github.com/kaline657/hs2json.git
```

Entre na pasta do projeto:

```bash
cd hs2json
```

## Como compilar

Execute:

```bash
cabal build
```

O Cabal compilará os módulos e instalará as dependências necessárias.

## Como executar o exemplo

```bash
cabal run hs2json-demo
```

O programa executará o exemplo definido em `test/TesteManual.hs`, demonstrando a geração e formatação de um objeto JSON.

## Como executar os testes

```bash
cabal test --test-show-details=direct
```

O arquivo `test/Spec.hs` contém 16 propriedades QuickCheck.

Os testes verificam:

- Recuperação de Strings, números, booleanos, arrays e objetos.
- Identificação de valores nulos.
- Concatenação de documentos.
- Comportamento de documentos vazios.
- Geração de valores JSON aleatórios.
- Tratamento de aspas e quebras de linha.
- Preservação de caracteres Unicode.
- Formatação de arrays e objetos aninhados.
- Tratamento de caracteres de controle.

## Módulos

### SimpleJSON.hs

Define o tipo `JValue`, responsável por representar os valores JSON.

Implementa funções de acesso e validação de números inteiros.

### Prettify.hs

Implementa o tipo abstrato `Doc` e as operações necessárias para construir e formatar documentos.

Inclui concatenação, quebras de linha, controle de largura e indentação.

### PrettyJSON.hs

Converte valores `JValue` em documentos `Doc`.

Implementa o tratamento de caracteres especiais, Unicode e a organização de objetos e arrays.

## Controle de versão

O desenvolvimento foi registrado por commits incrementais, documentando a evolução das funcionalidades, os testes e as correções realizadas.

## Repositório

https://github.com/kaline657/hs2json
