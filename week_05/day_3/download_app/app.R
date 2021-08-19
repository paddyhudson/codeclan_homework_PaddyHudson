library(shiny)
library(CodeClanData)
library(tidyverse)
library(shinythemes)
library(rmarkdown)

ui <- fluidPage(
    
    theme = shinytheme("superhero"),
    
    titlePanel("Five Country Medal Comparison"),
    
    tabsetPanel(
        tabPanel("Plot",
    
        plotOutput("plot"),
        
        fluidRow(
            
            column(6,
                   
                   radioButtons("season", "Summer or Winter Olympics?",
                                c("Summer", "Winter")),
                   
            ),
            
            column(6,
                   checkboxGroupInput(
                       "medal",
                       "Medal Type?",
                       c("Gold", "Silver", "Bronze"),
                       inline = TRUE
                   )
            )
            
        )),
        
        tabPanel("Download",
            radioButtons("format",
                         "Document format",
                         c("PDF", "HTML", "Word"),
                        inline = TRUE
            ),
            downloadButton("download_report")
        )
    )    
)

server <- function(input, output){
    
    output$plot <- renderPlot({
        olympics_overall_medals %>%
            filter(team %in% c("United States",
                               "Soviet Union",
                               "Germany",
                               "Italy",
                               "Great Britain")) %>%
            filter(medal %in% input$medal) %>%
            filter(season == input$season) %>% 
            ggplot() +
            aes(x = team, y = count, fill = medal) +
            geom_col(position = "dodge") +
            scale_fill_manual(values = c("Gold" = "gold",
                                         "Silver" = "gray70",
                                         "Bronze" = "darkorange"))
    })
    
    output$download_report <- downloadHandler(
        
        filename = function() {
            paste('my-report', sep = '.', switch(
                input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
            ))
        },
        
        content = function(file) {
            src <- normalizePath('report.Rmd')
            owd <- setwd(tempdir())
            on.exit(setwd(owd))
            file.copy(src, 'report.Rmd', overwrite = TRUE)
            params <- list(medal = input$medal, season = input$season)
            out <- render('report.Rmd',
                          output_format = switch(
                            input$format,
                            PDF = pdf_document(),
                            HTML = html_document(),
                            Word = word_document()
                          ),
                          params = params,
                          envir = new.env(parent = globalenv())
            )
            file.rename(out, file)
        }
    )
    
}

shinyApp(ui = ui, server = server)