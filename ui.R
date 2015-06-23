
dashboardPage(skin="red",
              dashboardHeader(title = img(src="logo.jpg", height = 50, align = "left")),
  
    dashboardSidebar(
#       sliderInput("count","",min=1,max=1000,value=c(1,1000),step=10, ticks=FALSE),
#       uiOutput("industries"),
 
  sidebarMenu(
    menuItem("Maps", tabName = "maps",icon = icon("map-marker")),
 
#   menuItem("Data", tabName = "data",icon = icon("database")),
  menuItem("Info", tabName = "info",icon = icon("info")),
#   
#   menuItem("Code",icon = icon("code-fork"),
#            href = "https://github.com/pssguy/fortune500"),
#   
  menuItem("Other Dashboards",
           menuSubItem("MLB",href = "https://mytinyshinys.shinyapps.io/mlbCharts"),
           menuSubItem("Fortune 500",href = "https://mytinyshinys.shinyapps.io/fortune500"),
           menuSubItem("WikiGuardian",href = "https://mytinyshinys.shinyapps.io/wikiGuardian"),
           menuSubItem("World Soccer",href = "https://mytinyshinys.shinyapps.io/worldSoccer")
           
  ),
  
  menuItem("", icon = icon("twitter-square"),
           href = "https://twitter.com/pssGuy"),
  
  menuItem("", icon = icon("envelope"),
           href = "mailto:agcur@rogers.com")
    )
    ),
    
  dashboardBody( 
    tabItems(
      tabItem("maps",
  fluidRow(
    
    column(width=6,
    
    box(width=12,
      status = "success", solidHeader = TRUE,
      title = "Click on circle for Station Name and Monthly Temperature Chart",
      leafletOutput("locations")
      
    )
    ),
    column(width=6,
    box(width=12,
      status = "success", solidHeader = TRUE,
      title = "Click on Point  for Daily Data",
      collapsible = TRUE, collapsed = FALSE,
      ggvisOutput("monthly")
      
    ),
    box(width=12,
        status = "success", solidHeader = TRUE,
        title = "Click on Point  for Hourly Data",
        collapsible = TRUE, collapsed = TRUE,
        ggvisOutput("daily")
        
    ),
    box(width=12,
        status = "success", solidHeader = TRUE,
        title = "Hourly Data",
        collapsible = TRUE, collapsed = TRUE,
        ggvisOutput("hourly")
        
    )
    )
  )
      ),

# tabItem("data",
#           fluidRow(
#             column(width=8,offset=2,
#           
#           box(width=12,
#             status = "info", solidHeader = FALSE,
#             includeMarkdown("data.md")
#           ),
#           box(width=12,
#             DT::dataTableOutput("data")
#           )
#             ))
#         ),
# 
 tabItem("info",includeMarkdown("info.md"))

) 
       
        
)
)




