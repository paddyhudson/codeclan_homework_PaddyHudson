library (tidyverse)
library (shiny)
library (CodeClanData)
library (shinythemes)
library (shinydashboard)

if (interactive()) {

sidebar <- dashboardSidebar(
    sidebarUserPanel("User Name : Prathiba"),
    sidebarMenu(
        id = "tabs",
        menuItem("Charts", icon = icon("bar-chart-o"), tabName = "widgets" ),
        menuItem("Input Options",
                 menuSubItem("Seasons", tabName = "subitem1"),
                 menuSubItem("Medals", tabName = "subitem2")
        )
    )
)


body<- dashboardBody(
    tabItems(
        tabItem("widgets",
                fluidPage(
                    tags$head(
                        tags$style(HTML(" @import url('https://fonts.googleapis.com/css2?family=Acme&family=Caveat&family=Style+Script&display=swap');
                                          body {
                                          }
                                          h1 {
                                            font-family: 'Style Script', cursive;
                                            color:blue;
                                          }
                                          h2 {
                                            font-family: 'Acme', cursive;
                                            color:white;
                                          }
                                          h3 {
                                            font-family: 'Acme', cursive;
                                            color:Tomato;
                                          }
                                          .shiny-input-container {
                                            color: #474747;
                                          }
                                        .main-header .logo {
                                                            font-family: 'Georgia', Times, 'Times New Roman', serif;
                                                            font-weight: bold;
                                                            font-size: 24px;
                                                          }
                                        "
                                        )
                                    )
                            ),
                    
                    titlePanel(tags$h1("Olympic Medal Comparison")),
                    
                    mainPanel(tabsetPanel(type = "tabs",
                                tabPanel("Plot", 
                                         # Fluid Row 1
                                         fluidRow( align = "center",
                                             box(
                                                 title = tags$h2("Representation of Medals across 5 countries"),
                                                 width = 8, status = "primary",
                                                 plotOutput("medal_plot1"),
                                                 solidHeader = TRUE
                                                ),
                                             box(
                                                 status = "success",
                                                 width = 4,
                                                 tags$h3("Data"),
                                                 style='border: 2px solid gray',
                                                 offset = 1,
                                                 tableOutput("table" )
                                             )
                                         ),
                                         
                                         # Fluid Row 2
                                         fluidRow(style = "padding-top:3%",
                                            column(style='border: 1px solid gray',
                                                        width = 3,
                                                        offset =1,
                                                        radioButtons("season_input",
                                                                     tags$i("Choose the Season"),
                                                                     choices = c("Summer", "Winter")
                                                        )
                                                 ),
                                            
                                            column(style='border: 1px solid gray',
                                                        width = 3,
                                                        offset = 1,
                                                        radioButtons("medal_input", 
                                                                     tags$i("Choose the Medal"), 
                                                                     choices = c("Gold", "Silver","Bronze")
                                                        )
                                                 ),
                                             ),
                                         
                                         
                                         
                                    ),
                                # tab Panel 2
                                
                                tabPanel("Summary",  
                                             tags$br(),
                                             tags$br(),
                                             "The plot is displayed for ", tags$b(textOutput("text", inline = TRUE)),
                                             " Medals of ", tags$b(textOutput("text1", inline = TRUE))," Season "),
                                # tab Panel 3
                                
                                tabPanel("About", "This is about Olympics.",
                                         "For more details,",tags$br()," Please refer to",
                                         tags$a("The Olympics website",
                                                href = "https://www.olympic.org/")
                                         )
                            ) # tabset Panel completed
                    ) # Main Panel ends
                ) # Fluid Page ends
        ),# Tab item Sub item1 ends
        tabItem("subitem1","There are 2 types of Seasons used in this plot.They are Summer & Winter"),
        tabItem("subitem2","There are 3 types of medals. They are Gold,Silver,Bronze")
    )# tabItems ends
)#Dashboard body ends


ui <- shinyUI(dashboardPage(skin = "yellow",
                            dashboardHeader( title = "Olympic Data" ),
                            sidebar,
                            body)
              )

server <- function(input, output) {
    
    
    output$medal_plot1 <- output$medal_plot2 <- renderPlot({

        olympics_overall_medals %>%
            filter(team %in% c("United States",
                               "Soviet Union",
                               "Germany",
                               "Italy",
                               "Great Britain")) %>%
            filter(medal == input$medal_input) %>%
            filter(season == input$season_input) %>%
            ggplot() +
            aes(x = team, y = count) +
            geom_col(aes(fill = medal), show.legend = FALSE) +
            labs (x = "\nTeams",
                  y = "Number of Medals \n") +
            scale_fill_manual( values = setNames(c('gold','darkgray', "darkorange"),
                                                 c("Gold", "Silver","Bronze")
            )
            ) +
            theme(
                axis.text = element_text(colour = "steelblue", face = "italic", size = 12 ),
                axis.title = element_text(colour = "black" , face = "bold", size = 14),
                plot.title = element_text(size = rel(2)),
                panel.border = element_rect(colour = "blue", fill = NA, linetype = 1),
                panel.background = element_rect(fill = "white"),
                panel.grid =  element_line(colour = "grey85", linetype = 1, size = 0.5),
            )
        
    })
    
    output$text <- renderText({ input$medal_input})
    output$text1 <- renderText({ input$season_input})

    output$table <- renderTable({
        
        olympics_overall_medals %>%
            filter(team %in% c("United States",
                               "Soviet Union",
                               "Germany",
                               "Italy",
                               "Great Britain")) %>%
            filter(medal == input$medal_input) %>%
            filter(season == input$season_input) 
    }
        
    )
}



shinyApp(ui = ui, server = server)

}

