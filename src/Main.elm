module Main exposing (main)

import Browser
import Html exposing (Html, button, text, div, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

type alias Model = { count : Int, text : String }

main : Program() Model Msg
main = Browser.sandbox { init = init, view = view, update = update }

init : Model
init = { count = 0, text = "" }

type Msg = Increment | Decrement | Reset | Change String

update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment -> { model | count = model.count + 1, text = String.fromInt model.count }
        Decrement -> { model | count = model.count - 1, text = String.fromInt model.count }
        Reset -> { model | count = 0, text = "0" }
        Change value -> { model | count = asNumber value, text = value   }

asNumber: String -> Int
asNumber value =
    Maybe.withDefault 0 (String.toInt value)

view : Model -> Html Msg
view model =
    div [ class "background" ] [
        div [ class "boxCounter" ] [ text <| "Current value is: " ++ String.fromInt model.count ],
        div [ class "inputField" ] [
            button [ class "button", onClick Increment ] [ text "Increment" ],
            button [ class "button", onClick Decrement ] [ text "Decrement" ],
            button [ class "button", onClick Reset ] [ text "Reset" ]
        ],
        div [ class "inputField" ] [
            div [ ] [ text "or" ],
            input [ class "field", placeholder "Input your own", onInput Change] [ ]
        ]
    ]

