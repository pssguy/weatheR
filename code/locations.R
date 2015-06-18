

output$locations <- renderLeaflet({
  print("enter renderLeaflet")
  
  print(glimpse(allStations))
  
df <-  allStations %>% 
    filter(CTRY=="US")
print(glimpse(df)) #7390 this only prints few ic 1 in Louisiaba

print(nrow(df))

df <-  allStations %>% 
  filter(CTRY=="US"&STATE=="LA") # this has 188 (maybe also inc no lat lon ones)
print(nrow(df))

 df %>%    leaflet() %>% 
    addTiles() %>% 
    #clearBounds() %>% 
    #addCircleMarkers(radius = 5,popup=~ paste0(name,": <b>",NAME,"</b><br>",location,"<br>",industry))
    # addCircleMarkers(radius = 5,popup=~ NAME)
    addCircles(radius = 5,popup=~ NAME,layerId = ~NAME) 
  
})


observe({
  
  if (is.null(input$locations_shape_click$id)) return()
  
  # use the clicked state as filter for data
  
  stationName <-input$locations_shape_click$id
  print(stationName)
  
  USAF <- allStations[allStations$NAME==stationName,]$USAF
  WBAN <- allStations[allStations$NAME==stationName,]$WBAN
  
  loc <- paste0(USAF,"-",WBAN)
  
  met_data <- get_ncdc_station_data(station_id = loc,
                                    startyear = 2014,
                                    endyear = 2015)
  
  print(length(met_data)==0) 
  if (length(met_data)==0) return()
  met_data %>% 
    group_by(year) %>% 
    mutate(dayOfYear=row_number()) %>% 
    group_by(year,month) %>% 
    summarize(min=min(temp, na.rm=T),max=max(temp, na.rm=T), mean=round(mean(temp, na.rm=T),1),readings=n()) -> monthlyAv
  
  monthlyAv %>% 
    group_by(year) %>% 
    ggvis(~month,~ mean) %>% 
    layer_points() %>% 
    layer_lines(stroke =~as.character(year)) %>% 
    bind_shiny("monthly")
  
})