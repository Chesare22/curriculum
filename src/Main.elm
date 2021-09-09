port module Main exposing (..)

import Browser
import Css exposing (..)
import Css.Global as Global
import Css.Media as Media exposing (only, print, screen, withMedia)
import FeatherIcons
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events exposing (..)
import Language exposing (Language(..), translated)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..), Icon)
import Phone
import QRCode
import Regex
import Svg.Attributes
import Svg.Styled
import Time



-- MAIN


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view >> toUnstyled
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- PORTS


port printPage : () -> Cmd msg



-- MODEL


type Theme
    = Light
    | Dark


type alias Flags =
    { profilePicture : String
    , preferredTheme : String
    , qrUrl : String
    }


type alias Model =
    { theme : Theme
    , language : Language.Language
    , profilePicture : String
    , qrUrl : String
    }


init : Flags -> ( Model, Cmd Msg )
init { profilePicture, preferredTheme, qrUrl } =
    ( { theme =
            if preferredTheme == "dark" then
                Dark

            else
                Light
      , language = Language.English
      , profilePicture = profilePicture
      , qrUrl = qrUrl
      }
    , Cmd.none
    )



-- CASE EXPRESSIONS OF MODEL


themed : a -> a -> Theme -> a
themed darkElement lightElement theme =
    case theme of
        Dark ->
            darkElement

        Light ->
            lightElement



-- UPDATE


type Msg
    = ChangeTheme
    | ChangeLanguage Language
    | Print


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTheme ->
            ( { model | theme = toggleTheme model.theme }
            , Cmd.none
            )

        ChangeLanguage language ->
            ( { model | language = language }
            , Cmd.none
            )

        Print ->
            ( model
            , printPage ()
            )


