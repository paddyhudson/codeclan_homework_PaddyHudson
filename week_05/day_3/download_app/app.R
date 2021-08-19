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
    
    #plot for the UI
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
    
    #download functionatility which will happen when download_report is clicked
    #first call a downloadHander
    output$download_report <- downloadHandler(
    #set the filename as my-report.(PDF/html/docx) based on the choice of format
        filename = function() {
            paste('my-report', sep = '.', switch(
                input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
            ))
        },
    #get the file content    
        content = function(file) {
    #get the filepath of the markdown file
            src <- normalizePath('report.Rmd')
    #this is a precaution to ensure you have write permission for the directory
            owd <- setwd(tempdir())
            on.exit(setwd(owd))
    #create a copy of the markdown file
            file.copy(src, 'report.Rmd', overwrite = TRUE)
    #create the search parameters to be passed to markdown file
            params <- list(medal = input$medal, season = input$season)
    #render the markdown file in the desired format
    #pass in the search parameters
    #and create a new environment for the render, in case of duplicate terms
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
    #rename the file... don't quite understand this bit yet
            file.rename(out, file)
        }
    )
    
}

shinyApp(ui = ui, server = server)