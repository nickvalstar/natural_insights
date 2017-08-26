############################################ PAGE  : period

#add button check
observeEvent(input$addbutton_period, {
  output$outputtext_period <- renderText({ 
    paste("Succesfully added at ",isolate(input$when_period))
  })
})

#add button schrijf naar mysql
observeEvent(input$addbutton_period, {
  date <-  isolate(as.character(input$when_period)) #yyyy-mm-dd 
  period <- isolate(input$quantity_period)
  #write to database
  db <- connect()
  query <- sprintf(
    "INSERT INTO natural_period (date,period) VALUES ('%s')",
    paste(c(date,period), collapse = "', '")
  )
  tryCatch(
    dbGetQuery(db, query),
    error=function(cond) {
      errormessage <- paste(cond,query)
      print(errormessage) #print on screen liever
    }
  )
  dbDisconnect(db)
})