toggleTheme : Theme -> Theme
toggleTheme =
    themed Light Dark



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ Attributes.css
            [ minHeight (vh 100)
            , maxWidth (vw 100)
            , displayGrid
            , property "grid-template-columns" "1fr"
            , property "justify-items" "center"
            , color <| paragraphColor model.theme
            , onlyScreen
                [ paddingTop optionsBarHeight
                ]
            ]
        ]
        [ Global.global
            [ Global.selector "#options-bar.hidden"
                [ top (rem (negate optionsBarHeightInt))
                ]
            , Global.body
                [ backgroundColor <| paperBackground model.theme
                , onlyBigScreen
                    [ backgroundColor <| mainBackground model.theme
                    ]
                ]
            , Global.class "tooltip"
                [ position relative
                ]
            , Global.selector ".tooltip:hover .tooltip-text"
                [ visibility visible
                ]
            , Global.class "tooltip-text"
                [ visibility hidden
                , backgroundColor grey.c900
                , color grey.c50
                , textAlign center
                , borderRadius (px 6)
                , padding2 (rem 0.32) (rem 1)
                , position absolute
                , top (pct 150)
                , left (pct 50)
                , transform <| translateX (pct -50)
                , minWidth (rem 10)
                ]
            , Global.selector ".tooltip-text::after"
                [ property "content" "\"\""
                , position absolute
                , bottom (pct 100)
                , left (pct 50)
                , marginLeft (rem -0.32)
                , borderWidth (rem 0.32)
                , borderStyle solid
                , borderColor4 transparent transparent grey.c900 transparent
                ]
            ]

        -- Options bar
        , div
            [ Attributes.id "options-bar"
            , Attributes.css
                [ height optionsBarHeight
                , width (pct 100)
                , position fixed
                , zIndex (int 100)
                , top (px 0)
                , backgroundColor almostBlack
                , hiddenOnPrint
                , property "transition" "all .3s ease"
                , centeredContent
                , color <| paragraphColor Dark
                , displayGrid
                , property "grid-template-columns" "repeat(3, auto)"
                , property "grid-gap" "1.5rem"
                , justifyContent center
                ]
            ]
            -- Radio buttons
            [ div
                []
                [ input
                    [ Attributes.type_ "radio"
                    , Attributes.id "en"
                    , Attributes.checked (model.language == English)
                    , onCheck (always (ChangeLanguage English))
                    ]
                    []
                , label [ Attributes.for "en" ]
                    [ text "English"
                    ]
                , input
                    [ Attributes.type_ "radio"
                    , Attributes.id "es"
                    , Attributes.css [ marginLeft (rem 0.8) ]
                    , Attributes.checked (model.language == Spanish)
                    , onCheck (always (ChangeLanguage Spanish))
                    ]
                    []
                , label
                    [ Attributes.for "es"
                    ]
                    [ text "Español"
                    ]
                ]
            , ghostRoundButton
                [ onClick ChangeTheme
                , Attributes.css
                    [ position relative
                    , left (rem 0.25)
                    ]
                ]
                [ switchThemeIcon 20 model.theme ]
            , ghostRoundButton
                [ onClick Print
                , Attributes.class "tooltip"
                ]
                [ Svg.Styled.fromUnstyled <| Filled.print 20 Inherit
                , span
                    [ Attributes.class "tooltip-text"
                    ]
                    [ text <|
                        Language.translated
                            "Funciona mejor en Google Chrome para escritorio"
                            "Works better in Google Chrome for desktop"
                            model.language
                    ]
                ]
            ]

        -- Paper
        , div
            [ Attributes.css
                [ maxWidth paperWidth
                , width (pct 100)
                , padding2 paperPadding.vertical paperPadding.horizontal
                , backgroundColor <| paperBackground model.theme
                , displayGrid
                , property "grid-template-columns" "3fr 5fr"
                , property "column-gap" "2rem"
                , property "align-content" "start"
                , onlyPrint
                    [ themed
                        (batch [])
                        (backgroundColor (hex "fff"))
                        model.theme
                    , height paperHeight
                    ]
                , onlyBigScreen
                    [ margin2 (rem 2) (px 0)
                    , paperShadow model.theme
                    , borderRadius (px 10)
                    ]
                , belowBigScreen
                    [ boxSizing borderBox
                    , maxWidth (rem paperWidthInt)
                    , after
                        [ property "content" "\"\""
                        , width (pct 100)
                        , height (px 1)
                        , position relative
                        , top paperPadding.vertical
                        , backgroundColor (themed grey.c50 grey.c500 model.theme)
                        ]
                    ]
                , onlyMediumScreen
                    [ after [ property "grid-column-end" "span 2" ]
                    ]
                , onlySmallScreen
                    [ property "grid-template-columns" "1fr"
                    ]
                ]
            ]
            -- Column 1
            [ div
                []
                [ roundImg profilePictureSize
                    [ Attributes.src model.profilePicture
                    , Attributes.alt
                        (Language.translated
                            "Foto de César con lentes"
                            "Photo of César with glasses"
                            model.language
                        )
                    ]
                , title model.theme
                    []
                    [ text name ]
                , spaced_p [ textAlign justify ]
                    []
                    [ text
                        (Language.translated
                            "Soy un estudiante de ingeniería de software con 2 años de experiencia trabajando como desarrollador frontend. Estoy comprometido con la calidad del software en todas sus etapas, desde la planeación hasta la entrega del producto. A menudo intento hacer mi código lo más simple posible y disfruto aprender cosas nuevas. Actualmente la programación funcional me llama la atención."
                            "I'm a software engineering student with two years of experience working as a frontend developer. I am committed to software quality in all their stages, from the planning to the delivery and maintenance. I often try to make my code the simplest possible and I enjoy learning new stuff. Currently I'm really interested in functional programming."
                            model.language
                        )
                    ]
                , subtitle model.theme
                    []
                    []
                    [ text
                        (Language.translated
                            "Me puedes encontrar en"
                            "You can find me on"
                            model.language
                        )
                    ]
                , coloredBlock model.theme
                    []
                    [ ul
                        [ Attributes.css
                            [ listStyle none
                            , paddingLeft (px 0)
                            , margin (px 0)
                            ]
                        ]
                        (List.map displayContact <| contactList 16)
                    ]
                , qrCode model.qrUrl
                , a
                    [ Attributes.href model.qrUrl
                    , Attributes.css
                        [ display block
                        , margin auto
                        , textAlign center
                        , color grey.c500
                        , textDecoration none
                        , fontStyle italic
                        , fontSize (rem 0.8)
                        , withMedia [ Media.not print [] ]
                            [ display none
                            ]
                        ]
                    ]
                    [ text
                        (Language.translated
                            ("Este documento es una página web impresa " ++ model.qrUrl)
                            ("This document is a printed web page " ++ model.qrUrl)
                            model.language
                        )
                    ]
                ]

            -- Column 2
            , div []
                ([ subtitle model.theme
                    [ aboveSmallScreen [ marginTop (px 0) ]
                    , onlyPrint [ marginTop (px 0) ]
                    ]
                    []
                    [ text
                        (Language.translated
                            "Habilidades técnicas"
                            "Hard skills"
                            model.language
                        )
                    ]
                 , coloredBlock model.theme
                    [ displayGrid
                    , property "grid-template-columns" "auto 1fr"
                    , property "column-gap" "1rem"
                    , property "row-gap" "1rem"
                    ]
                    [ skillSubtitle [] [ text (translated "Competente" "Proficient" model.language) ]
                    , span [] [ text (Language.toSentence model.language proficientSkills) ]
                    , skillSubtitle [] [ text (always "Familiar" model.language) ]
                    , span [] [ text (Language.toSentence model.language familiarSkills) ]
                    , skillSubtitle [] [ text (translated "Aprendiendo" "Learning" model.language) ]
                    , span [] [ text (Language.toSentence model.language learningSkills) ]
                    ]
                 , subtitle model.theme
                    []
                    []
                    [ text
                        (Language.translated
                            "Experiencia laboral"
                            "Work experience"
                            model.language
                        )
                    ]
                 ]
                    ++ List.map (displayExperience model.language) jobs
                    ++ subtitle model.theme
                        []
                        []
                        [ text (Language.translated "Estudios" "Studies" model.language)
                        ]
                    :: List.map (displayExperience model.language) studies
                )
            ]

        -- Footnote
        , div
            [ Attributes.css
                [ padding2 (rem 5) (px 0)
                , boxSizing borderBox
                , width (pct 100)
                , displayGrid
                , property "grid-template-columns" "auto auto"
                , property "grid-gap" "2rem"
                , property "justify-content" "center"
                , onlyPrint
                    [ display none
                    ]
                ]
            ]
            [ span [] [ text "© 2021 César González" ]
            , a
                [ Attributes.href "https://github.com/Chesare22/chesare22.github.io"
                , Attributes.target "_blank"
                , Attributes.css
                    [ color currentColor
                    , textDecoration none
                    , hover [ textDecoration underline ]
                    ]
                ]
                [ text
                    (Language.translated
                        "Código fuente"
                        "Site source"
                        model.language
                    )
                ]
            ]
        ]


