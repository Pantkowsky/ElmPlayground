module LoginForm exposing (main)

import Browser
import Html exposing (..)
import Helpers exposing (asNumber)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

type alias Model = { name: String, age: Int, password: String, validatedPassword: String, loginResult: String }

type Msg = Name String
    | Age String
    | Password String
    | ValidatedPassword String
    | LoginResult String

main: Program() Model Msg
main = Browser.sandbox { init = init, update = update, view = view }

init: Model
init = Model "" 0 "" "" "Sign-up form example"

update: Msg -> Model -> Model
update msg model =
    case msg of
        Name name -> { model | name = name }
        Age age -> { model | age = asNumber age }
        Password pswd -> { model | password = pswd }
        ValidatedPassword validated -> { model | validatedPassword = validated }
        LoginResult result -> { model | loginResult = result }

view: Model -> Html Msg
view model =
    div [class "background" ] [
        div [ class "boxCounter" ] [ text <| model.loginResult ],
        div [ class "loginForm" ] [
            div [ class "loginField" ] [
                div [ ] [ text "Name" ],
                textInput "text" "Type your login" model.name Name
            ],
            div [ class "loginField" ] [
                div [ ] [ text "Age" ],
                input [ placeholder "What is your age?", onInput Age ] [ ]
            ],
            div [ class "loginField" ] [
                div [ ] [ text "Password" ],
                textInput "password" "Password" model.password Password
            ],
            div [ class "loginField" ] [
                div [ ] [ text "Confirm your password"],
                textInput "password" "Re-enter password" model.validatedPassword ValidatedPassword
            ]
        ],
        div [ class "inputField" ] [
            button [ class "button", onClick (validate model) ] [ text "Submit" ]
        ]
    ]


textInput: String -> String -> String -> (String -> msg) -> Html msg
textInput text pswd validated msg =
    input [ type_ text, placeholder pswd, value validated, onInput msg ] [ ]

validate: Model -> Msg
validate model =
    if model.password == model.validatedPassword then
        if checkLength model.password then
            if model.age < 18 then
                LoginResult "You need to be 18 to sign-up"
            else
                LoginResult "Sign-up successful"
        else
            LoginResult "Password is too short. Use more than 8 characters"
    else
        LoginResult "Incorrect password. Have you re-typed it correctly?"

checkLength: String -> Bool
checkLength password =
    if String.length password > 8 then True else False