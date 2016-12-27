module Players.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Players.Models exposing (PlayerId, Player)
import Players.Messages exposing (..)


fetchAll : Cmd Msg
fetchAll =
    Http.get fetchAllUrl collectionDecoder
        |> Http.send OnFetchAll


fetchAllUrl : String
fetchAllUrl =
    "http://localhost:4000/players"


collectionDecoder : Decode.Decoder (List Player)
collectionDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Player
memberDecoder =
    Decode.map3 Player
        (field "id" Decode.string)
        (field "name" Decode.string)
        (field "level" Decode.int)


playerUrl : PlayerId -> String
playerUrl playerId =
    "http://localhost:4000/players/" ++ playerId


saveRequest : Player -> Http.Request Player
saveRequest player =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = playerUrl player.id
        , body = memberEncoded player |> Http.jsonBody
        , expect = Http.expectJson memberDecoder
        , timeout = Nothing
        , withCredentials = False
        }


save : Player -> Cmd Msg
save player =
    saveRequest player
        |> Http.send OnSave


deleteRequest : Player -> Http.Request Player
deleteRequest player =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = playerUrl player.id
        , body = memberEncoded player |> Http.jsonBody
        , expect = Http.expectStringResponse (\_ -> Ok (player))
        , timeout = Nothing
        , withCredentials = False
        }


delete : Player -> Cmd Msg
delete player =
    deleteRequest player
        |> Http.send OnDelete


memberEncoded : Player -> Encode.Value
memberEncoded player =
    let
        list =
            [ ( "id", Encode.string player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        list
            |> Encode.object
