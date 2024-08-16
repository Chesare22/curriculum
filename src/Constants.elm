module Constants exposing
    ( Book
    , ContactInfo
    , Job
    , Project
    , SimpleDate
    , SmallProject
    , Study
    , books
    , contactList
    , education
    , email
    , familiarSkills
    , jobs
    , name
    , proficientSkills
    , projects
    , smallProjects
    , tabTitle
    )

import FeatherIcons
import Language exposing (..)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..), Icon)
import Svg.Styled
import Time


tabTitle : Language -> String
tabTitle =
    translated "Currículum de César González" "César González's resume"


name : String
name =
    "César González"


email : String
email =
    "ces.gonzalezortega@gmail.com"


type alias ContactInfo msg =
    { href : String
    , text : String
    , icon : Svg.Styled.Svg msg
    }


contactList : Int -> List (ContactInfo msg)
contactList iconSize =
    [ { href = "mailto:" ++ email
      , text = email
      , icon = Svg.Styled.fromUnstyled <| Filled.email iconSize Inherit
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


type alias Job =
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


jobs : List Job
jobs =
    [ Job (always "MID Software")
        (SimpleDate Time.Mar 2022)
        (Just <| SimpleDate Time.Aug 2023)
        (Language.translated "Desarrollador Web Full-Stack" "Full-Stack Web Developer")
        (Language.translated
            """
            Empresa enfocada en la facilitación de tareas administrativas en la industria médica y de construcción.
            Mis principales actividades incluyeron programar una aplicación web hecha en React y Django,
            donde pude implementar varios patrones de diseño funcionales que facilitaron la modificación del código fuente.
            También lideré el desarrollo de una aplicación WPF, donde creé una librería para manejar fácilmente datos almacenados en CTEs recursivos.
            """
            """
            Enterprise focused on the development of tools to help complex administrative work.
            My main duties included programming a web application made with React and Django,
            where I could implement various functional design patterns that facilitated the modification of our source code.
            I also led the development of a WPF application, where I created a library to easily manage data stored in recursive CTEs.
            """
        )
    , Job (always "Sumerian")
        (SimpleDate Time.Jun 2020)
        (Just <| SimpleDate Time.Jul 2021)
        (Language.translated "Ingeniero de Software" "Software Engineer")
        (Language.translated
            """
            Una startup formada por mí y un equipo de compañeros capaces.
            Nuestros principales proyectos fueron un exitoso blog de música y una pequeña aplicación para la administración de facturas.
            Mis tareas incluyeron la participación en reuniones con clientes dirigidas a entender requisitos y proponer soluciones, la programación en Vue y React,
            definir un estándar de programación y participar en la investigación y toma de decisiones sobre tecnologías a emplear.
            Fue donde más aprendí sobre ingeniería de software, trato con clientes y organización de proyectos.
            """
            """
            Startup formed by me and a team of capable schoolfellows.
            Our main projects were a successful music blog and a small application to manage invoices.
            My tasks included programming in Vue and React, taking part in meetings with clients aimed at understanding their requirements and proposing solutions,
            define a programming standard and participate in the research and decision-making around our tech stack.
            Here I learned the most about software engineering, project management and how to have agreements with clients.
            """
        )
    , Job (always "Coatí Labs")
        (SimpleDate Time.Jan 2021)
        (Just <| SimpleDate Time.Apr 2021)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            """
            En Coatí se desarrollan aplicaciones web a la medida, como sistemas de CRM y comercios electrónicos.
            Estuve involucrado en varios proyectos donde mis contribuciones incluían programar en React y participar en tomas de decisiones arquitectónicas.
            """
            """
            Coatí Labs develops custom web applications, like CRM systems and e-commerces.
            I was involved in several projects where my main contributions included programming in React and take part in architectural decision making.
            """
        )
    , Job (always "SoldAI")
        (SimpleDate Time.Jul 2019)
        (Just <| SimpleDate Time.Sep 2020)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            """
            Empresa dedicada al desarrollo de inteligencia artificial para la creación de chatbots.
            Mi principal labor fue la programación en Vue de una aplicación web que permitía personalizar y desplegar chatbots en distintas plataformas.
            A pesar de que ya había programado en entornos académicos, aquí aprendí a profundidad sobre el desarrollo web,
            la personalización de mi entorno de trabajo, el uso de git, pruebas y otras habilidades básicas como programador.
            """
            """
            Company dedicated to the development of artificial intelligence to create chatbots.
            My main labour was to program a Vue application to personalize and deploy chatbots in multiple platforms.
            Although I have programmed in academic environments, here I learned in depth about web development,
            the personalization of my work environment, git, testing and other basic programming skills.
            """
        )
    ]


