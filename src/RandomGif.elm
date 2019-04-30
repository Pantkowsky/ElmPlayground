module RandomGif exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (Decoder, map2, field, string)
import Http

type alias Model = { name: String, response: Response }

type alias Gif = { url: String, imageSrc: String }

type Response = Initial
    | Failure
    | Loading
    | Success String String

type Msg = SaveTag String
    | Next
    | GotGif (Result Http.Error Gif)

main = Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

initModel: Model
initModel = Model "cat" Initial

init: () -> (Model, Cmd Msg)
init _ = ( initModel , Cmd.none)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SaveTag tag -> ({ model | name = tag, response = Loading}, Cmd.none)
        Next -> ( { model| response = Loading }, getRandomGif model.name)
        GotGif result ->
            case result of
                Ok res -> ({ model | response = Success res.url res.imageSrc }, Cmd.none)
                Err _ -> ({ model | response = Failure }, Cmd.none)

subscriptions: Model -> Sub Msg
subscriptions _ =
    Sub.none

view: Model -> Html Msg
view model =
    div [ class "background" ] [
        div [ class "boxCounter" ] [
            input [ placeholder "What the fuck", onInput SaveTag ] [ ],
            button [ onClick Next ] [ text "Search" ]
        ],
        gif model.response
    ]

gif: Response -> Html Msg
gif model =
    case model of
        Initial ->
            div [  class "cmdMessage"  ] [
                text "Type in your search query above"
            ]
        Failure ->
            div [ class "cmdMessage" ] [
                text "Failure with loading gifs",
                button [ onClick Next ] [ text "Try again" ]
            ]
        Loading ->
            div [  class "cmdMessage"  ] [
                text "Loading the next gif"
            ]
        Success url imgSrc ->
            div [  class "cmdMessage"  ] [
                div [ ] [
                    img [ src imgSrc ] [ ]
                ],
                div [ ] [
                    h2 [ ] [ text url ]
                ]
            ]

getRandomGif: String -> Cmd Msg
getRandomGif tag =
    Http.get
        { url = requestUrl tag
        , expect = Http.expectJson GotGif decoder}

requestUrl: String -> String
requestUrl tag = String.concat ["https://api.giphy.com/v1/gifs/random?api_key=Ei1N4q52AxxlRK6Lf11Ka6VzvX00yKCM&tag=", tag]

decoder: Decoder Gif
decoder =
    map2 Gif
        (field "data" (field "url" string))
        (field "data" (field "image_url" string))