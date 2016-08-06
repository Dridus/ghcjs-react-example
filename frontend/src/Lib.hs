{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where

import Data.JSString ()
import GHCJS.Types

foreign import javascript unsafe "console.log($1)" console_log :: JSString -> IO ()

someFunc :: IO ()
someFunc = console_log "Hello from GHCJS!"
