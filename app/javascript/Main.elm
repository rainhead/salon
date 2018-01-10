module Main exposing (..)

import Html exposing (Html, body, div, h1, h2, p, input, text, label, button)
import Html.Attributes exposing (style, type_, placeholder, value)
import Html.Events exposing (onInput, onClick)
import Date exposing (Date)

import Json.Decode exposing (..)

-- MODEL

type alias User =
  { name : String
  }

type alias Message =
  { author : User
  , body   : String
  , date   : Maybe Date
  }

parseDate : String -> Maybe Date
parseDate dateString =
  let
    dateResult = Date.fromString dateString
  in
    case dateResult of
      Ok date ->
        Just date
      Err date ->
        Nothing

makeMessage : String -> String -> String -> Message
makeMessage authorString bodyString dateString =
  Message (User authorString) bodyString (parseDate dateString)

type alias Model =
  { user     : User
  , messages : List Message
  , nextMessageBody : String
  }


-- JSON DECODING

messageDecoder = map3 makeMessage (field "author" string) (field "body" string) (field "created_at" string)
messagesDecoder = list messageDecoder


-- INIT

init_messages_json =
  """
  [
    {
      "id": 1,
      "author": "Peter",
      "body": "Hello, World",
      "created_at": "2018-01-07T06:01:23.543Z"
    },
    {
      "id": 2,
      "author": "Ed",
      "body": "Hello, API (from curl)",
      "created_at": "2018-01-10T08:18:09.783Z"
    }
  ]
  """

init_messages_test =
  decodeString messagesDecoder init_messages_json

edbaskerville = User "edbaskerville"
peidran = User "peidran"

init_messages =
  case init_messages_test of
    Ok messages ->
      messages
    
    Err err ->
      []

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
        , Html.Attributes.value user.name
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

formatDate : Maybe Date -> String
formatDate date =
  case date of
    Just date ->
      toString date
    Nothing ->
      "(date not present)"

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
        ( model.messages ++ [Message model.user model.nextMessageBody Nothing] )
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
