module Reverse exposing (main)

import Browser
import Html exposing (Html, text, input, div)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onInput)

type alias Model = { text : String }
type Msg = Reverse String

main : Program() Model Msg
main = Browser.sandbox { init = init, view = view, update = update }

init : Model
init = { text = "" }

update : Msg -> Model -> Model
update msg model =
    case msg of
        Reverse value -> { model | text = reverse value}

view : Model -> Html Msg
view model =
    div [ class "background" ] [
        div [ class "boxCounter" ] [ text <| "Result: " ++  model.text ],
        div [ class "inputField" ] [
            input [ class "field", placeholder "Text to be reversed", onInput Reverse ] [ ]
        ]
    ]

reverse: String -> String
reverse value =
    String.reverse value