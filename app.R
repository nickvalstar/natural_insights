library(shiny)
library(ggplot2)
library(RMySQL)
library(shinycssloaders)
options(shiny.deprecation.messages=FALSE)

ui <- navbarPage(strong("Natural Insights"),
                 source(file.path("ui","ui_temp.R"),  local = TRUE)$value,
                 source(file.path("ui","ui_sluz.R"),  local = TRUE)$value,
                 source(file.path("ui","ui_bylo.R"),  local = TRUE)$value,
                 source(file.path("ui","ui_period.R"),  local = TRUE)$value,
                 source(file.path("ui","ui_comment.R"),  local = TRUE)$value,
                 source(file.path("ui","ui_cycle.R"),  local = TRUE)$value
)

server <- function(input, output, session) {
  source(file.path("connect_info_hidden.R"),  local = TRUE)$value
  values <- reactiveValues()
  source(file.path("server","server_temp.R"),  local = TRUE)$value
  source(file.path("server","server_sluz.R"),  local = TRUE)$value
  source(file.path("server","server_bylo.R"),  local = TRUE)$value
  source(file.path("server","server_period.R"),  local = TRUE)$value
  source(file.path("server","server_comment.R"),  local = TRUE)$value
  source(file.path("server","server_cycle.R"),  local = TRUE)$value
}

shinyApp(ui = ui, server = server)