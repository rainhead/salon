module Main exposing (..)

import Html exposing (Html, body, div, h1, h2, p, input, text, label, button)
import Html.Attributes exposing (style, type_, placeholder, value)
import Html.Events exposing (onInput, onClick)
import Date exposing (..)

-- MODEL

type alias User =
  { name : String
  }

type alias Message =
  { author : User
  , body   : String
  , date   : Date
  }

type alias Model =
  { user     : User
  , messages : List Message
  , nextMessageBody : String
  }

-- INIT

edbaskerville = User "edbaskerville"
peidran = User "peidran"

init_messages =
  [ Message edbaskerville "12:56 PM" (fromTime ((1515532452 - 7200) * 1000))
  , Message peidran "What time is it?" (fromTime ((1515532366 - 3600) * 1000))
  ]

init : (Model, Cmd Msg)
init =
  ( Model edbaskerville init_messages ""
  , Cmd.none
  )

-- VIEW

view : Model -> Html Msg
view model =
  body []
  [
    div []
      [ h1 [] [text "2020 Salon"]
      , userView model.user
      , messagesView model.messages
      , composeView
      ]
  ]


-- USER VIEW: edit username

userView : User -> Html Msg
userView user =
  div []
    [ label [] [text "Username: "]
    , input
        [ type_ "text"
        , placeholder "username"
        , value user.name
        , onInput SetUsername
        ]
        []
    ]


-- MESSAGES VIEW: show messages

messagesView : List Message -> Html Msg
messagesView messages =
  div []
  (List.map messageView messages)

messageView : Message -> Html Msg
messageView message =
  div []
    [ h2 [] [text (message.author.name ++ " at " ++ (formatDate message.date))]
    , p [] [text message.body]
    ]


-- COMPOSE VIEW: compose new messages

composeView: Html Msg
composeView =
  div []
    [ input
        [ type_ "text"
        , placeholder "Write a message"
        , onInput UpdateNextMessageBody
        ]
        []
    , button [onClick PostMessage] [text "Post"]
    ]


-- ELM MESSAGE

formatDate : Date -> String
formatDate date =
  toString date

type Msg
  = SetUsername String
  | UpdateNextMessageBody String
  | PostMessage

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetUsername name ->
      ({model | user = (User name)}, Cmd.none)
    UpdateNextMessageBody body ->
      ({model | nextMessageBody = body}, Cmd.none)
    PostMessage ->
      ( { model | messages =
        ( model.messages ++ [Message model.user model.nextMessageBody (fromTime ((1515532366 - 3600) * 1000))] )
        }
      , Cmd.none
      )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- MAIN

main : Program Never Model Msg
main =
  Html.program
    {
      init = init,
      view = view,
      update = update,
      subscriptions = subscriptions
    }
