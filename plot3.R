

## Download and unzip the data file to be used
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","household_power_consumption.zip",mode = "wb")
unzip("household_power_consumption.zip")
unlink("household_power_consumption.zip")

## Create a data frame object to hold the data

# Find the location of the first date/time observation we are interested in
startPos <- grep("1/2/2007;00:00:00",readLines("household_power_consumption.txt"))[1]

# Find the location of the last date/time observation we are interested in
endPos <- grep("2/2/2007;23:59:00",readLines("household_power_consumption.txt"))[1]

#set the column names for the dataframe since we will not be reading in the header
columnNames <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
columnClasses <- c(NA,NA,rep("numeric",7))
# Create the data frame to hold our observations
energyUsageData <- read.table("household_power_consumption.txt",
                              skip = startPos-1,
                              nrows = endPos-startPos,
                              sep = ";", 
                              dec = ".",
                              na.strings = "?",
                              colClasses = columnClasses,
                              col.names = columnNames,
                              stringsAsFactors = FALSE)

energyUsageData$Date <- as.Date(energyUsageData$Date,"%d/%m/%Y")

energyUsageData$dateTime <- as.POSIXct(paste(energyUsageData$Date,energyUsageData$Time),format = "%Y-%m-%d %H:%M:%S")

# Create the output image file and write the plot to that file
png(filename="plot3.png")

with(energyUsageData,plot(dateTime,Sub_metering_1,ylab = "Energy sub meetering",type = "l",col="black",xlab = ""))
par(new=T)
with(energyUsageData,lines(dateTime,Sub_metering_2,col="red"))
with(energyUsageData,lines(dateTime,Sub_metering_3,col="blue"))

legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),lwd=c(2,2,2),col = c("black","red","blue"))
dev.off()