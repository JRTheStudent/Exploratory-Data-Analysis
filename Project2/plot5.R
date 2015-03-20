## This script is intended to produce the fifth of six plots as described in
## https://class.coursera.org/exdata-012/human_grading/view/courses/973506
## /assessments/4/submissions

## Question 5:
## How have emissions from motor vehicle sources changed from 1999–2008 in
## Baltimore City?

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

data <- join(
    readRDS("./data/summarySCC_PM25.rds")
    ,readRDS("./data/Source_Classification_Code.rds")
    ,by = "SCC"
)
pData <- data[data$fips == 24510,]
pData <- data[
    grep("motor|vehicle", data$Short.Name, ignore.case = T)
    ,c("Emissions", "year")
    ]

pData <- pData %>% group_by(year) %>% summarize(sum(Emissions))
names(pData) <- c("year", "Emissions")

png(filename = "./plot5.png")
plot <- qplot(
    year
    ,Emissions
    ,data = pData
    ,geom = c("point", "smooth")
    ,method = "lm"
    ,se = F
    ,main = "Baltimore City PM2.5 Motor Vehicle Emissions by Year"
    ,xlab = "Year"
    ,ylab = "Baltimore City PM2.5 Motor Vehicle Emissions (Tons)"
)
plot + theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()