module UI.Media exposing
    ( aboveSmallScreen
    , belowBigScreen
    , notOnPrint
    , onAnyScreen
    , onBigScreen
    , onPrint
    , onSmallScreen
    )

import Css exposing (..)
import Css.Media as Media exposing (..)



-- MEDIA QUERIES


onAnyScreen : List Style -> Style
onAnyScreen =
    withMedia [ only screen [] ]


onSmallScreen : List Style -> Style
onSmallScreen =
    withMedia [ only screen [ Media.maxWidth smallScreen ] ]


aboveSmallScreen : List Style -> Style
aboveSmallScreen =
    withMedia [ only screen [ Media.minWidth smallScreen ] ]


onBigScreen : List Style -> Style
onBigScreen =
    withMedia [ only screen [ Media.minWidth mediumScreen ] ]


belowBigScreen : List Style -> Style
belowBigScreen =
    withMedia
        [ only screen
            [ Media.maxWidth <| removePixel mediumScreen
            ]
        ]


onPrint : List Style -> Style
onPrint =
    withMedia [ only print [] ]


notOnPrint : List Style -> Style
notOnPrint =
    withMedia [ Media.not print [] ]



-- BREAKPOINTS


smallScreen : Em
smallScreen =
    em 44


mediumScreen : Em
mediumScreen =
    em 56



-- HELPERS


removePixel : Em -> Em
removePixel { numericValue } =
    em (numericValue - 1 / 16)
