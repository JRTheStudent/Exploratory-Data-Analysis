## This script is intended to produce the first of six plots as described in
## https://class.coursera.org/exdata-012/human_grading/view/courses/973506
## /assessments/4/submissions

## Question 1:
## Have total emissions from PM2.5 decreased in the United States from 1999 to 
## 2008? Using the base plotting system, make a plot showing the total PM2.5 
## emission from all sources for each of the years 1999, 2002, 2005, and 2008.

library(plyr)
library(dplyr)

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
    select(Emissions, year) %>%
    group_by(year) %>%
    summarize(sum(Emissions))

names(pData) <- c("year", "Emissions")

png(filename = "./plot1.png")
plot(
    pData$year
    ,pData$Emissions
    ,main = "Total U.S. PM2.5 Emissions by Year"
    ,xlab="Year"
    ,ylab="Total PM2.5 Emissions (Tons)"
)
abline(lm(Emissions ~ year, pData), col = "blue")
legend(
    "topright"
    ,legend = c("PM 2.5", "Linear Model")
    ,text.col = "black"
    ,lty = c(0,1)
    ,pch = c(1,NA)
    ,col = c("black", "blue")
)
dev.off()