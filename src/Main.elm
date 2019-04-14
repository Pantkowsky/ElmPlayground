module Main exposing (main)

import Browser
import Html exposing (Html, button, text, div)
import Html.Events exposing (onClick)

type alias Model = { count : Int }

initialModel : Model
initialModel = { count = 0 }

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment -> { model | count = model.count + 1 }
        Decrement -> { model | count = model.count - 1 }

view : Model -> Html Msg
view model =
    div [] [
        button [ onClick Increment ] [ text "Increment counter" ]
        , div [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "Decrement counter" ]
        ]

main : Program() Model Msg
main = Browser.sandbox
    { init = initialModel,
      view = view,
      update = update }