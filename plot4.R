# Steps:
#1. Download the datafile, save as temp, unzip and read the data from txt file
#2. Subset the data
#3. Delete already exisitng png & produce the new png 

#Creating temp file
temp <- tempfile()
#Downloading the zip file and saving it as temp file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
#creating data frame from txt file unzipped from downloaded file
elec<- read.table(unz(temp, "household_power_consumption.txt"),header=TRUE,sep=";", na.strings="?",stringsAsFactors=FALSE)
#Dropping the temp file
unlink(temp)

#Subsetting the data to include just 2 defined days
#First, I convert the Date to data data type to able to compare 
elec$Date<-as.Date(elec$Date, ,format='%d/%m/%Y')
startDate = as.Date("2007-02-01");
endDate = as.Date("2007-02-02");
#Creating new data frame which is subset of original data frame
elec_subset<-subset(elec,elec$Date>=startDate & elec$Date<=endDate)

#creating timestamp=date+time
elec_subset$timestamp<-c(paste(elec_subset$Date,' ',elec_subset$Time))
elec_subset$timestamp<-as.POSIXlt(strptime(elec_subset$timestamp, format='%Y-%m-%d %H:%M:%S'))

#Converting variables to numeric so they can be plotted
elec_subset$Global_active_power<-as.numeric(elec_subset$Global_active_power)
elec_subset$Global_reactive_power<-as.numeric(elec_subset$Global_reactive_power)
elec_subset$Voltage<-as.numeric(elec_subset$Voltage)
elec_subset$Sub_metering_3<-as.numeric(elec_subset$Sub_metering_3)
elec_subset$Sub_metering_2<-as.numeric(elec_subset$Sub_metering_2)
elec_subset$Sub_metering_1<-as.numeric(elec_subset$Sub_metering_1)


#Changing language/locale settings so days on X axis are shown in English
Sys.setlocale("LC_TIME", "English")


#deleting existing file and opening graphic device PNG, I have included also resolution definition
unlink("plot4.png")
png(filename="plot4.png",width=480,height=480,units="px")
#changing parameters of png to include 4 plots
  par(mfrow=c(2,2))
#Creating plot 1
  plot(elec_subset$timestamp,elec_subset$Global_active_power,type='l',xlab='datetime',ylab='Global Acive Power')
#Creating plot 2
  plot(elec_subset$timestamp,elec_subset$Voltage,type='l',xlab='',ylab='Voltage')
#Creating Plot 3
  plot(elec_subset$timestamp,elec_subset$Sub_metering_1,type='l',xlab='',ylab='Energy  sub metering')
  lines(elec_subset$timestamp,elec_subset$Sub_metering_2,col="red")
  lines(elec_subset$timestamp,elec_subset$Sub_metering_3,col="blue")
  legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1),col=c("black","red","blue"))
#Creating Plot 4
  plot(elec_subset$timestamp,elec_subset$Global_reactive_power,type='l',xlab='datetime',ylab='Global_reactive_power')
#Closing Graphic device PNG
dev.off()

