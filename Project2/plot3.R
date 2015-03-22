## This script is intended to produce the third of six plots as described in
## https://class.coursera.org/exdata-012/human_grading/view/courses/973506
## /assessments/4/submissions

## Question 3:
## Of the four types of sources indicated by the type (point, nonpoint, onroad,
## nonroad) variable, which of these four sources have seen decreases in
## emissions from 1999–2008 for Baltimore City? Which have seen increases in
## emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
## answer this question.

library(plyr)
library(dplyr)
library(ggplot2)
library(grid)

## Setup - only required once; comment out to expedite development.

## if(!(file.exists("./data") & file.info("./data")$isdir)) dir.create("./data")
## sFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
## dFile <- "./data/NEI_data.zip"
## download.file(sFile, destfile = dFile)
## write(date(), file = "./data/date_downloaded.txt")
## unzip(dFile, exdir = "./data")
## file.remove(dFile)

## Read in the data by joining the data sets on "SCC."

data <- join(
    readRDS("./data/summarySCC_PM25.rds")
    ,readRDS("./data/Source_Classification_Code.rds")
    ,by = "SCC"
)

## Create plot data via filter, select, group_by and summarize (all from dplyr).

pData <- data %>%
    filter(fips == "24510") %>%
    select(year, type, Emissions) %>%
    group_by(year, type) %>%
    summarize(sum(Emissions))

## Reset the plot data names to facilitate selection and display in the plot.

names(pData) <- c("year", "type", "Emissions")

## Order plot data for more logical groupings in the plot.

pData$type <- factor(
    pData$type
    ,levels = c("POINT", "NONPOINT", "ON-ROAD", "NON-ROAD")
)
pData <- pData[do.call(order,pData[c("year", "type")]),]

## Create the plot.

png(filename = "./plot3.png")

plot <- qplot(
    year
    ,Emissions
    ,data = pData
    ,geom = c("point", "line")
    ,color = type
    ,main = "Baltimore City Total PM2.5 Emissions by Year and Type"
    ,xlab = "Year"
    ,ylab = "PM2.5 Emissions (Tons)"
) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(color = "Emission Source") +
    geom_segment(
        aes(
            x = 2005
            ,xend = 2007.95
            ,y = 1800
            ,yend = as.numeric(
                pData[pData$type == "POINT" & pData$year == "2008", "Emissions"]
                + 50
            )
        )
        ,arrow = arrow(angle = 20, length = unit(.1, "inches"))
        ,color = "black"
    ) + annotate(
        "text"
        ,label = paste0(
            "Type POINT increased by ~49 tons per year\n"
            ,"while all others types decreased"
        )
        ,x = 2004.5
        ,y = 1900
        ,size = 4
    )
    
print(plot)

dev.off()