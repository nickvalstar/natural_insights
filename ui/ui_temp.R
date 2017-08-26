tabPanel("Temperature", 
         sidebarLayout(
           sidebarPanel(
             titlePanel("Temperature"),
             p("Here you can input your temperature"),
             sliderInput("when", "When?", min=Sys.Date(), max=Sys.Date(),value = Sys.Date()),
             sliderInput("tempslider", "Temp", 36.6 , 37.2, 36.6, step = 0.1),
             checkboxInput("temp_addition","Not totally sure",value=FALSE),
             actionButton("addbutton", "Add",width = "100%"),
             h3(textOutput("outputtext"))
           ),
           mainPanel( 
             withSpinner(plotOutput("myChartGrid")),
             tableOutput('comment_table')
           )
         )
)
