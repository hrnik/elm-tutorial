module Messages exposing (..)

import Players.Messages
import Navigation exposing (Location)


type Msg
    = PlayersMsg Players.Messages.Msg
    | OnLocationChange Location
