############################################ PAGE  : comment

#add button check
observeEvent(input$addbutton_comment, {
  output$outputtext_comment <- renderText({ 
    paste("Succesfully added at ",isolate(input$when_comment))
  })
})

#add button schrijf naar mysql
observeEvent(input$addbutton_comment, {
  date <-  isolate(as.character(input$when_comment)) #yyyy-mm-dd 
  comment <- isolate(input$comment)
  #write to database
  db <- connect()
  query <- sprintf(
    "INSERT INTO natural_comment (date,comment) VALUES ('%s')",
    paste(c(date,comment), collapse = "', '")
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