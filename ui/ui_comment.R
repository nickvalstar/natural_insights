tabPanel("Comment",
         sidebarLayout(
           sidebarPanel(
             titlePanel("Any comments?"),
             #dateInput("when_comment", "When?", value = Sys.Date(), weekstart = 1),
             sliderInput("when_comment", "When?", min=Sys.Date(), max=Sys.Date(),value = Sys.Date()),
             textInput("comment", "Comment:", value = "", width = "100%"),
             actionButton("addbutton_comment", "Add", width = "100%"),
             h3(textOutput("outputtext_comment"))
           ),
           mainPanel(
             #dataTableOutput('table_cycles')
           )
         )
)