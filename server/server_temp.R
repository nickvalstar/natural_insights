

#add button check
observeEvent(input$addbutton, {
  output$outputtext <- renderText({ 
    paste("Succesfully added at ",isolate(input$when))
  })
})

#get the cycles
db <- connect() #connect met database
query <- "select distinct cycle from natural_cycles"
cycles <- dbGetQuery(db, query)
dbDisconnect(db)


#add button schrijf naar mysql
observeEvent(input$addbutton, {
  #clean wat er wordt toegevoegd:
  date <-  isolate(as.character(input$when)) #yyyy-mm-dd
  temp <-  isolate(input$tempslider)
  temp_addition <- ifelse(isolate(input$temp_addition),1,0)

  #write to database
  db <- connect()
  query <- sprintf(
    "INSERT INTO natural_log (date,temp,temp_addition) VALUES ('%s')",
    paste(c(date, temp,temp_addition), collapse = "', '")
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

output$myChartGrid <- renderPlot({
  print("show graph")
  input$addbutton
  input$addbutton_sluz
  input$addbutton_bylo
  input$addbutton_period
  input$addbutton_comment
  
  db <- connect() #connect met database
  query <- paste0("select * from natural_cycles2 where 1=1",
                  " and cycle = (select max(cycle) from natural_cycles)"
  )
  showing_cycle <- dbGetQuery(db, query)
  dbDisconnect(db)

  db <- connect() #connect met database
  query <- paste0("select selected_date as date,
                  temp, temp_addition,
                  sluz, sluz_addition,
                  bylo, bylo_addition,
                  period,
                  natural_comment_id, comment
                  from all_dates a
                  left join natural_log b
                  on a.selected_date = b.date
                  left join natural_bylo c
                  on a.selected_date = c.date
                  left join natural_sluz d
                  on a.selected_date = d.date
                  left join natural_period e
                  on a.selected_date = e.date
                  left join natural_comment f
                  on a.selected_date = f.date
                  where 1=1",
                  " and selected_date >= '", showing_cycle$cycle_start,"'",
                  " and selected_date <= '", showing_cycle$cycle_end,"'",
                  "order by selected_date"
  )
  df_plot <- dbGetQuery(db, query)
  dbDisconnect(db)

  #check
  if (nrow(df_plot)==0){
    print("empty plot")
    return(NULL)
  }

  #date
  df_plot$num <- 1:nrow(df_plot)
  df_plot$date2 <- factor(paste0(
    substring(df_plot$date,9,10), #dd
    substring(df_plot$date,5,7), #mm
    ' ',
    substring(weekdays(as.Date(df_plot$date,'%Y-%m-%d')),1,2),#dinsdag
    ' ',
    df_plot$num
  ),levels = unique(paste0(
    substring(df_plot$date,9,10), #dd
    substring(df_plot$date,5,7), #mm
    ' ',
    substring(weekdays(as.Date(df_plot$date,'%Y-%m-%d')),1,2),#dinsdag
    ' ',
    df_plot$num
  ) ))

  #bylo
  df_plot$bylo <-   as.numeric(ifelse(df_plot$bylo,36.4,NA))
  df_plot$bylo_addition <- as.numeric(ifelse(df_plot$bylo_addition,36.4,NA))

  #sluz
  df_plot$sluz <- as.character(df_plot$sluz)
  df_plot$sluz_position <- as.numeric(ifelse(!is.na(df_plot$temp),df_plot$temp+0.15,36.6))
  df_plot$sluz_position <- 36.45
  #sluz samenvoegen naam (sluz) en eventuele vraagteken (sluz_addition)
  df_plot[is.na(df_plot$sluz),c("sluz")] <- ""
  df_plot[is.na(df_plot$sluz_addition),c("sluz_addition")] <- ""
  df_plot$sluz_addition <- as.character(ifelse(df_plot$sluz_addition==1,"?",""))
  df_plot$sluz2 <- paste(df_plot$sluz,df_plot$sluz_addition)

  #temp addition
  df_plot[is.na(df_plot$temp_addition),c("temp_addition")] <- ""
  df_plot$temp_addition <- as.character(ifelse(df_plot$temp_addition==1,"?",""))
  df_plot$temp2 <- paste(df_plot$temp,df_plot$temp_addition)

  #period
  df_plot$period_position <- 36.45
  df_plot$period2 <- sapply(df_plot$period,FUN= function(x) {ifelse(is.na(x),"",paste(rep("#",x),collapse=""))})
  
  #comment
  df_plot$comment_position <- 37.25
  df_plot$comment_label <- ifelse(is.na(df_plot$comment),"","*")
  #df_plot$natural_comment_id
  
  if(sum(!is.na(df_plot$comment)>0)){
    df_comment <- df_plot[!is.na(df_plot$comment),c("date2","comment")]
    colnames(df_comment) <- c("Date","Comment")
    values$df_comment <- df_comment
  } else{
    values$df_comment <- data.frame()
  }
  
  #ggplot
  g <- ggplot(df_plot,aes(x=date2, y=temp,colour=1,group=1))
  g <- g + geom_line()
  g <- g + geom_text(aes(label=temp2), size = 4)
  #g <- g + geom_point(colour="blue")
  #layout:
  g <- g + labs(title=paste0("Natural Insights: showing cycle ",showing_cycle$cycle_number,", started at ",showing_cycle$cycle_start), x="Date", y="Temperature")
  g <- g +   theme_bw() #theme with white background
  g <- g + theme(
    plot.background = element_blank()
    ,panel.border = element_blank()
  ) #eliminates background, gridlines, and chart border
  g <- g+ scale_y_continuous(breaks=seq(36.6, 37.2,0.2),limits=c(36.4, 37.25))
  g <- g+    theme(axis.line = element_line(color = 'black')) #draws x and y axis line
  g <- g + theme(axis.text.x = element_text(angle = 90, hjust = 1))
  g <- g + theme(legend.position="none") #removes all legends
  g <- g + geom_point(aes(x=date2,y=bylo),shape=4) #bylo
  g <- g + geom_point(aes(x=date2,y=bylo_addition),shape=1,size=4) #met
  g <- g + geom_text(aes(x=date2,y=sluz_position,label=sluz2),size=4,angle=90,hjust=0)
  g <- g + geom_text(aes(x=date2,y=period_position,label=period2),size=4,angle=90,hjust=0)
  g <- g + geom_text(aes(x=date2,y=comment_position,label=comment_label),size=5,angle=0,hjust=0)
  return(g)
})

output$comment_table <- renderTable(values$df_comment)