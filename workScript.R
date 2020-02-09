## Script for completing Johns Hopkins Reproducible Research Project #2
## Will take items from script and drop them into R Markdown file for final submission

## Load in ggplot for creating graphs
library(ggplot2)

## Read in the data from the csv.bz2 file pulled from Course Project page
weather_csv <- read.csv(file = "repdata_data_StormData.csv.bz2", stringsAsFactors = FALSE)

## Extract and store the fields we need for our analysis
project_fields <- c("EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", "PROPDMGEXP", "CROPDMG", "CROPDMGEXP")
weather_select <- weather_csv[,project_fields]

## Use prefixes to determine total damage to property and crops
weather_select$PROPDMGEXP[weather_select$PROPDMGEXP == "H" | weather_select$PROPDMGEXP == "h"] <- 100
weather_select$PROPDMGEXP[weather_select$PROPDMGEXP == "K" | weather_select$PROPDMGEXP == "k"] <- 1000
weather_select$PROPDMGEXP[weather_select$PROPDMGEXP == "M" | weather_select$PROPDMGEXP == "m"] <- 1000000
weather_select$PROPDMGEXP[weather_select$PROPDMGEXP == "B" | weather_select$PROPDMGEXP == "b"] <- 1000000000
weather_select$PROPDMGEXP[weather_select$PROPDMGEXP == ""] <- 1

weather_select$CROPDMGEXP[weather_select$CROPDMGEXP == "H" | weather_select$CROPDMGEXP == "h"] <- 100
weather_select$CROPDMGEXP[weather_select$CROPDMGEXP == "K" | weather_select$CROPDMGEXP == "k"] <- 1000
weather_select$CROPDMGEXP[weather_select$CROPDMGEXP == "M" | weather_select$CROPDMGEXP == "m"] <- 1000000
weather_select$CROPDMGEXP[weather_select$CROPDMGEXP == "B" | weather_select$CROPDMGEXP == "b"] <- 1000000000
weather_select$CROPDMGEXP[weather_select$CROPDMGEXP == ""] <- 1

## Create two extra columns that give values for total property damage and crop damage
weather_select$Property_Damage <- as.numeric(weather_select$PROPDMG)*as.numeric(weather_select$PROPDMGEXP)
weather_select$Crop_Damage <- as.numeric(weather_select$CROPDMG)*as.numeric(weather_select$CROPDMGEXP)

## Group rows by EVTYPE and take sum of each event
group_weather <- aggregate(weather_select[, c("FATALITIES", "INJURIES", "Property_Damage", "Crop_Damage")],
                           by = list(weather_select$EVTYPE), "sum")
colnames(group_weather) <- c("Weather_Event", "FATALITIES", "INJURIES", "Property_Damage", "Crop_Damage")


## Health Question
## Create new column in group_weather for total health effects, but put a multiplier on fatalities to 
## Weight it more than injuries
group_weather$Health <- (group_weather$FATALITIES*10) + group_weather$INJURIES

## Sort data from high to low and only pull the first 15 values to keep the graph readable
health_weather <- group_weather[order(-group_weather$Health),][1:10,]
health_weather$Weather_Event <- factor(health_weather$Weather_Event, level = health_weather$Weather_Event)

## Next we will create a bar chart to show the breakdown of public health effects by types of 
## inclement weather
health_plot <- ggplot(data = health_weather, mapping = aes(x = Weather_Event, y = Health)) +
  geom_bar(stat = "identity", fill = "red") + 
  labs(title = "Top 10 Weather Events by Magnitude on Public Health from 1950 and 2011", 
       x = "Type of Weather Event", Y = "Injuries and Fatalities") +
  theme(axis.text.x = element_text(angle = 90))


## Crop Damage Question
## Order and extract top ten events for crop damage
crop_weather <- group_weather[order(-group_weather$Crop_Damage),][1:10,]
crop_weather$Weather_Event <- factor(crop_weather$Weather_Event, level = crop_weather$Weather_Event)

## Create bar chart that shows distribution of top ten crop damage events
crop_plot <- ggplot(data = crop_weather, mapping = aes(x = Weather_Event, y = Crop_Damage)) +
  geom_bar(stat = "identity", fill = "yellow") +
  labs(title = "Top 10 Weather Events by Magnitude of Crop Damage from 1950 to 2011", 
       x = "Type of Weather Event", y = "Damage Done in USD") +
  theme(axis.text.x = element_text(angle = 90))


## Property Damage Question
## Order and extract top ten events for property damage
property_weather <- group_weather[order(-group_weather$Property_Damage),][1:10,]
property_weather$Weather_Event <- factor(property_weather$Weather_Event, level = property_weather$Weather_Event)

## Create barplot of top ten property damage weather events
property_plot <- ggplot(data = property_weather, mapping = aes(x = Weather_Event, y = Property_Damage)) +
  geom_bar(stat = "identity", fill = "green") +
  labs(title = "Top 10 Weather Events by Magnitude of Property Damage form 1950 to 2011",
       x = "Type of Weather Event", y = "Damage Done in USD") +
  theme(axis.text.x = element_text(angle = 90))