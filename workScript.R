## Script for completing Johns Hopkins Reproducible Research Project #2
## Will take items from script and drop them into R Markdown file for final submission

## Load in tidyverse
library(dplyr)
library(lubridate)
library(ggplot2)


## Read in the data from the csv.bz2 file pulled from Course Project page
weather_csv <- read.csv(file = "repdata_data_StormData.csv.bz2")

## Transfer csv output to a tibble for easier manipulation
weather <- as_tibble(weather_csv)
weather_select <- select(weather, EVTYPE, (FATALITIES:CROPDMGEXP))
weather_select <- mutate(weather_select, HEALTH = sum(INJURIES, FATALITIES))

## Data Manipulation
## Start by creating a metric for the total health impairments of environmental issue
