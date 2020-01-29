---
title: "Reproducible Research: The effect of Severe Weather on US Weatlh and Health"
author : "Daniel Pericich"
output: 
html_document:
keep_md: true
---

Set Global Options
```{r}
knitr::opts_chunk$set(warning=FALSE, message = FALSE, echo = TRUE)
```
<h1> Synopsis </h1>

<h1> Data Processing </h1>
<p> Before beginning data cleaning and analysis, we will load in the necessary libraries for this project </p>

```{r}
library(dplyr)
library(ggplot2)
library(lubridate)
```

<p> The first step in processing the data is to load it into R Studio. To do this we will call the read.csv() with the assumption that the file has been saved within the project folder </p>

```{r}
weather_csv <- read.csv(file = "repdata_data_StormData.csv.bz2")
```

<p> We will want to change "weather_csv" to a tibble from a dataframe </p>
```{r}
weather <- as_tibble(weather_csv)
```

<p> Next, we will filter out the columns that relate to public health and the economy and store them in a new tibble </p>
```{r}
weather_select <- select(weather, EVTYPE, (FATALITIES : CROPDMGEXP))
## Then create new column variable that sums INJURIES and FATALITIES columns
weather_select <- mutate(weather_select, HEALTH = sum(INJURIES, FATALITIES))
```

<h1> Figures </h1>

<h1> Results </h1>



