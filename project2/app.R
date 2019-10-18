library(shiny)
source("helper_functions.R")

# ------------------------------------------------------------------------------------------------------
ui <- navbarPage("Project 2",
    tabPanel("About",
        fluidPage(
            titlePanel("About Project"),
            sidebarLayout(
                sidebarPanel(
                    "This page provides relevant and background information of the project.",
                    hr(),
                    selectInput("about_project_select", label = h5("I am interested in:"),   
                                choices = list("Data Source" = 1, "Research Question" = 2, "About Author" = 3), 
                                selected = 1)),
                mainPanel(htmlOutput("about_project_text"))
            )
        )
    ),
    
    tabPanel("DataSummary",
        fluidPage(
            titlePanel("Summary of the Data"),
            sidebarLayout(
                sidebarPanel(
                    "This page provides a summary of the dataset.",
                    hr(),
                    sliderInput("summary_year_slider", label = h5("I an interest in year:"), min = 1931, 
                                max = 2019, value = c(1931, 2019))),
                mainPanel(verbatimTextOutput("data_summary"))
            )
        )
    ),
    
    tabPanel("RQ1",
        fluidPage(
            titlePanel("General View"),
            sidebarLayout(
                sidebarPanel(
                    "This page provides a general view of our program, including the amount of assistances and clients each year.",
                    hr(),
                    selectInput("rq1_checkbox", label = h5("I an interest in:"), 
                                  choices = list("Amount of Assistances" = 1, "Amount of Clients" = 2,"Both" = 3),
                                  selected = 1),
                    hr(),
                    sliderInput("rq1_year_slider", label = h5("Please select year range:"), min = 2000, 
                                max = 2018, value = c(2000, 2018))),
                mainPanel(plotOutput("rq1_plot"))
            )
        )
    ),
    
    tabPanel("RQ2",
        fluidPage(
            titlePanel("Program Growth"),
            sidebarLayout(
                sidebarPanel(
                    "This page shows how our program grows, in terms of reaching out to new clients.",
                    hr(),
                    sliderInput("rq2_year_slider", label = h5("Please select year range:"), min = 2000, 
                                max = 2018, value = c(2000, 2018))),
                mainPanel(plotOutput("rq2_plot"))
            )
        )
    ),
    
    tabPanel("RQ3",
        fluidPage(
            titlePanel("Services in detail"),
            sidebarLayout(
                sidebarPanel(
                    "This page shows in detail how each kind of service grows.",
                    hr(),
                    selectInput("rq3_checkbox", label = h5("I an interest in:"), 
                                choices = list("Food" = 1, "Clothing" = 2,"Diapers" = 3,
                                               "School Items" = 4, "Hygiene Kits" = 5),selected = 1),
                    hr(),
                    sliderInput("rq3_year_slider", label = h5("Please select year range:"), min = 2000, 
                                max = 2018, value = c(2000, 2018)),
                    hr(),
                    selectInput("rq3_checkbox_color", label = h5("Select a color you like:"), 
                                choices = list("Red" = 1, "Blue" = 2,"Green" = 3,
                                               "Yellow" = 4, "Black" = 5),selected = 1)),
                mainPanel(plotOutput("rq3_plot"))
            )
        )
    )
)

# ------------------------------------------------------------------------------------------------------
server <- function(input, output) {
    
    # render the about info on the first page
    output$about_project_text <- renderUI(HTML(paste(generate_about_info(input$about_project_select), collapse ="<br/>")))
    
    # render the data summary on the second page
    output$data_summary <- renderPrint(generate_data_summary(input$summary_year_slider[1], input$summary_year_slider[2]))
    
    # redner the plot on the RQ1 page
    output$rq1_plot <- renderPlot(generate_rq1_plot(input$rq1_year_slider[1], input$rq1_year_slider[2], input$rq1_checkbox))
    
    # redner the plot on the RQ2 page
    output$rq2_plot <- renderPlot(generate_rq2_plot(input$rq2_year_slider[1], input$rq2_year_slider[2]))
    
    # redner the plot on the RQ3 page
    output$rq3_plot <- renderPlot(generate_rq3_plot(input$rq3_year_slider[1], input$rq3_year_slider[2], input$rq3_checkbox, input$rq3_checkbox_color))
    
}

# ------------------------------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)

