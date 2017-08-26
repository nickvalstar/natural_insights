################################################### PAGE 2: ADD CYCLE


#add cycle button check
observeEvent(input$addbutton_cycle, {
  output$outputtext_cycle <- renderText({ 
    paste("Succesfully added new cycle, starting at ",isolate(input$when_cycle))
  })
})

#add button schrijf naar mysql
observeEvent(input$addbutton_cycle, {
  date <-  isolate(as.character(input$when_cycle)) #yyyy-mm-dd 
  cycle_number <- isolate(input$cycle_number)
  #write to database
  db <- connect()
  query <- sprintf(
    "INSERT INTO natural_cycles (cycle_start,cycle_number) VALUES ('%s')",
    paste(c(date,cycle_number), collapse = "', '")
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






######## CYCLE TABLE
#eenmalig de tabel data klaarzetten
db <- connect() #connect met database
query <- "select cycle_number as Cycle, cycle_start as StartDate from natural_cycles order by cycle_number"
values$cycle_table <- dbGetQuery(db, query)
query <- "select max(cycle_start) as this_start_startdate from natural_cycles"
this_start_startdate <- dbGetQuery(db, query)
mindate <- as.Date(this_start_startdate$this_start_startdate)
dbDisconnect(db)

updateSliderInput(session, 'when', min = mindate, max = Sys.Date(), value = Sys.Date())
updateSliderInput(session, 'when_sluz', min = mindate, max = Sys.Date(), value = Sys.Date())
updateSliderInput(session, 'when_period', min = mindate, max = Sys.Date(), value = Sys.Date())
updateSliderInput(session, 'when_bylo', min = mindate, max = Sys.Date(), value = Sys.Date())
updateSliderInput(session, 'when_comment', min = mindate, max = Sys.Date(), value = Sys.Date())


#updaten tabel data als iets wordt toegevoegd
observeEvent(input$addbutton_cycle, {
  db <- connect() #connect met database
  query <- "select cycle_number as Cycle, cycle_start as StartDate from natural_cycles order by cycle_number"
  values$cycle_table <- dbGetQuery(db, query)
  query <- "select max(cycle_start) as this_start_startdate from natural_cycles"
  this_start_startdate <- dbGetQuery(db, query)
  mindate <- as.Date(this_start_startdate$this_start_startdate)
  dbDisconnect(db)
  
  updateSliderInput(session, 'when', min = mindate, max = Sys.Date(), value = Sys.Date())
  updateSliderInput(session, 'when_sluz', min = mindate, max = Sys.Date(), value = Sys.Date())
  updateSliderInput(session, 'when_period', min = mindate, max = Sys.Date(), value = Sys.Date())
  updateSliderInput(session, 'when_bylo', min = mindate, max = Sys.Date(), value = Sys.Date())
  updateSliderInput(session, 'when_comment', min = mindate, max = Sys.Date(), value = Sys.Date())
  
})



#tabel
output$table_cycles <- renderTable(values$cycle_table)
