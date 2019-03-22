{-# LANGUAGE OverloadedStrings #-}
module MyAntigen where

import Antigen (
                -- Rudimentary imports
                AntigenConfig (..)
              , defaultConfig
              , bundle
              , antigen
                -- If you want to source a bit trickier plugins
              , ZshPlugin (..)
              , antigenSourcingStrategy
              , filePathsSourcingStrategy
              )

bundles =
  [ bundle "Tarrasch/zsh-functional"
  , bundle "Tarrasch/zsh-bd"
  , bundle "zsh-users/zsh-syntax-highlighting"
  , bundle "mafredri/zsh-async"
  , bundle "sindresorhus/pure"
  , (bundle "zsh-users/zsh-history-substring-search") { sourcingStrategy = antigenSourcingStrategy }
  ]

config = defaultConfig { plugins = bundles }

main :: IO ()
main = antigen config
