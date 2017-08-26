tabPanel("Period",
         sidebarLayout(
           sidebarPanel(
             titlePanel("Period?"),
             #dateInput("when_period", "When?", value = Sys.Date(), weekstart = 1),
             sliderInput("when_period", "When?", min=Sys.Date(), max=Sys.Date(),value = Sys.Date()),
             radioButtons('quantity_period', 'How much?',  choices = 1:5),
             actionButton("addbutton_period", "Add", width = "100%"),
             h3(textOutput("outputtext_period"))
           ),
           mainPanel(
             #dataTableOutput('table_cycles')
           )
         )
)