displayExperience : Language -> Experience -> Html msg
displayExperience lang experience =
    div
        [ Attributes.css
            [ marginBottom (rem 1.5)
            ]
        ]
        [ h3
            [ Attributes.css
                [ display inline
                , fontSize (Css.em 1.17)
                , fontWeight (int 700)
                ]
            ]
            [ text (experience.title lang) ]
        , span [] [ text (", " ++ experience.position lang) ]
        , span
            [ Attributes.css
                [ display block
                , margin2 (rem 0.4) (px 0)
                , letterSpacing (Css.em 0.075)
                , fontSize (Css.em 0.8)
                ]
            ]
            [ text (formatDateRange lang experience.start experience.end) ]
        , spaced_p [] [] [ text (experience.description lang) ]
        ]


formatDateRange : Language -> SimpleDate -> Maybe SimpleDate -> String
formatDateRange language start end =
    String.toUpper
        (formatDate language start
            ++ " — "
            ++ (case end of
                    Just date ->
                        formatDate language date

                    Nothing ->
                        Language.translated "actual" "present" language
               )
        )


formatDate : Language -> SimpleDate -> String
formatDate language date =
    translateMonth language date.month
        ++ " "
        ++ String.fromInt date.year


translateMonth : Language -> Time.Month -> String
translateMonth =
    Language.translated monthsEs monthsEn


monthsEn : Time.Month -> String
monthsEn month =
    case month of
        Time.Jan ->
            "january"

        Time.Feb ->
            "february"

        Time.Mar ->
            "march"

        Time.Apr ->
            "april"

        Time.May ->
            "may"

        Time.Jun ->
            "june"

        Time.Jul ->
            "july"

        Time.Aug ->
            "august"

        Time.Sep ->
            "september"

        Time.Oct ->
            "october"

        Time.Nov ->
            "november"

        Time.Dec ->
            "december"


