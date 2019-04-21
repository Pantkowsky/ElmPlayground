module Helpers exposing (..)

asNumber: String -> Int
asNumber value =
    Maybe.withDefault 0 (String.toInt value)