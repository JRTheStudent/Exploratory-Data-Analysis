## This script is intended to produce the fourth of six plots as described in
## https://class.coursera.org/exdata-012/human_grading/view/courses/973506
## /assessments/4/submissions

## Question 4:
## Across the United States, how have emissions from coal combustion-related
## sources changed from 1999–2008?

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

## Define the Perl-compatible regular expression to filter on any "Short.Name" 
## containing the character strings "coal" or "comb" (somtimes used in the data 
## set as the abbreviation for "combustion").  This regular expression (along
## with the "ignore.case = T" parameter used in grepl) will match on any
## "Short.Name" containing both of these strings in either order 
## case-insensitively.

regExp <- "(?=.*coal)(?=.*comb)"

## Create plot data via filter, select, group_by and summarize (all from dplyr).

pData <- data %>%
    filter(grepl(regExp, Short.Name, ignore.case = T, perl = T)) %>%
    select(year, Emissions) %>%
    group_by(year) %>%
    summarize(sum(Emissions))

## Reset the plot data names to facilitate selection and display in the plot.

names(pData) <- c("year", "Emissions")

## Create the plot.

png(filename = "./plot4.png")

qplot(
    year
    ,Emissions
    ,data = pData
    ,geom = c("point", "smooth")
    ,method = "lm"
    ,se = F
    ,main = "Total U.S. Coal Combustion PM2.5 Emissions by Year"
    ,xlab = "Year"
    ,ylab = "Total U.S. Coal Combustion PM2.5 Emissions (Tons)"
) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

dev.off()