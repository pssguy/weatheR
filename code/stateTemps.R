
output$stateTemps <- renderLeaflet({
for (i in 1:nrow(capitals)) {
  print(i)
  tempDF <- getCurrentTemperature(station = capitals$iata_faa[i])
  print(capitals$iata_faa[i])
  print(tempDF)
  if(is.null(tempDF)) tempDF<- data.frame(Time=NA,TemperatureC=NA)
  if(i!=1) {
    df <- rbind(df,tempDF)
  } else {
    df <- tempDF
  }
}



capitals <- cbind(capitals,df)

print(capitals$TemperatureC)
capitals$popup <- sprintf("<table cellpadding='4' style='line-height:1'><tr>
                        <th>%1$s, %2$s</th></tr>
                            
                            <tr align='center'><td>%3$s</td></tr>
                            <tr align='center'><td>%4$s</td></tr>

                            
                            </table>",
                          capitals$city,
                          capitals$state,
                          capitals$TemperatureC,
                          capitals$Time)

print(capitals$popup)

capitals %>% 
  leaflet() %>% 
  addTiles() %>% 
  addCircles(popup = ~popup)

})