type alias Project =
    { title : Language.Language -> String
    , url : String
    , year : Int
    , description : Language.Language -> String
    }


projects : List Project
projects =
    [ Project (always "MiObra Export App")
        "https://apps.microsoft.com/detail/XPFF9W7DQL962Z"
        2022
        (Language.translated
            """
            Aplicación WPF para migrar proyectos hechos en una aplicación de terceros a MiObra.
            Es casi completamente de mi autoría, demorándome alrededor de tres meses para completar.
            Entre las herramientas que creé para este proyecto se incluyen encriptación híbrida
            y una librería declarativa para consultar datos almacenados en CTEs recursivas.
            """
            """
            WPF application to migrate projects made with a third party app to MiObra.
            I was tasked to develop almost the entire application, it took me around three months to complete.
            The tools I developed for that project include hybrid encryption and a declarative library to query recursive CTEs.
            """
        )
    , Project (always "MiObra")
        "https://www.miobra.mx/"
        2022
        (Language.translated
            """
            Aplicación para facilitar la administración a nivel empresarial de obras de construcción.
            Fui desarrollador para la versión web y el backend, usando un stack de React y Django.
            Participé en reuniones con clientes, la toma de decisiones técnicas y muchos de mis aportes facilitaban la mantenibilidad de la aplicación.
            """
            """
            App to facilitate the business-level management of constructions.
            I was a developer for the web version and the backend, with a stack of React and Django.
            I took part in meetings with clients, technical decision-making and a lot of my contributions helped with the maintainability of the app.
            """
        )
    , Project (Language.translated "Este currículum" "This resume")
        "https://chesare22.github.io/"
        2021
        (Language.translated
            """
            Página web que desarrollé usando Elm. Tiene modos oscuro y luminoso, selección de idioma, diseño responsivo y puede imprimirse.
            El uso de un lenguaje de programación funcional me ayudó a entender a fondo dicho paradigma, marcando un antes y después en mi forma de programar.
            """
            """
            Web page that I developed using Elm. It has dark and light mode, language selection, responsive design and can be printed.
            Using a functional programming language helped me to deeply understand said paradigm, marking a turning point in my programming style.
            """
        )
    , Project (always "Comportia")
        "https://medium.com/soldai/comportia-una-idea-hecha-realidad-6bd77e542882"
        2019
        (Language.translated
            """
            Aplicación web que permitía la creación y el despliegue de chatbots impulsados por inteligencia artificial.
            Fue mi primer proyecto en un equipo de profesionales. Aporté en el diseño, la creación y mantenimiento de una variedad de
            componentes en Vue cuyo propósito era guiar al usuario de forma efectiva para que pueda fácilmente administrar sus chatbots.
            """
            """
            Web application that allowed to create and publish chatbots powered by artificial intelligence.
            It was my first project in a professional team. I contributed in the design, creation and maintaining a variety of
            Vue components to effectively guide the user to easily administrate their chatbots.
            """
        )
    , Project (Language.translated "Temporizador-PIC18F4550" "Timer-PIC18F4550")
        "https://github.com/Chesare22/Temporizador-PIC18F4550"
        2018
        (Language.translated
            """
            Proyecto escolar donde logré liderar a un grupo de veinte personas para desarrollar un temporizador en lenguaje ensamblador.
            Propuse y codifiqué una máquina de estados para el funcionamiento general del proyecto. También coordiné a varios compañeros
            que colaboraron con el cableado, la comunicación con la pantalla, la implementación de algunas funciones, etc.
            """
            """
            School project in which I lead a team of twenty people to develop a timer using assembly language.
            I coded a state machine for the general operation of the  project and coordinated several classmates who
            helped with the wiring, the communication with the screen, the implementation of some functions, etc.
            """
        )
    ]


