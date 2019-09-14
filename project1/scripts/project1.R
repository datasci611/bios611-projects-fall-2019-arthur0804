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

# RQ1: Is assistance becoming more nowsdays than before?
# some records are too old, we only consider 2000 to 2018
df_20years <- filter(df, df$year >= 2000 & df$year <= 2018)

ggplot(df_20years, aes(x=year)) + 
  geom_line(stat = "count", color = "red") +
  labs(title ="Number of assistances by year", x = "Year", y = "Number of Assistances") +
  theme_grey()

  



