# Set up reactive values initially as null
values <- reactiveValues()

# function to get Season data from graph and apply to table

getHour = function(data,location,session){
  
  if(is.null(data)) return(NULL)
  #   
  values$theDay <- data$day
  print(values$theDay)
  print(values$theMonth)
}


getDay = function(data,location,session){
  
   if(is.null(data)) return(NULL)
#   
    values$theMonth <- data$month
    values$theYear <- data$year
#    
#    print(theMonth)
#    print(theYear)
#    print(class(theYear)) #integer
   
   
      observe({
         print("theMonth")
  print(values$theMonth)
 # print(glimpse(theData()$met_data))
  
  theData()$met_data %>% 
    filter(year==values$theYear&month==values$theMonth) %>% 
    group_by(day) %>% 
    summarize(min=min(temp, na.rm=T),max=max(temp, na.rm=T), mean=round(mean(temp, na.rm=T),1)) -> dailyAv
  
  dailyAv.gather <-dailyAv %>% 
    gather(cats,temp,-day)
  
  # this shows
  glimpse(dailyAv.gather)
  
  dailyAv.gather %>% 
    group_by(cats) %>% 
    ggvis(~day,~temp) %>% 
    layer_lines(stroke =~cats) %>% 
    layer_points(size = 3) %>% 
    add_legend(scales="stroke",title="") %>% 
    add_axis("y", title="temp C") %>% 
    add_axis("x", title="Day of Month") %>% 
    handle_click(getHour) %>% 
    set_options(width=480) %>% 
    bind_shiny("daily")
  
  #ERROR: [on_request_read] connection reset by peer
  
   })
     
     
#      session$output$daily <- renderPlot({
#        print("theMonth")
#        print(theMonth)
#        print(glimpse(theData()$met_data))
#         })
}

# #     
# #     theSeason })
# #   
# #   session$output$standings <- DT::renderDataTable({
# #     #     theDivision <-  all %>% 
# #     #       filter(Season==theSeason&team==input$team) %>% 
# #     #       .$division
# #     
# #     all %>% 
# #       filter(Season==theSeason) %>% 
# #       arrange(Position) %>% 
# #       
# #       select(team,Pl=GP,W,D,L,GD=gd,Pts) %>% 
# #       
# #       DT::datatable(options= list(scrollY = 500,paging = FALSE, searching = FALSE,info=FALSE))
# #     
#   }



output$locations <- renderLeaflet({
print("enter locations")

df <-  allStations %>% 
  #filter(country=="US"&state=="LA"&begin<=2013&end==2015) # this now has 184 reduced to 78
  filter(country_name==input$country&begin<=2013&end==2015)
print(nrow(df))
print(glimpse(df))
df <- data.frame(df)
 df %>%    leaflet() %>% 
    addTiles() %>% 
    #clearBounds() %>% 
    #addCircleMarkers(radius = 5,popup=~ paste0(name,": <b>",NAME,"</b><br>",location,"<br>",industry))
    # addCircleMarkers(radius = 5,popup=~ NAME)
    addCircles(radius = 5,popup=~ popup,layerId=~stationId) 
  
})

theData <- reactive({
  print("enter reactive")
  if (is.null(input$locations_shape_click$id)) return()
  #  print(input$locations_shape_click$id)
  
  
  station <-input$locations_shape_click$id
  
  #   print(station)
  #   print(class(station))
  #   
  #   
  # #    met_data <- get_isd_station_data(station_id = "720917-306",
  # #                                     startyear = 2014,
  # #                                     endyear = 2015)
  #   
  #   print(station)
  met_data <- get_isd_station_data(station_id = station,
                                   startyear = 2014,
                                   endyear = 2015
  )
  print(unique(met_data$year))
  lastYear <- unique(met_data$year)[1]
  print(lastYear)
  info=list(met_data=met_data,lastYear=lastYear)
  return(info)
  # print(length(met_data)==0) 
})

# output$monthlyText <- renderText({
#   print("enter monthlyText")
#   if(is.null(theData()$lastYear)) return()
#   theText <- theData()$lastYear
#   
# })

# 
observe({
  print("enter monthly")
  if(is.null(theData()$met_data)) return()
  
   theData()$met_data %>% 
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
      handle_click(getDay) %>% 
      set_options(width=480) %>% 
      bind_shiny("monthly")
  
  
})
# 
# # this works but want to create a reactive whci can can also be used for monhly and daily data
# 
# # observe({
# # #  print("enter observe")
# #   if (is.null(input$locations_shape_click$id)) return()
# # #  print(input$locations_shape_click$id)
# # 
# #   
# #   station <-input$locations_shape_click$id
# #   
# # #   print(station)
# # #   print(class(station))
# # #   
# # #   
# # # #    met_data <- get_isd_station_data(station_id = "720917-306",
# # # #                                     startyear = 2014,
# # # #                                     endyear = 2015)
# # #   
# # #   print(station)
# #   met_data <- get_isd_station_data(station_id = station,
# #                                     startyear = 2014,
# #                                     endyear = 2015
# #                                     )
# # #  print(unique(met_data$year))
# #  # print(length(met_data)==0) 
# #   if (length(met_data)==0) return()
# #   met_data %>% 
# #     group_by(year) %>% 
# #     mutate(dayOfYear=row_number()) %>% 
# #     group_by(year,month) %>% 
# #     summarize(min=min(temp, na.rm=T),max=max(temp, na.rm=T), mean=round(mean(temp, na.rm=T),1),readings=n()) -> monthlyAv
# #   
# #   monthlyAv %>% 
# #     group_by(year) %>% 
# #     ggvis(~month,~ mean) %>% 
# #     layer_points() %>% 
# #     layer_lines(stroke =~as.character(year)) %>% 
# #     add_legend(scales="stroke",title="") %>% 
# #     handle_click(getMonth) %>% 
# #     set_options(width=480) %>% 
# #     bind_shiny("monthly")
# #   
# # })