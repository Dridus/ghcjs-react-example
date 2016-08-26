{-# LANGUAGE DeriveGeneric, OverloadedStrings, TemplateHaskell #-}

module Lib
  ( someFunc
  ) where

import Control.Monad.Reader (ask)
import Data.JSString (JSString)
import Data.Maybe (fromMaybe)
import GHC.Generics (Generic)
import GHCJS.DOM (currentDocument)
import GHCJS.DOM.Document (getBody, createElement)
import GHCJS.DOM.Node (appendChild)
import GHCJS.Marshal (FromJSVal, ToJSVal)
import qualified React as R
import qualified React.DOM as DOM

data Counter = Counter { dummy :: String, count :: Int } deriving (Generic)

instance ToJSVal Counter
instance FromJSVal Counter

R.makeClass "counter"
  [| R.statefulSpec (pure $ Counter "" 0) $ do
      clicker <- R.eventHandler . const $ R.getState >>= R.setState . Counter "" . (+1) . count
      pure $ do
        count <- count <$> R.getState
        this <- ask
        pure $
          DOM.div_ []
            [ DOM.div_ [] ["The count is ", R.text $ show count]
            , DOM.button_ [R.onClick this clicker] ["Click!"]
            ]
  |]
counter :: R.ReactClass R.OnlyAttributes

root :: R.ReactElement
root =
  DOM.div_ []
    [ DOM.h1_ [] ["hello world!"]
    , R.createElement counter [] []
    ]

someFunc :: IO ()
someFunc = do
  doc <- fromMaybe (error "no current document!") <$> currentDocument
  body <- fromMaybe (error "no body!") <$> getBody doc
  mountpoint <- fromMaybe (error "couldn't create a div!") <$> createElement doc (Just ("div" :: JSString))
  _ <- appendChild body (Just mountpoint)
  R.render root mountpoint Nothing
