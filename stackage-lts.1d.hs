#!/usr/bin/env /usr/local/bin/stack
{- stack
  --resolver lts-16.10
  --install-ghc
  runghc
  --package wreq
  --package aeson
  --package lens-aeson
-}

-- <bitbar.title>Stackage LTS monitor</bitbar.title>
-- <bitbar.version>v0.1</bitbar.version>
-- <bitbar.author>Mladen Srdić</bitbar.author>
-- <bitbar.author.github>msrdic</bitbar.author.github>
-- <bitbar.desc>
--   This plugin simply shows the latest LTS Stackage version in your menubar.
-- </bitbar.desc>
-- <bitbar.dependencies>haskell, stack</bitbar.dependencies>

{-# LANGUAGE OverloadedStrings #-}

import           Control.Lens
import           Data.Aeson.Lens
import           Data.Maybe         (fromMaybe)
import qualified Data.Text          as DT
import           Network.Wreq

listLTSPath = "https://www.stackage.org/download/lts-snapshots.json"

main = do
  resp <- getLTSInfo
  putStrLn $ DT.unpack $ fromMaybe "?" $ extractLTS $ resp

extractLTS j = j ^. responseBody ^? key "lts" . _String
getLTSInfo = getWith defaults $ listLTSPath