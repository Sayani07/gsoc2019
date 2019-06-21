
library(data.table)
library(lubridate)
library(ggplot2)
library(scales)

# Load mapping libraries
library(leaflet)
library(maps)
library(sp)
library(rgdal)
library(rgeos)

# Read in Citibike bikeshare csv data file
# https://www.theopenbus.com/
# Go to Bike share data
# download  folders for all months
# extract files using the code below
file.paths <- glue::glue("Docks Data 2018/2018-{formatC(1:12, width = 2, flag = '0')}/bikeshare_nyc_raw.csv")

tmp <- tempfile(fileext = ".csv")

data <- map_dfr(file.paths, function(fp){
  read.csv(fp, header =TRUE,sep="\t")
  
})

bikedata_raw <- data %>% as_tibble()


# Remove any rows which the total docks is zero
bikedata <- bikedata[bikedata$tot_docks != 0 ,]

bikecheck <- bikedata %>% mutate(free_docks = tot_docks - avail_bikes - avail_docks)

quantile(bikecheck$free_docks, seq(0.1,0.9,0.1))

quantile(bikecheck$free_docks, seq(0.01,0.99,0.01))

quantile(bikecheck$free_docks, seq(0.99,0.999,0.001))

bikedata <- bikecheck %>% filter(free_docks<=6) 



##### EXTRACT bikeshare data
##### using code below
##### change year to 2019

library(tidyverse)
library(tsibble)

set.seed(2018)

tmp <- tempfile(fileext = ".csv.zip")
url1 <- glue::glue("https://s3.amazonaws.com/tripdata/JC-2018{formatC(1:12, width = 2, flag = '0')}-citibike-tripdata.csv.zip")

nyc_bikes <- map_dfr(urls, function(url){
  download.file(url, tmp)
  read_csv(tmp, locale = locale(tz = "America/New_York"))
})

nyc_bikes <- nyc_bikes %>%
  transmute(
    bike_id = factor(bikeid),
    start_time = starttime,
    stop_time = stoptime,
    start_station = factor(`start station id`),
    start_lat = `start station latitude`,
    start_long = `start station longitude`,
    end_station = factor(`end station id`),
    end_lat = `end station latitude`,
    end_long = `end station longitude`,
    type = factor(usertype),
    birth_year = `birth year`,
    gender = factor(gender, 0:2, c("Unknown", "Male", "Female"))) 

                
