
shinyServer(function(input, output,session) {
  
  
  ## set up input menu in sidebar
  output$sb <- renderUI({
    if (input$sbMenu=="stations") {
      inputPanel(id="ip",
                 selectInput("country","Select Country",countryChoice, selected="Canada"),
                 radioButtons("tempScale","",c("Celsius","Fahrenheit"),inline= TRUE)
      ) 
    } else {
    }
    
  })

  source("code/locations.R", local=TRUE)
  source("code/stateTemps.R", local=TRUE)
  
  
  
 
 
})

