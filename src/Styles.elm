module Styles exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (style)


lightColor =
    "#ddd"


darkColor =
    "rgb(50, 50, 50)"


yellowColor =
    "rgb(210, 189, 34)"


greenColor =
    "rgb(158, 210, 43)"


blueColor =
    "rgb(48, 110, 212)"


circleStyles : String -> String -> String -> List (Attribute msg)
circleStyles color width height =
    [ style "border-radius" "50%"
    , style "text-align" "center"
    , style "display" "flex"
    , style "align-items" "center"
    , style "justify-content" "center"
    , style "background-color" color
    , style "width" width
    , style "height" height
    ]


container : List (Attribute msg)
container =
    [ style "overflow-x" "hidden"
    , style "position" "relative"
    , style "display" "flex"
    , style "height" "100vh"
    ]


logoImg : List (Attribute msg)
logoImg =
    [ style "position" "absolute"
    , style "left" "20px"
    , style "top" "20px"
    , style "max-width" "60px"
    ]


type DrawerSide
    = Left
    | Right


drawer : DrawerSide -> List (Attribute msg)
drawer side =
    let
        ( bgColor, color, pos ) =
            case side of
                Left ->
                    ( lightColor, darkColor, "left" )

                Right ->
                    ( darkColor, lightColor, "right" )
    in
    [ style "height" "100%"
    , style "position" "absolute"
    , style "top" "0"
    , style pos "0"
    , style "overflow-x" "hidden"
    , style "z-index" "10"
    , style "background-color" bgColor
    , style "color" color
    ]


drawerContent : DrawerSide -> Bool -> List (Attribute msg)
drawerContent side open =
    let
        marginSide =
            case side of
                Left ->
                    "margin-left"

                Right ->
                    "margin-right"

        totalMargin =
            if open then
                "0"

            else
                "-50vw"
    in
    [ style "width" "50vw"
    , style "float" "left"
    , style "height" "100%"
    , style "transition" "margin 700ms"
    , style marginSide totalMargin
    ]


menuButton color =
    [ style "font-size" "3rem"
    , style "cursor" "pointer"
    , style "cursor" "pointer"
    , style "position" "absolute"
    , style "top" "10px"
    , style "right" "20px"
    , style "color" color
    ]


navLink =
    [ style "text-decoration" "none"
    ]


navigationLinks =
    [ style "display" "flex"
    , style "padding" "4rem"
    , style "flex-direction" "column"
    , style "font-size" "2rem"
    ]


drawerText =
    [ style "display" "flex"
    , style "align-items" "center"
    , style "justify-content" "center"
    , style "height" "100%"
    , style "font-size" "2rem"
    ]


menuImg =
    [ style "max-height" "20rem"
    ]


mainDiv : String -> String -> List (Attribute msg)
mainDiv bgColor justify =
    [ style "background-color" bgColor
    , style "position" "relative"
    , style "display" "flex"
    , style "align-items" "center"
    , style "justify-content" justify
    , style "width" "100%"
    , style "height" "100%"
    ]
