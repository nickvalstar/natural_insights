############################################ PAGE  : bylo

#add button check
observeEvent(input$addbutton_bylo, {
  output$outputtext_bylo <- renderText({ 
    paste("Succesfully added at ",isolate(input$when_bylo))
  })
})

#add button schrijf naar mysql
observeEvent(input$addbutton_bylo, {
  date <-  isolate(as.character(input$when_bylo)) #yyyy-mm-dd 
  bylo <- 1
  bylo_addition <- ifelse(isolate(input$bylo_addition),1,0)
  #write to database
  db <- connect()
  query <- sprintf(
    "INSERT INTO natural_bylo (date,bylo,bylo_addition) VALUES ('%s')",
    paste(c(date,bylo,bylo_addition), collapse = "', '")
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