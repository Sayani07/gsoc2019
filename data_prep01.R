
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
# download  folders for all months in Data/Docks Data 2018/ folder
# extract files using the code below - change year
file.paths <- glue::glue("Data/Docks Data 2018/2018-{formatC(1:12, width = 2, flag = '0')}/bikeshare_nyc_raw.csv")

tmp <- tempfile(fileext = ".csv")

data <- map_dfr(file.paths, function(fp){
  read.csv(fp, header =TRUE,sep="\t")
  
})

bikedata_raw <- data %>% as_tibble()



# Remove any rows which the total docks is zero
bikedata <- bikedata_raw[bikedata_raw$tot_docks != 0 ,]
# Create a POSIXct date and time variable using available data
bikedata$date <- as.character.Date(bikedata$date)
bikedata$hour <- bikedata$hour + (bikedata$pm * 12) * (bikedata$hour != 12)
bikedata$hour <- sprintf("%02d",bikedata$hour)
bikedata$minute <- sprintf("%02d",bikedata$minute)

bikedata$hour <- paste(bikedata$hour, bikedata$minute, sep=":" )
bikedata$date <- paste(bikedata$date, bikedata$hour, sep="")
bikedata$date <- as.POSIXct(bikedata$date ,format= "%y-%m-%d %H:%M")
save(bikedata, file =  "Data/bikedata.Rda")

##### EXTRACT bikeshare data
##### using code below
##### change year to 2019

library(tidyverse)
library(tsibble)

set.seed(2018)

tmp <- tempfile(fileext = ".csv.zip")
url1 <- glue::glue("https://s3.amazonaws.com/tripdata/JC-2018{formatC(1:12, width = 2, flag = '0')}-citibike-tripdata.csv.zip")

nyc_bikes <- map_dfr(url1, function(url){
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


save(nyc_bikes, file = "Data/nyc_bikes.Rda")

                
