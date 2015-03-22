## This script is intended to produce the sixth of six plots as described in
## https://class.coursera.org/exdata-012/human_grading/view/courses/973506
## /assessments/4/submissions

## Question 6:
## Compare emissions from motor vehicle sources in Baltimore City with emissions
## from motor vehicle sources in Los Angeles County, California
## (fips == "06037"). Which city has seen greater changes over time in motor
## vehicle emissions?

library(plyr)
library(dplyr)
library(ggplot2)

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
## The regular expression used below will match on any "Short.Name" containing
## either character of the character strings "motor" or "vehicle" case-
## insensitively.

pData <- data %>%
    filter(fips %in% c("24510","06037") &
        grepl("motor|vehicle", Short.Name, ignore.case = T)
    ) %>%
    select(fips, year, Emissions) %>%
    group_by(fips, year) %>%
    summarize(sum(Emissions))

## Reset the plot data names and "fips" values to facilitate selection and
## display in the plot.

names(pData) <- c("fips", "year", "Emissions")

pData$fips <- mapvalues(
    pData$fips
    ,c("24510", "06037")
    ,c("Baltimore City", "Los Angeles County")
)

## Create the plot.

png(filename = "./plot6.png")

plot <- qplot(
    year
    ,Emissions
    ,data = pData
    ,geom = c("point", "line")
    ,color = fips
    ,main = paste0(
        "Baltimore City and Los Angeles County\n"
        ,"Motor Vehicle PM2.5 Emissions by Year"
    )
    ,xlab = "Year"
    ,ylab = "PM2.5 Emissions (Tons)"
) + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(color = "Emission Source") +
    geom_errorbar(
        aes(
            x = min(pData$year - .25)
            ,ymax = max(pData[pData$fips == "Los Angeles County", "Emissions"])
            ,ymin = min(pData[pData$fips == "Los Angeles County", "Emissions"])
            ,width = .25
        )
        ,color = "#00BFC4"
    ) +
    geom_errorbar(
        aes(
            x = max(pData$year + .25)
            ,ymax = max(pData[pData$fips == "Baltimore City", "Emissions"])
            ,ymin = min(pData[pData$fips == "Baltimore City", "Emissions"])
            ,width = .25
        )
        ,color = "#F8766D"
    ) +
    geom_segment(
        aes(
            x = 2003
            ,xend = min(pData$year - .25)
            ,y = 1025
            ,yend = (
                max(pData[pData$fips == "Los Angeles County", "Emissions"]) -
                min(pData[pData$fips == "Los Angeles County", "Emissions"])
            ) /2 + min(pData[pData$fips == "Los Angeles County", "Emissions"])              
        )
        ,color = "black"
    ) +
    geom_segment(
        aes(
            x = 2004
            ,xend = max(pData$year + .25)
            ,y = 195
            ,yend = (
                max(pData[pData$fips == "Baltimore City", "Emissions"]) -
                min(pData[pData$fips == "Baltimore City", "Emissions"])
            ) /2 + min(pData[pData$fips == "Baltimore City", "Emissions"])
        )
        ,color = "black"
    ) +
    annotate(
        "text"
        ,label = "Los Angeles County drop of\n~509 tons of emissions per year"
        ,x = 2003
        ,y = 975
        ,size = 4
    ) +
    annotate(
        "text"
        ,label = "Baltimore City drop of\n~48 tons of emissions per year"
        ,x = 2004
        ,y = 265
        ,size = 4
    )

print(plot)

dev.off()