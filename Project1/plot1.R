## This script is intended to reproduce the first of the four plots as described
## and shown at: https://github.com/rdpeng/ExData_Plotting1

## Setup - Only required once; comment out to expedite development.

## if(!(file.exists("./data") & file.info("./data")$isdir)) dir.create("./data")
## download.file(
##     paste(
##         "https://d396qusza40orc.cloudfront.net/"
##         ,"exdata%2Fdata%2Fhousehold_power_consumption.zip"
##         ,sep = ""
##     )
##     ,destfile = "./data/household_power_consumption.zip"
## )
## write(date(), file = "./data/date_downloaded.txt")
## unzip("./data/household_power_consumption.zip", exdir = "./data")
## file.remove("./data/household_power_consumption.zip")

## Read in the source data.

data <- read.table(
    "./data/household_power_consumption.txt"
    ,header = T
    ,na.strings = "?"
    , sep=";"
)

## Subset out 2007-02-01 and 2007-02-02.

data <- data[data$Date %in% c("1/2/2007", "2/2/2007"),]

## "data" structure:
## [1] "Date" (factor)
## [2] "Time" (factor)
## [3] "Global_active_power" (numeric)
## [4] "Global_reactive_power" (numeric)
## [5] "Voltage" (numeric)
## [6] "Global_intensity" (numeric)
## [7] "Sub_metering_1" (numeric)     
## [8] "Sub_metering_2" (numeric)
## [9] "Sub_metering_3" (numeric)

## Generate the histogram.

png(filename = "./plot1.png", bg = "transparent")
par(mar = c(4.2,3.8,2.3,1.2))
hist(
    data$Global_active_power
    ,main = "Global Active Power"
    ,xlab = "Global Active Power (kilowatts)"
    ,ylab = "Frequency"
    ,col  = "red"
)
dev.off()