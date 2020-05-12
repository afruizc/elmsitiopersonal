module Main exposing (..)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Dict
import Html exposing (..)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick, onMouseEnter)
import Styles
import Url exposing (Url)
import Url.Parser as Url exposing (Parser)



---- MODEL ----


type Page
    = Home
    | OurWork
    | Error


drawerLinkText =
    Dict.fromList
        [ ( "/home", img (src "/owl.png" :: Styles.menuImg) [] )
        , ( "/work", img [ src "/ourwork.png", style "max-height" "18rem" ] [] )
        , ( "/clients", img [ src "/people.png", style "max-height" "15rem" ] [] )
        , ( "/contact", img [ src "/contactcloud.png", style "max-height" "18rem" ] [] )
        ]


type alias Model =
    { key : Nav.Key
    , page : Page
    , drawersOpen : Bool
    , linkSelected : Html Msg
    }



---- UPDATE ----


type Msg
    = NavTo Url
    | RequestNavTo UrlRequest
    | NoOp
    | ToggleDrawers
    | Select (Html Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        RequestNavTo request ->
            case request of
                Internal url ->
                    ( model, Nav.pushUrl model.key <| Url.toString url )

                External url ->
                    ( model, Nav.load url )

        NavTo url ->
            ( { model | page = urlToPage url, drawersOpen = False }, Cmd.none )

        ToggleDrawers ->
            ( { model | drawersOpen = not model.drawersOpen }, Cmd.none )

        Select content ->
            ( { model | linkSelected = content }, Cmd.none )



---- VIEW ----


init : flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key (urlToPage url) False (div [] []), Cmd.none )


viewPage : Model -> Document Msg
viewPage model =
    case model.page of
        Home ->
            { title = "home", body = [ viewHome model ] }

        OurWork ->
            { title = "our work", body = [ viewOurWork model ] }

        Error ->
            { title = "error", body = [ div [] [ text "error" ] ] }


outerCircle : List (Html Msg) -> Html Msg
outerCircle children =
    div (Styles.circleStyles Styles.lightColor "40rem" "40rem") children


innerCircle : List (Html Msg) -> Html Msg
innerCircle children =
    div
        (Styles.circleStyles Styles.darkColor "32rem" "32rem")
        children


drawerContent : Styles.DrawerSide -> Bool -> List (Html Msg) -> Html Msg
drawerContent side open content =
    div (Styles.drawerContent side open) content


leftDrawer : Html Msg -> Bool -> Html Msg
leftDrawer content open =
    div (Styles.drawer Styles.Left)
        [ drawerContent Styles.Left
            open
            [ div Styles.drawerText <|
                [ content ]
            ]
        ]


getContent : String -> Html Msg
getContent url =
    Dict.get url drawerLinkText
        |> Maybe.withDefault (div [] [])


navLink : String -> String -> Html Msg
navLink url myText =
    a
        ([ href url
         , onMouseEnter <| Select (getContent url)
         ]
            ++ Styles.navLink
        )
        [ text myText ]


rightDrawer : Bool -> Html Msg
rightDrawer open =
    div (Styles.drawer Styles.Right)
        [ drawerContent Styles.Right open <|
            [ span (onClick ToggleDrawers :: Styles.menuButton Styles.lightColor) [ text "✕" ]
            , div Styles.navigationLinks
                [ navLink "/home" "Home"
                , navLink "/work" "Our Work"
                , navLink "/clients" "Clients"
                , navLink "/contact" "Contact"
                ]
            ]
        ]


drawers : Model -> List (Html Msg)
drawers model =
    [ leftDrawer model.linkSelected model.drawersOpen
    , rightDrawer model.drawersOpen
    ]


viewHome : Model -> Html Msg
viewHome model =
    genericView model Styles.yellowColor "center" <|
        [ outerCircle
            [ innerCircle
                [ h1 [ style "color" "#ddd" ] [ text "taking the pain out of code" ] ]
            ]
        ]


viewOurWork : Model -> Html Msg
viewOurWork model =
    genericView model Styles.greenColor "left" <|
        [ div [ style "width" "50%" ]
            [ outerCircle
                [ innerCircle
                    [ h2
                        [ style "color" "#ddd"
                        , style "padding" "1rem"
                        ]
                        [ text "Today it’s an idea. Tomorrow it’s a product. We listen, we communicate, we follow through." ]
                    ]
                ]
            ]
        , div
            [ style "width" "50%"
            , style "align-self" "flex-start"
            , style "margin-left" "2rem"
            , style "color" Styles.darkColor
            ]
            [ h1 [ style "margin-top" "1rem" ] [ text "Our Work" ] ]
        ]


genericView : Model -> String -> String -> List (Html Msg) -> Html Msg
genericView model color side content =
    div Styles.container
        (drawers model
            ++ [ span
                    ([ onClick ToggleDrawers
                     , style "z-index" "1"
                     ]
                        ++ Styles.menuButton Styles.darkColor
                    )
                    [ text "☰" ]
               , div (Styles.mainDiv color side) content
               ]
        )


urlToPage : Url -> Page
urlToPage url =
    url
        |> Url.parse urlParser
        |> Maybe.withDefault Error


urlParser : Parser (Page -> a) a
urlParser =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map Home <| Url.s "home"
        , Url.map OurWork <| Url.s "work"
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = viewPage
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = RequestNavTo
        , onUrlChange = NavTo
        }
