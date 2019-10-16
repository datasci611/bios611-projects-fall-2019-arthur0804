library(shiny)
library(ggplot2)
library(tidyverse)

# -----------------------------data importing and cleaning-----------------------------

df <- read_delim("data/UMD_Services_Provided_20190719.tsv", delim="\t")

# extract useful columns (remove column "field 1/2/3")
df <- df[,1:15]
# convert the datatype from character to date
df$Date <- as.Date(df$Date, "%m/%d/%Y")
# remove invalid rows with date in the future
df <- filter(df, df$Date <= Sys.Date())
# add a column of year from date
df$year <- as.numeric(format(df$Date,'%Y'))
# rename columns (remove the spaces in column names)
names(df) <- c('Date','ClientFileNumber', 'ClientFileMerge','BusTickets',
               'NotesofService','FoodProvidedfor', 'FoodPounds',
               'ClothingItems', 'Diapers', 'SchoolKits', 'HygieneKits',
               'Referrals', 'FinancialSupport', 'TypeofBill',
               'PayerofSupport','year')

# -----------------------------functions-----------------------------

# generate the text on the first page
generate_about_info <- function(selection){
    if(selection == 1){
        return(c("The data set is kindly provided by Urban Ministries of Druham, which records their assistance and help to people each year in different kinds of services, 
               e.g., food, clothing, hygiene kits and etc.", "In this project, we analyze how the service scale changes over time, from both general and specific aspect."))
    }else if (selection == 2){
        return(c("RQ1: How does our program grow in general?", 
                 "RQ2: How does our program reach out to new clients?", 
                 "RQ3: How does each kind of service develop over time?"))
    }else{
        return(c("Jiaming Qu", "School of Information and Library Science, UNC-Chapel Hill", "jiaming@ad.unc.edu", "jiamingqu.com"))
    }
}

# generate the summary info on the second page
generate_data_summary <- function(year1, year2){
    df_filter <- df %>% filter(year >= year1 & year <= year2)
    return(summary(df_filter))
}

# generate the overview plot for rq1
generate_rq1_plot <- function(year1, year2, selection){
    
    # first filter the data
    df_filter <- df %>% filter(year >= year1 & year <= year2)
    
    # in regards of total assitances each year
    df_assistance <- df_filter %>% group_by(year) %>% 
        summarise(assistances = n())
    
    # in regards of clients each year
    df_client <- df_filter %>% group_by(year) %>% 
        summarise(clients = length(unique(ClientFileNumber)))
    
    if(selection == 1){ # show assistances
        ggplot(df_assistance, aes(x=year, y = assistances)) + 
            geom_line() +
            labs(title ="Amount of assistances we give each year", 
                 x = "Year", y = "Count") +
            theme_grey()
    }else if (selection == 2){ # show clients
        ggplot(df_client, aes(x=year, y = clients)) + 
            geom_line() +
            labs(title ="Amount of clients we help each year", 
                 x = "Year", y = "Count") +
            theme_grey()
    }else{ # show both
        # join together
        df_assistance_client <- inner_join(df_assistance, df_client, by = "year")
        # gather
        df_assistance_client <- df_assistance_client %>% gather(type, count, c(assistances, clients)) 
        ggplot(df_assistance_client, aes(x=year, y = count, color = type)) + 
            geom_line() +
            labs(title ="Amount of Assistances and Clients each year (2000-2018)", 
                 x = "Year", y = "Count", color = "Total Amount Of") +
            theme_grey()
    }
}

# generate the overview plot for rq2
generate_rq2_plot <- function(year1, year2){
    
    # first filter the data
    df_filter <- df %>% filter(year >= year1 & year <= year2)
    # select corresponding columns
    df_clients <- select(df_filter, c(2,16))
    #create a data frame to store the result
    df_new_clients <- data.frame(matrix(ncol = 2, nrow = 0))
    x <- c("NewClients", "Year")
    colnames(df_new_clients) <- x
    
    # loop over each year
    for (i in year1:year2){
        # extract the record for this year
        df_clients_this_year <- filter(df_clients, df_clients$year == i)
        # get the unique client numbers of this year
        count_this_year <- unique(df_clients_this_year$ClientFileNumber)
        # extract the record for past years
        df_clients_past_year <- filter(df_clients, df_clients$year < i)
        # get the unique client numbers of this year
        count_past_year <- unique(df_clients_past_year$ClientFileNumber)
        # append count of new clients to the dataframe
        new_clients_count = length(setdiff(count_this_year, count_past_year))
        df_new_clients[nrow(df_new_clients) + 1,] = c(new_clients_count, i)
    }
    
    # plot
    ggplot(df_new_clients, aes(x = Year, y = NewClients)) +
        geom_bar(stat = "identity") + 
        geom_text(aes(label=NewClients), vjust= -0.5) + 
        labs(title ="Amount of New Clients each year", x = "Year", 
             y = "Amount of New Clients") +
        theme_grey()
}

# generate the plots for rq3
generate_rq3_plot <- function(year1, year2, selection, color_choice){
    
    # first filter the data
    df_filter <- df %>% filter(year >= year1 & year <= year2)
    
    # select the variable
    if(selection == 1){
        variable <- "FoodPounds"
    }else if(selection == 2){
        variable <- "ClothingItems"
    }else if(selection == 3){
        variable <- "Diapers"
    }else if(selection == 4){
        variable <- "SchoolKits"
    }else{
        variable <- "HygieneKits"
    }
    
    if(color_choice == 1){
        color_variable = "red"
    }else if(color_choice == 2){
        color_variable = "blue"
    }else if(color_choice == 3){
        color_variable = "green"
    }else if(color_choice == 4){
        color_variable = "yellow"
    }else if(color_choice == 5){
        color_variable = "black"
    }
    
    # prepare the data
    df_subset <- df_filter %>% select(variable, year)
    df_subset <- df_subset %>% drop_na(variable)
    m <- aggregate(df_subset[[variable]] ~ df_subset$year, df_subset, mean)
    colnames(m) <- c('year', 'average')
    c <- data.frame(table(df_subset$year))
    colnames(c) <- c('year', 'count')
    m[["count"]] <- c[["count"]]
    comparision <-  m
    
    # plot
    ggplot(comparision, aes(x=year, y=average)) + 
        geom_point(aes(size = count), color = color_variable) +
        labs(title = paste("Average ", variable, " Per Assistance each year"), x = "Year", 
             y = paste("Average ", variable, " Per Assist")) +
        geom_path(linetype = 2) + 
        theme_grey()
}