type alias Study =
    { title : Language -> String
    , institution : String
    , start : SimpleDate
    , end : SimpleDate
    }


education : List Study
education =
    [ Study (Language.translated "Licenciatura en Ingeniería de Software (No concluida)" "Bachelor of Software Engineering (Partial completion)")
        "UADY"
        (SimpleDate Time.Aug 2017)
        (SimpleDate Time.Dec 2023)
    , Study (Language.translated "Cursos de arquitectura reactiva" "Reactive architecture courses")
        "Lightbend Academy"
        (SimpleDate Time.May 2021)
        (SimpleDate Time.Jul 2021)
    ]


proficientSkills : List (Language -> String)
proficientSkills =
    [ always "JavaScript"
    , always "ReactJS"
    , always "Elm"
    , Language.translated "Programación Funcional" "Functional Programming"
    , always "git"
    , always "CSS"
    ]


familiarSkills : List (Language -> String)
familiarSkills =
    [ always "Elixir"
    , always "Python"
    , always "TypeScript"
    , always ".NET"
    , always "SQL"
    , always "MongoDB"
    , Language.translated "Microservicios" "Microservices"
    , always "Event Sourcing"
    , always "CQRS"
    ]


type alias SmallProject =
    { name : Language -> String
    , url : String
    }


smallProjects : List SmallProject
smallProjects =
    [ SmallProject (always "Mask") "https://github.com/Chesare22/mask"
    , SmallProject (Language.translated "Buscaminas" "Minesweeper") "https://github.com/Chesare22/Buscaminas-DIY"
    , SmallProject (always "Shuffle Textlines.js") "https://github.com/Chesare22/shuffle-textlines.js"
    , SmallProject (always "@sumerian/eslint-config") "https://www.npmjs.com/package/@sumerian/eslint-config"
    , SmallProject (Language.translated "Aplicación de Fireship en Elm" "Fireship App in Elm") "https://github.com/Chesare22/Fireship-app-in-elm"
    , SmallProject (always "Dark Impala") "https://darkimpala.com/"
    , SmallProject (always "Blob Escape") "https://itch.io/jam/gmtk-2021/rate/1086701"
    , SmallProject (always "3 features de JavaScript que aprendí fuera de la escuela")
        "https://medium.com/soldai/3-features-de-javascript-que-aprend%C3%AD-fuera-de-la-escuela-978e009c9201"
    , SmallProject (always "Petite Resort") "https://www.petiteresort.mx/"
    , SmallProject (Language.translated "Programa de votos usando MVC" "Votes system using MVC")
        "https://github.com/Chesare22/Semestre-5/tree/arquitectura/Votes/src/main/java"
    ]


type alias Book =
    { title : String
    , author : String
    , description : Language -> String
    }


books : List Book
books =
    [ Book "Domain Modeling Made Functional"
        "Scott Wlaschin"
        (Language.translated
            "Esencial para cualquier ingeniero de software interesado en la programación funcional. Enseña cómo sacar el máximo provecho al sistema de tipos algebraicos como herramienta de \"documentación ejecutable\", describiendo de forma fiel y actualizada las características, relaciones y restricciones de cada entidad."
            "Essential for any software engineer interested in functional programming. It teaches how to get the most out of the algebraic type system as \"executable documentation\", describing in an accurate and up-to-date manner the characteristics, relationships and restrictions of each entity."
        )
    , Book "You Don't Know JS (book series)"
        "Kyle Simpson"
        (Language.translated
            "Marcó un antes y un después en mi carrera como programador, pues fue la primera vez que entendí a fondo un lenguaje. Me permitió programar con confianza, lo cual tuvo un impacto positivo en mi velocidad al programar y en la calidad de mi código. La principal lección que me dejó fue la importancia de entender bien una tecnología antes de usarla."
            "It marked a turning point in my career as a programmer because it was the first time I deeply understood a language. It allowed me to program with confidence, which had a positive impact on my speed and the quality of my code. The main lesson I learned from this book series is the importance of understanding any technology well before using it."
        )
    ]
