

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
    addCircles(radius = 5,popup=~ NAME) 
  
  
  
  
})