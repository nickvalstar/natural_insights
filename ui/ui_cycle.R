tabPanel(em("Start new cycle"),
         sidebarLayout(
           sidebarPanel(
             titlePanel("Start new cycle"),
             p("Here you can start a new cycle. It will automatically end the former cycle. "),
             p(" "),
             dateInput("when_cycle", "When does this cycle start?", value = Sys.Date(),weekstart = 1),
             textInput("cycle_number", "Cycle number:", value = "", width = "100%"),
             actionButton("addbutton_cycle", "Add", width = "100%"),
             h3(textOutput("outputtext_cycle"))
           ),
           mainPanel(
             tableOutput('table_cycles')
           )
         )
)