monthsEs : Time.Month -> String
monthsEs month =
    case month of
        Time.Jan ->
            "enero"

        Time.Feb ->
            "febrero"

        Time.Mar ->
            "marzo"

        Time.Apr ->
            "abril"

        Time.May ->
            "mayo"

        Time.Jun ->
            "junio"

        Time.Jul ->
            "julio"

        Time.Aug ->
            "agosto"

        Time.Sep ->
            "septiembre"

        Time.Oct ->
            "octubre"

        Time.Nov ->
            "noviembre"

        Time.Dec ->
            "diciembre"


skillSubtitle =
    styled span
        [ fontSize (rem 1.125)
        ]


qrCode : String -> Html msg
qrCode url =
    a
        [ Attributes.href url
        , Attributes.css
            [ width (rem 5)
            , margin auto
            , marginBottom (rem 0.5)
            , displayGrid
            , border3 (rem 0.3) solid grey.c900
            , borderRadius (rem 0.5)
            , textDecoration none
            , color currentColor
            , backgroundColor (hex "fff")
            , color grey.c900
            , withMedia [ Media.not print [] ]
                [ display none
                ]
            ]
        ]
        [ fromUnstyled
            (QRCode.fromString url
                |> Result.map
                    (QRCode.toSvg
                        [ Svg.Attributes.stroke "currentColor"
                        ]
                    )
                |> Result.withDefault (Html.text "")
            )
        , styled div
            [ color grey.c50
            , backgroundColor grey.c900
            , textAlign center
            , paddingTop (rem 0.3)
            , fontSize (rem 0.8)
            , property "box-shadow"
                ("2px 0 0 0 "
                    ++ grey.c900.value
                    ++ ", -2px 0 0 0 "
                    ++ grey.c900.value
                )
            ]
            []
            [ text "Click or Scan" ]
        ]



-- ATOMS


ghostRoundButton : List (Attribute msg) -> List (Html msg) -> Html msg
ghostRoundButton =
    styled button
        [ roundBorder
        , padding (rem 0.5)
        , backgroundColor transparent
        , color inherit
        , cursor pointer
        , border (px 0)
        , property "transition" "background-color .25s ease"
        , hover
            [ backgroundColor grey.c800
            ]
        , active
            [ backgroundColor grey.c700
            ]
        ]


roundImg : LengthOrAuto compatible -> List (Attribute msg) -> Html msg
roundImg size attributes =
    div
        [ Attributes.css
            [ width size
            , height size
            , roundBorder
            , overflow hidden
            , margin auto
            ]
        ]
        [ styled img
            [ width (pct 100)
            , height (pct 100)
            ]
            attributes
            []
        ]


spaced_p : List Style -> List (Attribute msg) -> List (Html msg) -> Html msg
spaced_p styles =
    styled p
        ([ lineHeight (Css.em 1.5)
         , marginBottom (Css.em 1)
         , marginTop (px 0)
         , onlyPrint
            [ lineHeight (Css.em 1.35)
            ]
         ]
            ++ styles
        )



-- THEMED ELEMENTS


title : Theme -> List (Attribute msg) -> List (Html msg) -> Html msg
title theme =
    styled h1
        [ color (titleColor theme)
        , fontSize (Css.em 2)
        , onlySmallScreen
            [ textAlign center
            ]
        ]


subtitle : Theme -> List Style -> List (Attribute msg) -> List (Html msg) -> Html msg
subtitle theme styles =
    styled h2
        ([ color (titleColor theme)
         , fontSize (rem 1.4)
         , fontWeight (int 700)
         , marginBottom (Css.em 0.5)
         , marginTop (Css.em 0.85)
         ]
            ++ styles
        )


switchThemeIcon : Int -> Theme -> Svg.Styled.Svg msg
switchThemeIcon size =
    themed
        (Svg.Styled.fromUnstyled (Filled.dark_mode size Inherit))
        (Svg.Styled.fromUnstyled (Filled.light_mode size Inherit))


coloredBlock : Theme -> List Style -> List (Html msg) -> Html msg
coloredBlock theme styles =
    styled div
        ([ borderRadius (px 4)
         , backgroundColor <|
            themed
                (changeOpacity primary.c400 0.1)
                primary.c50
                theme
         , marginBottom (rem 1)
         , padding (rem 0.75)
         , paddingRight (rem 1)
         , borderLeft3
            (px 4)
            solid
            (themed primary.c400 primary.c600 theme)
         ]
            ++ styles
        )
        []



