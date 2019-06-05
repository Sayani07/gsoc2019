#install.packages("bikedata")
library(bikedata)
library(RSQLite)
library(dplyr)

bike_data <- store_bikedata (city = 'nyc', bikedb = 'bikedb', dates = 201901:201905)

bikedb <- file.path ("bikedata/Data", "bikedb.sqlite")
la_2017 <- dl_bikedata (city = 'divvy', dates = 2015, quiet = TRUE)
store_bikedata (bikedb = 'bikedb',city = 'nyc',dates = 201601:201603, quiet = TRUE)

con <- dbConnect(RSQLite::SQLite(), "bikedata/Data/bikedb.sqlite")
src_dbi(con)
la_2018 <- tbl(con, "datafiles")
la_db <- la_2018 %>% collect()


store_bikedata (city = 'nyc', bikedb = 'bikedb', dates = 201601:201603)


la_dbdata_dir <- tempdir ()
bike_write_test_data (data_dir = data_dir)
# or download some real data!


dl_bikedata (city = 'la', data_dir = bikedb)
bikedb <- file.path (data_dir, 'testdb')
store_bikedata (data_dir = data_dir, bikedb = bikedb)

# create database indexes for quicker access:
index_bikedata_db (bikedb = bikedb)


#
dc_2016 <- dl_bikedata (city = 'dc', dates = '2016.03-2016.05', data_dir = "bikedata/Data")


library(tsibble)
data_nyc <- tsibbledata::nyc_bikes %>% as_tsibble()

