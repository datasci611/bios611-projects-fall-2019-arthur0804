library(tidyverse)
library(ggplot2)

#-----------------------Data Importing-----------------------
# read the file
setwd("/Users/jiamingqu/Desktop/BIOS 611/project/bios611-projects-fall-2019-arthur0804/project1/")
df <- read_delim("data/UMD_Services_Provided_20190719.tsv", delim="\t")

#-----------------------Data Cleaning-----------------------
# extract useful columns, i.e. remove field 1/2/3
df <- df[,1:15]

# convert the column from character to date
df$Date <- as.Date(df$Date, "%m/%d/%Y")

# remove invalid rows with date in the future
df <- filter(df, df$Date <= Sys.Date())

# add a column of the year
df$year <- as.numeric(format(df$Date,'%Y'))

#-----------------------Data Analysis-----------------------
# first get a summary of the data frame
summary(df)

# some records are too old, we only consider 2000 to 2018
df_20years <- filter(df, df$year >= 2000 & df$year <= 2018)

# RQ1: Is assistance becoming more nowsdays than before?
ggplot(df_20years, aes(x=year)) + 
  geom_line(stat = "count", color = "red") +
  labs(title ="Amount of assistances by year", x = "Year", y = "Amount of Assistances") +
  theme_grey()

## RQ2: Which family/individual received the most assistance from 2000 to 2018?
df_clients <- select(df_20years, c(2,16))
colnames(df_clients)[1] <- "ClientFileNumber"

# create a empty data frame to store the result
df_clients_result <- data.frame(matrix(ncol = 3, nrow = 0))
x <- c("ClientFileNumber", "Count", "Year")
colnames(df_clients_result) <- x

# loop over each year
for (i in 2000:2018){
  # extract the record for a year
  df_clients_year <- filter(df_clients, df_clients$year == i)
  # count the amount by each unique id and then sort
  result <- arrange(df_clients_year %>% count(ClientFileNumber), desc(n))
  # add into the data frame
  df_clients_result[nrow(df_clients_result) + 1,] = c(result[1,1],result[1,2], i)
}

df_clients_result

# RQ3: Which kind of service are given the most or least?


