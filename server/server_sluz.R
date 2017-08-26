############################################ PAGE  : sluz

#add button check
observeEvent(input$addbutton_sluz, {
  output$outputtext_sluz <- renderText({ 
    paste("Succesfully added at ",isolate(input$when_sluz))
  })
})

#add button schrijf naar mysql
observeEvent(input$addbutton_sluz, {
  date <-  isolate(as.character(input$when_sluz)) #yyyy-mm-dd 
  sluz <- isolate(input$quantity_sluz)
  sluz_addition <- ifelse(isolate(input$sluz_addition),1,0)
  #write to database
  db <- connect()
  query <- sprintf(
    "INSERT INTO natural_sluz (date,sluz,sluz_addition) VALUES ('%s')",
    paste(c(date,sluz,sluz_addition), collapse = "', '")
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