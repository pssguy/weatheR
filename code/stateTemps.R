
#output$stateTemps <- renderLeaflet({
theData <- reactive({
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
print(glimpse(capitals))


info=list(capitals=capitals)
return(info)

})

output$stateTempsMap <- renderLeaflet({

  if(is.null(input$tempScale2)) return()
  
if(input$tempScale2=="Fahrenheit"){
  capitals <- theData()$capitals %>% 
    mutate(temp=round(TemperatureC*9/5+32),0)
  
  capitals$popup <- sprintf("<table cellpadding='4' style='line-height:1'><tr>
                        <th>%3$s F</th></tr>
                            
                            <tr align='center'><td>%1$s, %2$s</td></tr>
                            <tr align='center'><td>%4$s</td></tr>

                            
                            </table>",
                            capitals$city,
                            capitals$state,
                            capitals$temp,
                            capitals$Time)
  
} else{
  capitals <- theData()$capitals %>% 
    mutate(temp=TemperatureC)
  
  capitals$popup <- sprintf("<table cellpadding='4' style='line-height:1'><tr>
                        <th>%3$s </th></tr>
                            
                            <tr align='center'><td>%1$s, %2$s</td></tr>
                            <tr align='center'><td>%4$s</td></tr>

                            
                            </table>",
                            capitals$city,
                            capitals$state,
                            capitals$temp,
                            capitals$Time)
  
}

capitals$popup <- sprintf("<table cellpadding='4' style='line-height:1'><tr>
                        <th>%3$s</th></tr>
                            
                            <tr align='center'><td>%1$s, %2$s</td></tr>
                            <tr align='center'><td>%4$s</td></tr>

                            
                            </table>",
                          capitals$city,
                          capitals$state,
                          capitals$temp,
                          capitals$Time)

print(capitals$popup)

capitals %>% 
  leaflet() %>% 
  addTiles() %>% 
  addCircles(popup = ~popup)

})

output$stateTempsTable <- DT::renderDataTable({
  
  if(is.null(input$tempScale2)) return()
  
  if(input$tempScale2=="Fahrenheit"){
    capitals <- theData()$capitals %>% 
      mutate(temp=round(TemperatureC*9/5+32),0)
  } else {
    capitals <- theData()$capitals %>% 
      mutate(temp=TemperatureC)
  }
    
  capitals %>% 
    arrange(desc(temp)) %>% 
    select(city,state,temp,Time) %>% 
    DT::datatable(options=list(paging = TRUE, searching = FALSE,info=FALSE))
                                                                    
  
})