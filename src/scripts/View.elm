module View exposing (..)

import Html exposing (Html, div, text)
import Messages exposing (Msg)
import Models exposing (Model)


view model =
    div []
        [ text model ]
