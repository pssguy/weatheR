# load libraries

library(stationaRy)
library(dplyr)
library(ggvis)
library(tidyr)
library(readr)
library(leaflet)
library(shiny)
library(shinydashboard)
library(htmlwidgets)
library(DT)
library(stringr)

# load requisite files
#allStations <- read.csv("allStations_B.csv", stringsAsFactors = F)

## can now probably replace with call as is so fast

allStations <- get_isd_stations()
allStations$stationId <- paste0(allStations$usaf,"-",allStations$wban)

allStations$popup <- sprintf("<table cellpadding='4' style='line-height:1'><tr>
                        <th>%1$s</th></tr>
                             
                             <tr align='center'><td>Start Year: %2$s</td></tr>
                             <tr align='center'><td>End Year: %3$s</td></tr>
                             </table>",
                             allStations$name,
                             allStations$begin,
                             allStations$end)

