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

#Converting Global active power to number so it can be plotted
elec_subset$Global_active_power<-as.numeric(elec_subset$Global_active_power)


#deleting existing file and opening graphic device PNG, I have included also resolution definition
unlink("plot1.png")
png(filename="plot1.png",width=480,height=480,units="px")
#Creating Histogram
hist(elec_subset$Global_active_power,col='red',breaks=20,main="Global Active Power",xlab='Global Acive Power (kilowatts)')
#Closing Graphic device PNG
dev.off()

