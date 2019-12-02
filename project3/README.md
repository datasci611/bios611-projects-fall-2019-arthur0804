# Project 3 - 2019 Fall BIOS 611

## Background

This dataset is provided by the Urban Ministries of Durham, which is a non-profit organization aiming to help the community and fight poverty and homelessness. It provides dataset of its clients in terms of assistance records and other information. In this project, we aim to use these datasets to explore how the program reaches out to people.

## Dataset Overview

A lot of datasets are provided, but we select some of interest for this project. Here are two datasets for this project as shown below:

1. CLIENT_191102.tsv: Demographic information of the clients, e.g., ID, gender, age, race.
2. ENTRY_EXIT_191102.tsv: Clients' entries and exits, e.g., dates, destination, reasons.

## Research Question
*Demographic data analysis
    *age, gander, race
*Behavioral data analysis
    *length of stay, frequency of return, destination after leaving
*Program data analysis
    *program growth

## Run this project
To run this project, simple run the following in the command line.

```
make result/Project3.html
```

Note that the output **Project3.html** file will be under the **result** folder. And if it already exists, a message will be shown that the file is already up-to-date. If you want to produce the html file via the Makefile, simple remove the file and run the command again.