-- VIEW OF CUSTOM DATA


displayContact : ContactInfo Msg -> Html Msg
displayContact contact =
    li []
        [ a
            [ Attributes.href contact.href
            , Attributes.target "_blank"
            , Attributes.css
                [ color inherit
                , textDecoration none
                , lineHeight (rem 1.365)
                ]
            ]
            [ span
                [ Attributes.css
                    [ paddingRight (rem 0.4)
                    , position relative
                    , top (rem 0.12)
                    ]
                ]
                [ contact.icon ]
            , span [] [ text contact.text ]
            ]
        ]



-- CUSTOM DATA


name : String
name =
    "César Alejandro González Ortega"


email : String
email =
    "chesarglez429@gmail.com"


phone : Phone.InternationalPhone
phone =
    Phone.InternationalPhone
        52
        1
        9993912495


type alias ContactInfo msg =
    { href : String
    , text : String
    , icon : Svg.Styled.Svg msg
    }


contactList : Int -> List (ContactInfo Msg)
contactList iconSize =
    [ { href = "mailto:" ++ email
      , text = email
      , icon = Svg.Styled.fromUnstyled <| Filled.email iconSize Inherit
      }
    , { href = Phone.toWhatsAppUrl phone
      , text = Phone.toString phone
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.smartphone
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    , { href = "https://github.com/Chesare22"
      , text = "/Chesare22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.github
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    , { href = "https://gitlab.com/Chesare22"
      , text = "/Chesare22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.gitlab
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    , { href = "https://www.linkedin.com/in/cgonzalez22/"
      , text = "/cgonzalez22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.linkedin
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    ]


proficientSkills : List (Language -> String)
proficientSkills =
    [ always "JavaScript"
    , always "HTML"
    , always "(S)CSS"
    ]


familiarSkills : List (Language -> String)
familiarSkills =
    [ always "Elm"
    , always "C#"
    , translated "Programación funcional" "Functional programming"
    , always "Git"
    , always "React JS"
    , always "Vue"
    , always "Figma"
    , always "SQL"
    ]


learningSkills : List (Language -> String)
learningSkills =
    [ always "Elixir"
    , always "Event sourcing"
    , always "CQRS"
    , translated "Microservicios" "Microservices"
    , translated "Diseño guiado por el dominio" "Domain-driven design"
    , always "MongoDB"
    ]


type alias Experience =
    { title : Language.Language -> String
    , start : SimpleDate
    , end : Maybe SimpleDate
    , position : Language.Language -> String
    , description : Language.Language -> String
    }


type alias SimpleDate =
    { month : Time.Month
    , year : Int
    }


jobs : List Experience
jobs =
    [ Experience (always "SoldAI")
        (SimpleDate Time.Jul 2019)
        (Just <| SimpleDate Time.Sep 2020)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            "SoldAI es una empresa yucateca dedicada a la inteligencia artificial. Ayudé en pruebas, desarrollo, mantenimiento y documentación de varios proyectos."
            "SoldAI is a yucatecan company dedicated to the artificial intelligence. I helped in testing, developing, maintenance and documentation of various projects."
        )
    , Experience (always "Sumerian")
        (SimpleDate Time.Jun 2020)
        (Just <| SimpleDate Time.Jul 2021)
        (Language.translated "Ingeniero de Software" "Software Engineer")
        (Language.translated
            "Sumerian hace aplicaciones web. En cada proyecto experimentábamos con nuevas herramientas y metodologías."
            "Sumerian makes custom web applications. On every project we experimented with new tools and methodologies."
        )
    , Experience (always "Coatí Labs")
        (SimpleDate Time.Jan 2021)
        (Just <| SimpleDate Time.Apr 2021)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            "Empresa de programación web donde me familiaricé con algunos eventos de scrum. Mi labor principal era el desarrollo de páginas web con React y TypeScript."
            "A web-programming company where I got familiarized with some scrum events. My primary labour was to develop web pages with React and TypeScript."
        )
    ]


studies : List Experience
studies =
    [ Experience (Language.translated "Licenciatura en Ingeniería de Software" "Bachelor of Software Engineering")
        (SimpleDate Time.Aug 2017)
        Nothing
        (always "UADY")
        (Language.translated
            "Carrera que enseña cómo aplicar ingeniería en la producción de software. También  conlleva aprender programación, pruebas, requisitos y otras habilidades."
            "Career that teaches how to apply engineering to the production of software. It also involves learning programming, testing, requirements and other abilities."
        )
    , Experience (Language.translated "Cursos sobre Arquitectura Reactiva" "Courses about Reactive Architecture")
        (SimpleDate Time.May 2021)
        (Just <| SimpleDate Time.Jul 2021)
        (always "Lightbend Academy")
        (Language.translated
            "Tomé seis cursos en línea donde aprendí lo básico sobre sistemas reactivos, microservicios, DDD, mensajes distribuidos y event sourcing."
            "I took six free online courses where I learned the basics of reactive systems, microservices, DDD, distributed messaging and event sourcing."
        )
    ]



-- STYLES


hiddenOnPrint : Style
hiddenOnPrint =
    onlyPrint [ display none ]


centeredContent : Style
centeredContent =
    batch
        [ displayGrid
        , property "place-items" "center"
        ]


displayGrid : Style
displayGrid =
    property "display" "grid"


roundBorder : Style
roundBorder =
    borderRadius (pct 50)


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



-- THEMED STYLES


mainBackground : Theme -> Color
mainBackground =
    themed
        (paperBackground Dark)
        grey.c200


paperBackground : Theme -> Color
paperBackground =
    themed
        secondary.c900
        grey.c50


paragraphColor : Theme -> Color
paragraphColor =
    themed
        grey.c50
        grey.c900


titleColor : Theme -> Color
titleColor =
    themed
        primary.c300
        primary.c600


paperShadow : Theme -> Style
paperShadow =
    themed
        (border3 (px 1) solid grey.c50)
        (batch
            [ smoothGrayShadow
            , border3 (px 1) solid transparent
            ]
        )



-- MEDIA QUERIES


onlyScreen : List Style -> Style
onlyScreen =
    withMedia [ only screen [] ]


onlySmallScreen : List Style -> Style
onlySmallScreen =
    withMedia [ only screen [ Media.maxWidth smallScreen ] ]


aboveSmallScreen : List Style -> Style
aboveSmallScreen =
    withMedia [ only screen [ Media.minWidth smallScreen ] ]


onlyMediumScreen : List Style -> Style
onlyMediumScreen =
    withMedia
        [ only screen
            [ Media.minWidth smallScreen
            , Media.maxWidth mediumScreen
            ]
        ]


onlyBigScreen : List Style -> Style
onlyBigScreen =
    withMedia [ only screen [ Media.minWidth mediumScreen ] ]


belowBigScreen : List Style -> Style
belowBigScreen =
    withMedia
        [ only screen
            [ Media.maxWidth <|
                Css.em (mediumScreen.numericValue - 1 / 16)
            ]
        ]


onlyPrint : List Style -> Style
onlyPrint =
    withMedia [ only print [] ]



-- COLORS


type alias Palette =
    { c50 : Color
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


changeOpacity : Color -> Float -> Color
changeOpacity { red, green, blue } opacity =
    rgba red green blue opacity



-- DIMENSIONS


paperWidthInt : number
paperWidthInt =
    51


paperHeightInt : number
paperHeightInt =
    66


paperPaddingInt : { vertical : Float, horizontal : Float }
paperPaddingInt =
    { vertical = 3
    , horizontal = 2.5
    }


optionsBarHeightInt : number
optionsBarHeightInt =
    4


paperWidth : Rem
paperWidth =
    rem (paperWidthInt - 2 * paperPaddingInt.horizontal)


paperHeight : Rem
paperHeight =
    rem (paperHeightInt - 2 * paperPaddingInt.vertical)


paperPadding : { vertical : Rem, horizontal : Rem }
paperPadding =
    { vertical = rem paperPaddingInt.vertical
    , horizontal = rem paperPaddingInt.horizontal
    }


optionsBarHeight : Rem
optionsBarHeight =
    rem optionsBarHeightInt


profilePictureSize : Rem
profilePictureSize =
    rem 15



-- BREAKPOINTS


smallScreen : Em
smallScreen =
    Css.em 44


mediumScreen : Em
mediumScreen =
    Css.em 56
