module AsciiConverter exposing (..)

import Browser
import Html exposing (Html, text, input, div)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onInput)
import Char exposing (toCode)

type alias Model = { text : String }
type Msg = Convert String

main: Program() Model Msg
main = Browser.sandbox { init = init, update = update, view = view }

init: Model
init = { text = "" }

update: Msg -> Model -> Model
update msg model =
    case msg of
        Convert string -> { model | text = convertAscii string }

view: Model -> Html Msg
view model =
    div [ class "background" ] [
        div [ class "boxCounter" ] [ text <| "Result: " ++  model.text ],
        div [ class "inputField" ] [
            input [ class "field", placeholder "Convert to ASCII", onInput Convert ] [ ]
        ]
    ]

-- Convert a string into it's ASCII equivalent
convertAscii : String -> String
convertAscii text =
    asChars text                    -- decompile the string into the list of chars
        |> toAscii                  -- convert each char into it's ascii equivalent
        |> toStringList             -- map the ascii codes into strings
        |> concatenate              -- compose the final string

-- Decompose a string into a list of it's characters
asChars: String -> List Char
asChars string =
    String.toList string

-- Assemble a list of characters into a string
concatenate: List String -> String
concatenate list =
    String.join separator list

-- Convert a list of integers into a list of strings
toStringList: List Int -> List String
toStringList ints =
    ints
        |> List.map String.fromInt

-- Convert a single character into it's ASCII equivalent
toAscii: List Char -> List Int
toAscii chars =
    chars
        |> List.map toCode

-- String separator
separator: String
separator = " "

