module LoginForm exposing (main)

import Browser
import Constants exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

type alias Model = { name: String, age: Maybe Int, password: String, validatedPassword: String, loginResult: String }

type Msg = Name String
    | Age String
    | Password String
    | ValidatedPassword String
    | LoginResult String

main: Program() Model Msg
main = Browser.sandbox { init = init, update = update, view = view }

init: Model
init = Model "" Maybe.Nothing "" "" "Sign-up form example"

update: Msg -> Model -> Model
update msg model =
    case msg of
        Name name -> { model | name = name }
        Age age -> { model | age = String.toInt age }
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
                input [ placeholder "What is your age?", onInput Age ] [ ],
                validateAge model.age
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

validateAge: Maybe Int -> Html Msg
validateAge age =
    case age of
        Nothing -> div [  ] [ text "" ]
        Just a ->
            if a < 0 then
                div [ style "color" "red" ] [ text "You can't have negative age" ]
            else if a < 18 then
                div [ style "color" "red" ] [ text "You need to be at least 18 to enter this page" ]
            else
                div [  ] [ text "" ]

checkAge: Maybe Int -> Msg
checkAge age =
    case age of
        Nothing -> message incorrectAgeMessage
        Just a ->
            if a < 18 then
                message incorrectAgeMessage
            else
                message successMessage


textInput: String -> String -> String -> (String -> msg) -> Html msg
textInput text pswd validated msg =
    input [ type_ text, placeholder pswd, value validated, onInput msg ] [ ]

validate: Model -> Msg
validate model =
    if model.password == model.validatedPassword then
        if checkLength model.password then
            checkAge model.age
        else
            message shortPasswordMessage
    else
        message wrongPasswordMessage

checkLength: String -> Bool
checkLength password =
    if String.length password > requiredLength then True else False

message: String -> Msg
message msg =
    LoginResult msg