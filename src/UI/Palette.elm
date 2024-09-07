module UI.Palette exposing
    ( Theme(..)
    , almostBlack
    , changeOpacity
    , grey
    , mainBackground
    , paperBackground
    , paperShadow
    , paragraph
    , primary
    , secondary
    , themed
    , title
    , transparent
    )

import Css exposing (..)
import Regex



-- THEME


type Theme
    = Light
    | Dark


themed : a -> a -> Theme -> a
themed darkElement lightElement theme =
    case theme of
        Dark ->
            darkElement

        Light ->
            lightElement



-- PALETTE


type alias Palette =
    { c050 : Color
    , c100 : Color
    , c200 : Color
    , c300 : Color
    , c400 : Color
    , c500 : Color
    , c600 : Color
    , c700 : Color
    , c800 : Color
    , c900 : Color
    }


primary : Palette
primary =
    Palette
        (hex "f9e6f0")
        (hex "f2c0db")
        (hex "ec97c3")
        (hex "e870ab")
        (hex "e45397")
        (hex "e43c83")
        (hex "d2397e")
        (hex "bb3676")
        (hex "a5336f")
        (hex "7d2d61")


secondary : Palette
secondary =
    Palette
        (hex "e5eeff")
        (hex "c4d8f2")
        (hex "a9bcdb")
        (hex "8ba1c4")
        (hex "748db2")
        (hex "5d79a1")
        (hex "4e6b8f")
        (hex "3e5778")
        (hex "2f4561")
        (hex "1c3049")


grey : Palette
grey =
    Palette
        (hex "fafafa")
        (hex "f5f5f5")
        (hex "eeeeee")
        (hex "e0e0e0")
        (hex "bdbdbd")
        (hex "9e9e9e")
        (hex "757575")
        (hex "616161")
        (hex "424242")
        (hex "212121")


transparent : Color
transparent =
    hex "00000000"


almostBlack : Color
almostBlack =
    hex "121212"



-- THEMED PALETTE


mainBackground : Theme -> Color
mainBackground =
    themed
        (paperBackground Dark)
        grey.c200


paperBackground : Theme -> Color
paperBackground =
    themed
        secondary.c900
        grey.c050


paragraph : Theme -> Color
paragraph =
    themed
        grey.c050
        grey.c900


title : Theme -> Color
title =
    themed
        primary.c300
        primary.c600


paperShadow : Theme -> Style
paperShadow =
    themed
        (border3 (px 1) solid grey.c050)
        (batch
            [ smoothGrayShadow
            , border3 (px 1) solid transparent
            ]
        )



-- HELPERS


changeOpacity : Color -> Float -> Color
changeOpacity { red, green, blue } opacity =
    rgba red green blue opacity



-- LOCAL STUFF


smoothGrayShadow : Style
smoothGrayShadow =
    property "box-shadow" <|
        removeExtraWhitespaces """
            0 2.8px 2.2px rgba(0, 0, 0, 0.034),
            0 6.7px 5.3px rgba(0, 0, 0, 0.048),
            0 12.5px 10px rgba(0, 0, 0, 0.06),
            0 22.3px 17.9px rgba(0, 0, 0, 0.072),
            0 41.8px 33.4px rgba(0, 0, 0, 0.086),
            0 100px 80px rgba(0, 0, 0, 0.12)
        """


removeExtraWhitespaces : String -> String
removeExtraWhitespaces =
    Regex.replace
        multipleWhitespaces
        (always " ")
        >> String.trim


multipleWhitespaces : Regex.Regex
multipleWhitespaces =
    Maybe.withDefault Regex.never <|
        Regex.fromString "\\s\\s+"
