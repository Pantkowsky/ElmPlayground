module HttpCall exposing (..)

import Browser
import Html exposing (Html, text, pre)
import Http

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

type Model
    = Failure
    | Loading
    | Success String

type Msg = GotText (Result Http.Error String)

fetchCommand: Cmd Msg
fetchCommand =
    Http.get {
        url = "https://elm-lang.org/assets/public-opinion.txt",
        expect = Http.expectString GotText
    }

init: () -> (Model, Cmd Msg)
init _ =
    ( Loading
    , fetchCommand
    )

update: Msg -> Model -> (Model, Cmd Msg)
update msg _ =
    case msg of
        GotText result ->
            case result of
                Ok text -> ( Success text, Cmd.none )
                Err _ -> ( Failure, Cmd.none )

subscriptions: Model -> Sub Msg
subscriptions _ =
    Sub.none

view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "I was unable to load your book."

    Loading ->
      text "Loading..."

    Success fullText ->
      pre [] [ text fullText ]
