tabPanel("Bylo",
         sidebarLayout(
           sidebarPanel(
             titlePanel("Bylo bylo?"),
             #p("Here you can start a new cycle. it will automatically end the former cycle. "),
             #p(" "),
             #dateInput("when_bylo", "When?", value = Sys.Date()-1, weekstart = 1),
             sliderInput("when_bylo", "When?", min=Sys.Date(), max=Sys.Date(),value = Sys.Date()),
             checkboxInput("bylo_addition","With",value=FALSE),
             actionButton("addbutton_bylo", "Add", width = "100%"),
             h3(textOutput("outputtext_bylo"))
           ),
           mainPanel(
             #dataTableOutput('table_cycles')
           )
         )
)