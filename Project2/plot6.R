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
library(grid)

## Setup - only required once; comment out to expedite development.

## if(!(file.exists("./data") & file.info("./data")$isdir)) dir.create("./data")
## sFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
## dFile <- "./data/NEI_data.zip"
## download.file(sFile, destfile = dFile)
## write(date(), file = "./data/date_downloaded.txt")
## unzip(dFile, exdir = "./data")
## file.remove(dFile)

data <- join(
    readRDS("./data/summarySCC_PM25.rds")
    ,readRDS("./data/Source_Classification_Code.rds")
    ,by = "SCC"
)

pData <- data %>%
    filter(fips %in% c("24510","06037") &
        grepl("motor|vehicle", Short.Name, ignore.case = T)
    ) %>%
    select(fips, year, Emissions) %>%
    group_by(fips, year) %>%
    summarize(sum(Emissions))

names(pData) <- c("fips", "year", "Emissions")

pData$fips <- mapvalues(
    pData$fips
    ,c("24510", "06037")
    ,c("Baltimore City", "Los Angeles County")
)

main <- paste0("Baltimore City and Los Angeles County\n"
    ,"PM2.5 Motor Vehicle Emissions by Year"
)
png(filename = "./plot6.png")
plot <- qplot(
    year
    ,Emissions
    ,data = pData
    ,geom = c("point", "smooth")
    ,method = "lm"
    ,se = F
    ,color = fips
    ,main = main
    ,xlab = "Year"
    ,ylab = "PM2.5 Motor Vehicle Emissions (Tons)"
)
plot + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme(plot.title = element_text(hjust = 0.5)) +
    labs(color = "Emission Source")
dev.off()