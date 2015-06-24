# Set up reactive values initially as null
values <- reactiveValues()

# function to get Season data from graph and apply to table

getHour = function(data,location,session){
  
  if(is.null(data)) return(NULL)
   
  values$theDay <- data$day
  
 
  
  observe({
    
    if(input$tempScale=="Celsius") {
    theData()$met_data %>% 
    filter(year==values$theYear&month==values$theMonth&day==values$theDay) %>% 
    ggvis(~hour,~temp) %>% 
    layer_lines() %>% 
    layer_points(size = 3) %>% 
    
    add_axis("y", title="temp C") %>% 
    add_axis("x", title="Hour of Day") %>% 
    
    set_options(width=480) %>% 
    bind_shiny("hourly") 
    } else {
      theData()$met_data %>% 
        filter(year==values$theYear&month==values$theMonth&day==values$theDay) %>% 
        mutate(temp=temp*9/5-32) %>% 
        ggvis(~hour,~temp) %>% 
        layer_lines() %>% 
        layer_points(size = 3) %>% 
        
        add_axis("y", title="temp F") %>% 
        add_axis("x", title="Hour of Day") %>% 
        
        set_options(width=480) %>% 
        bind_shiny("hourly")   
    }
  })
}


getDay = function(data,location,session){
  
   if(is.null(data)) return(NULL)
   
    values$theMonth <- data$month
    values$theYear <- data$year

   
   
      observe({

  if (input$tempScale=="Celsius") {
  theData()$met_data %>% 
    filter(year==values$theYear&month==values$theMonth) %>% 
    group_by(day) %>% 
    summarize(min=min(temp, na.rm=T),max=max(temp, na.rm=T), mean=round(mean(temp, na.rm=T),1)) -> dailyAv
         theTitle<-"temp C"
  } else {
    theData()$met_data %>% 
      filter(year==values$theYear&month==values$theMonth) %>% 
      mutate(temp=temp*9/5+32) %>% 
      group_by(day) %>% 
      summarize(min=min(temp, na.rm=T),max=max(temp, na.rm=T), mean=round(mean(temp, na.rm=T),1)) -> dailyAv
    theTitle<-"temp F"
  }
        
        
  dailyAv.gather <-dailyAv %>% 
    gather(cats,temp,-day)
  
  
  
  # this shows
 # glimpse(dailyAv.gather)
  
  dailyAv.gather %>% 
    group_by(cats) %>% 
    ggvis(~day,~temp) %>% 
    layer_lines(stroke =~cats) %>% 
    layer_points(size = 3) %>% 
    add_legend(scales="stroke",title="") %>% 
    add_axis("y", title=theTitle) %>% 
    add_axis("x", title="Day of Month") %>% 
    handle_click(getHour) %>% 
    set_options(width=480) %>% 
    bind_shiny("daily")
  
  
   })
     
   }



output$locations <- renderLeaflet({
print("enter locations")

df <-  allStations %>% 
  
  filter(country_name==input$country&begin<=2013&end==2015)

df <- data.frame(df)
 df %>%    leaflet() %>% 
    addTiles() %>% 
    addCircles(radius = 5,popup=~ popup,layerId=~stationId) 
  
})

theData <- reactive({
  
  if (is.null(input$locations_shape_click$id)) return()
  
  
  
  station <-input$locations_shape_click$id


  met_data <- get_isd_station_data(station_id = station,
                                   startyear = 2014,
                                   endyear = 2015)


  info=list(met_data=met_data)
  return(info)
  
})

 
observe({
  print("enter monthly")
  if(is.null(theData()$met_data)) return()
  
  if(input$tempScale=="Celsius") {
   theData()$met_data %>% 
      group_by(year) %>% 
      mutate(dayOfYear=row_number()) %>% 
      group_by(year,month) %>% 
      summarize(min=min(temp, na.rm=T),max=max(temp, na.rm=T), mean=round(mean(temp, na.rm=T),1),readings=n()) -> monthlyAv
    
   theTitle<-"temp C"
  } else {
    theData()$met_data %>% 
      mutate(temp=(temp*9/5+32)) %>% 
      group_by(year) %>% 
      mutate(dayOfYear=row_number()) %>% 
      group_by(year,month) %>% 
      summarize(min=min(temp, na.rm=T),max=max(temp, na.rm=T), mean=round(mean(temp, na.rm=T),1),readings=n()) -> monthlyAv
    
    theTitle<-"temp F"
  }
   
    monthlyAv %>% 
      group_by(year) %>% 
      ggvis(~month,~ mean) %>% 
      layer_points() %>% 
      layer_lines(stroke =~as.character(year)) %>% 
      add_axis("y", title=theTitle) %>%
      add_axis("x", title="Month") %>%
      add_legend(scales="stroke",title="") %>% 
      handle_click(getDay) %>% 
      set_options(width=480) %>% 
      bind_shiny("monthly")
  
  
})
