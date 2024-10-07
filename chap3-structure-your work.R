library(shiny)
ui <- function(){
  fluidPage(
    # first slider input
    sliderInput(
      inputId = "choice1",
      label = "choice 1",
      min = 1, max = 10, value = 5
    ),
    # define first action button
    actionButton(
      inputId = "validate1",
      label = "Validate choice 1"
    ),
    # define second slider input
    sliderInput(
      inputId = "choice2",
      label = "choice 2",
      min = 1, max = 10, value = 5
    ),
    # define second action button
    actionButton(
      inputId = "validate2",
      label = "validate choice 2"
    )
  )
}

server <- function(input, output, session){
  # observe first series of inputs
  observeEvent(input$validate1, {
    print(input$choice1)
  })
  # same as the first observeEvent
  observeEvent(input$validate2, {
    print(input$choice2)
  })
}
shinyApp(ui, server)


# re-usable module --------------------------------------------------------

# ns <- NS structure creates a "namespacing" function
# that will prefix all ids with a string

choice_ui <- function(id){
  ns <- NS(id)
  tagList(
    sliderInput(
      inputId = ns("choice"),
      label = "Choice",
      min = 1, max = 10, value = 5
    ),
    actionButton(
      # we need to ns all ids
      inputId = ns("validate"),
      label = "Validate Choice"
    )
  )
}

choice_server <- function(id){
  # calling moduleServer function
  moduleServer(
    # setting the id
    id,
    # define the module core mechanism
    function(input, output, session){
      # this part is same as any standard shiny server
      observeEvent(input$validate, {
        print(input$choice)
      })
    }
  )
}
# main application
app_ui <- function(){
  fluidPage(
    # call the UI function
    choice_ui(id = "choice_ui1"),
    choice_ui(id = "choice_ui2")
  )
}

app_server <- function(input, output, session){
  # we now call the module server functions
  choice_server(id = "choice_ui1")
  choice_server(id = "choice_ui2")
}
shinyApp(app_ui, app_server)
