library(tidyverse)

trips <- read_csv("data/2020_q2-2021_q3_trip_data.csv")

# data summary
glimpse(trips)

# data date range
date(min(trips$started_at))
date(max(trips$ended_at))

# total trips
count(trips)

# total trips per membership status
trips %>% 
  group_by(member_casual) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

# total trips per day separated by membership status
trips %>% 
  group_by(day, member_casual) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

# total trips per bike type by membership status
trips %>% 
  group_by(rideable_type, member_casual) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

# ride length range
trips %>% 
  group_by(member_casual) %>% 
  summarise(min_length_sec = min(ride_length_sec)
            ,max_length_sec = max(ride_length_sec))

# average ride length by membership status
trips %>% 
  group_by(member_casual) %>% 
  summarise(avg_length_sec = mean(ride_length_sec)) %>% 
  arrange(desc(avg_length_sec))

# number of trips sorted by station
# too many errors to rely upon, needs more complete data
trips %>%
  group_by(start_station_name, member_casual) %>%
  summarise(count = n()) %>%
  mutate(freq_per_station = count/total) %>% 
  arrange(desc(count))

# same table as above broken down into membership status
# casual riders
trips %>%
  group_by(start_station_name) %>%
  filter(member_casual == "casual") %>% 
  summarise(count = n()) %>%
  mutate(total_freq = count/sum(count)) %>% 
  arrange(desc(count))
# members
trips %>% 
  group_by(start_station_name) %>%
  filter(member_casual == "member") %>% 
  summarise(count = n()) %>%
  mutate(total_freq = count/sum(count)) %>%
  arrange(desc(count))
