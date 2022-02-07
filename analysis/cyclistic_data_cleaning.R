library(tidyverse)
library(lubridate)

# Data from https://divvy-tripdata.s3.amazonaws.com/index.html
# Import and unify data types


trips_2020_04 <- read_csv("data/202004-divvy-tripdata.csv")
trips_2020_05 <- read_csv("data/202005-divvy-tripdata.csv")
trips_2020_06 <- read_csv("data/202006-divvy-tripdata.csv")
trips_2020_07 <- read_csv("data/202007-divvy-tripdata.csv")
trips_2020_08 <- read_csv("data/202008-divvy-tripdata.csv")
trips_2020_09 <- read_csv("data/202009-divvy-tripdata.csv")
trips_2020_10 <- read_csv("data/202010-divvy-tripdata.csv")
trips_2020_11 <- read_csv("data/202011-divvy-tripdata.csv")

trips_2020_12 <- read_csv("data/202012-divvy-tripdata.csv")
trips_2021_01 <- read_csv("data/202101-divvy-tripdata.csv")
trips_2021_02 <- read_csv("data/202102-divvy-tripdata.csv")
trips_2021_03 <- read_csv("data/202103-divvy-tripdata.csv")
trips_2021_04 <- read_csv("data/202104-divvy-tripdata.csv")
trips_2021_05 <- read_csv("data/202105-divvy-tripdata.csv")
trips_2021_06 <- read_csv("data/202106-divvy-tripdata.csv")
trips_2021_07 <- read_csv("data/202107-divvy-tripdata.csv")
trips_2021_08 <- read_csv("data/202108-divvy-tripdata.csv")
trips_2021_09 <- read_csv("data/202109-divvy-tripdata.csv")

trips_2020_04 <- mutate(trips_2020_04, start_station_id = as.character(start_station_id)
                        , end_station_id = as.character(end_station_id))
trips_2020_05 <- mutate(trips_2020_05, start_station_id = as.character(start_station_id)
                        , end_station_id = as.character(end_station_id))
trips_2020_06 <- mutate(trips_2020_06, start_station_id = as.character(start_station_id)
                        , end_station_id = as.character(end_station_id))
trips_2020_07 <- mutate(trips_2020_07, start_station_id = as.character(start_station_id)
                        , end_station_id = as.character(end_station_id))
trips_2020_08 <- mutate(trips_2020_08, start_station_id = as.character(start_station_id)
                        , end_station_id = as.character(end_station_id))
trips_2020_09 <- mutate(trips_2020_09, start_station_id = as.character(start_station_id)
                        , end_station_id = as.character(end_station_id))
trips_2020_10 <- mutate(trips_2020_10, start_station_id = as.character(start_station_id)
                        , end_station_id = as.character(end_station_id))
trips_2020_11 <- mutate(trips_2020_11, start_station_id = as.character(start_station_id)
                        , end_station_id = as.character(end_station_id))
  

# combine all data into quarters and master sheet
trips_2020_q2 <- merge(trips_2020_04, trips_2020_05, all=TRUE) %>% 
  merge(trips_2020_06, all=TRUE)
trips_2020_q3 <- merge(trips_2020_07, trips_2020_08, all=TRUE) %>% 
  merge(trips_2020_09, all=TRUE)
trips_2020_q4 <- merge(trips_2020_10, trips_2020_11, all=TRUE) %>% 
  merge(trips_2020_12, all=TRUE)
trips_2021_q1 <- merge(trips_2021_01, trips_2021_02, all=TRUE) %>% 
  merge(trips_2021_03, all=TRUE)
trips_2021_q2 <- merge(trips_2021_04, trips_2021_05, all=TRUE) %>% 
  merge(trips_2021_06, all=TRUE)
trips_2021_q3 <- merge(trips_2021_07, trips_2021_08, all=TRUE) %>% 
  merge(trips_2021_09, all=TRUE)

trips <- merge(trips_2020_q2, trips_2020_q3, all=TRUE) %>% 
  merge(trips_2020_q4, all=TRUE) %>% merge(trips_2021_q1, all=TRUE) %>% 
  merge(trips_2021_q2, all=TRUE) %>% merge(trips_2021_q3, all=TRUE)

# add a column to measure the ride duration and day  
trips <- trips %>% 
  mutate(ride_length_sec = as.double(seconds(interval(started_at, ended_at))))
trips <- trips %>% 
  mutate(day = as.character(wday(ymd_hms(started_at), label = TRUE, abbr = TRUE)))
         
# remove station ID due to inconsistencies
trips <- select(trips, -start_station_id, -end_station_id)

# remove trips with incorrect start/end times
trips <- trips %>% 
  filter(ride_length_sec >= 1)

# save master sheet to csv for future use
write_csv(trips, "data/2020_q2-2021_q3_trip_data.csv")
