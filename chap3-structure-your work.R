library(shiny)
library(bslib)

# re-usable shiny modules for namespace
# uses NS for namespace & tagList for ui component; 
# moduleServer() for server component

choice_ui <- function(id) {
  # this ns <- NS() structure creates a "namespacing" function,
  # that will prefix all ids with a string
  
  ns <- NS(id)
  tagList(
    sliderInput(
      # normal piece of shiny code except for id 
      # wrapped into the ns() function
      inputId = ns("choice"),
      label = "Choice",
      min = 1, max = 10, value = 5
    ),
    actionButton(
      # we need to ns() all ids
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
    # defining the module core mechanism
    function(input, output, session){
      # this part is similar to any standard server 
      observeEvent(input$validate, {
        print(input$choice)
      })
    }
  )
}

# main application

app_ui <- function() {
  page_navbar(
    title = "Modularized shiny app",
    sidebar = sidebar(
      # call UI functions. this is the only place 
      # your IDs will need to be unique
      choice_ui(id = "choice_ui1"),
      choice_ui(id = "choice_ui2")
    )
  )
}

app_server <- function(input, output, session) {
  # we now call module server functions
  choice_server(id = "choice_ui1")
  choice_server(id = "choice_ui2")
}

shinyApp(app_ui, app_server)


# create global reactvalues list passed along through other modules -------


# Module 1, which wil allow to select a number
choice_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # add a slider to select an number
    sliderInput(ns("choice"), "Choice", 1, 10, 5)
  )
}

choice_server <- function(id, r){
  moduleServer(
    id,
    function(input, output, session) {
      # whenever the choice changes, the value inside r is set
      observeEvent(input$choice, {
        r$number_from_first_mod <- input$choice
      })
    }
  )
}

# Module 2, which will display the number
printing_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # insert the number modified in the first module
    verbatimTextOutput(ns("print"))
  )
}

printing_server <- function(id, r) {
  moduleServer(
    id,
    function(input, output, session){
      # we evaluate the reactiveValue element modified in the 
      # first module
      output$print <- renderPrint({
        r$number_from_first_mod
      })
    }
  )
}

# Application

app_ui <- function(){
  page_sidebar(
    title = "Modules with global reactiveValues",
    sidebar = sidebar(
      choice_ui("choice_ui_1"),
      printing_ui("printing_ui_2")
    )
  )
}

app_server <- function(input, output, session) {
  # both values take a reactiveValue,
  # which is set in the first module
  # and printed in the second one.
  # The server function don't return any value per se
  r <- reactiveValues()
  choice_server("choice_ui_1", r = r)
  printing_server("printing_ui_2", r = r)
}

shinyApp(app_ui, app_server)
