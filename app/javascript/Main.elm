module Main exposing (..)

import Html exposing (Html, body, div, h1, h2, p, text)
import Html.Attributes exposing (style)
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
  }

-- INIT

edbaskerville = User "edbaskerville"
peidran = User "peidran"

init : (Model, Cmd Msg)
init =
  ( Model
    edbaskerville
    [ Message edbaskerville "12:56 PM" (fromTime ((1515532452 - 7200) * 1000))
    , Message peidran "What time is it?" (fromTime ((1515532366 - 3600) * 1000))
    ]
  , Cmd.none
  )

-- VIEW

view : Model -> Html Msg
view model =
  body []
  [
    div []
    [ h1 [] [text "Hello Elm!"]
    , messagesView model.messages
    ]
  ]

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

-- ELM MESSAGE

formatDate : Date -> String
formatDate date =
  toString date

type Msg
  = None

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)

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
