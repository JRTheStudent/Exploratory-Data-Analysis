## This script is intended to reproduce the second of the four plots as
## described and shown at: https://github.com/rdpeng/ExData_Plotting1

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

## "Date" column contains %d/%m/%Y and "Time" contains %H:%M%S.
## Combine and coerce into POSIXlt.

data$Date <- strptime(
    paste(
        data$Date
        ,data$Time
        ,sep=" "
    )
    ,format = "%d/%m/%Y %H:%M:%S"
)

## Remove the "Time" column as it is now superflous.

data <- data[-2]

## "data" structure:
## [1] "Date" (POSIXlt)                  
## [2] "Global_active_power" (numeric)
## [3] "Global_reactive_power" (numeric)
## [4] "Voltage" (numeric)
## [5] "Global_intensity" (numeric)
## [6] "Sub_metering_1" (numeric)     
## [7] "Sub_metering_2" (numeric)
## [8] "Sub_metering_3" (numeric)

## Generate the plot.

png(filename = "./plot2.png", bg = "transparent")
par(mar = c(4.2,3.9,3.2,1.2))
plot(
    data$Date
    ,data$Global_active_power
    ,xlab = ""
    ,ylab = "Global Active Power (kilowatts)"
    ,type = "l"
)
dev.off()