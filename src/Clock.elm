module Clock exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Time
import Task


main: Program() Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

type alias Model =
    { zone: Time.Zone
    , time: Time.Posix }

init: () -> (Model ,Cmd Msg)
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here )

type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
             , Cmd.none
             )
        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

subscriptions: Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick

view: Model -> Html Msg
view model =
    let
        hour = String.fromInt (Time.toHour model.zone model.time)
        minute = String.fromInt (Time.toMinute model.zone model.time)
        second = String.fromInt (Time.toSecond model.zone model.time)
    in
    div [ class "background" ] [
        div [ class "boxCounter" ] [ text (hour ++ ":" ++ minute ++ ":" ++ second)  ]
    ]