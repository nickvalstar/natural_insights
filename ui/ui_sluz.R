tabPanel("Sluz",
         sidebarLayout(
           sidebarPanel(
             titlePanel("Sluz"),
             #dateInput("when_sluz", "When?", value = Sys.Date(), weekstart = 1),
             sliderInput("when_sluz", "When?", min=Sys.Date(), max=Sys.Date(),value = Sys.Date()),
             radioButtons('quantity_sluz', 'Quality?',  choices = c("No data","Low","High","Top")),
             checkboxInput("sluz_addition","Not totally sure",value=FALSE),
             actionButton("addbutton_sluz", "Add", width = "100%"),
             h3(textOutput("outputtext_sluz"))
           ),
           mainPanel(
             #dataTableOutput('table_cycles')
           )
         )
)