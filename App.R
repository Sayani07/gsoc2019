library(shiny)

# Define several objects and store them to disk
# x <- rnorm(100)
# y <- rnorm(200)
# z <- "some text for the title of the plot"
# 
# save(x, file = "x.RData")
# save(x, y, z, file = "xyz.RData")
# rm(x, y, z)


# Define UI
ui <- shinyUI(fluidPage(
  titlePanel(".RData File Upload Test"),
  mainPanel(
    fileInput("file", label = ""),
    actionButton(inputId="plot","Plot"),
    tableOutput("contents"),
    plotOutput("hist"))
)
)

# Define server logic
server <- shinyServer(function(input, output) {
  observeEvent(input$plot,{
    if ( is.null(input$file)) return(NULL)
    inFile <- isolate({input$file })
    file <- inFile$datapath
    load(file, envir = .GlobalEnv)
    
    # Plot the data
    output$hist <- renderPlot({
      plot(x,y[1:100],main=z)
    })
  })
})

# Run the application 
shinyApp(ui = ui, server = server)