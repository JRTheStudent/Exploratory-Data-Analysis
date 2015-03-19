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

pData <- data[data$fips == 24510, c("Emissions", "type", "year")]
pData <- pData %>% group_by(year, type) %>% summarize(sum(Emissions))
names(pData) <- c("year", "type", "Emissions")

png(filename = "./plot3.png")
plot <- qplot(
    year
    ,Emissions
    ,data = pData
    ,geom = c("point", "smooth")
    ,method = "lm"
    ,se = F
    ,color = type
    ,main = "Total Baltimore City PM2.5 Emissions by Year and Type"
    ,xlab = "Year"
    ,ylab = "Total PM2.5 Emissions (Tons)"
)
plot <- plot + theme(axis.text.x = element_text(angle = 45, hjust = 1))
plot + labs(color = "Emission Source")
dev.off()