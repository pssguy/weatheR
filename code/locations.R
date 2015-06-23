

output$locations <- renderLeaflet({
#   print("enter renderLeaflet")
#   
#   print(glimpse(allStations))
#   
# df <-  allStations %>% 
#     filter(CTRY=="US")
# print(glimpse(df)) #7390 this only prints few ic 1 in Louisiaba
# 
# print(nrow(df))

df <-  allStations %>% 
  filter(country=="US"&state=="LA"&begin<=2013&end==2015) # this now has 184 reduced to
print(nrow(df))

 df %>%    leaflet() %>% 
    addTiles() %>% 
    #clearBounds() %>% 
    #addCircleMarkers(radius = 5,popup=~ paste0(name,": <b>",NAME,"</b><br>",location,"<br>",industry))
    # addCircleMarkers(radius = 5,popup=~ NAME)
    addCircles(radius = 5,popup=~ popup,layerId=~stationId) 
  
})


observe({
  print("enter observe")
  if (is.null(input$locations_shape_click$id)) return()
  print(input$locations_shape_click$id)
  # use the clicked state as filter for data
#   
#   stationName <-input$locations_shape_click$id
#   print(stationName)
#   
#   USAF <- allStations[allStations$NAME==stationName,]$USAF
#   WBAN <- allStations[allStations$NAME==stationName,]$WBAN
#   
#   loc <- paste0(USAF,"-",WBAN)
  
  station <-input$locations_shape_click$id
  
  print(station)
  print(class(station))
  
  
#    met_data <- get_isd_station_data(station_id = "720917-306",
#                                     startyear = 2014,
#                                     endyear = 2015)
  
  print(station)
  met_data <- get_isd_station_data(station_id = station,
                                    startyear = 2014,
                                    endyear = 2015
                                    )
  print(unique(met_data$year))
 # print(length(met_data)==0) 
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
    add_legend(scales="stroke",title="") %>% 
    set_options(width=480) %>% 
    bind_shiny("monthly")
  
})