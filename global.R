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

# load requisite files
allStations <- read.csv("allStations_B", stringsAsFactors = F)