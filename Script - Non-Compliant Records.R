##################################################################################
########################## SET WORKSPACE #########################################
##################################################################################

###Set working directory and install Excel package
setwd("C:\\Users\\jmartel71\\Documents\\R")
install.packages("openxlsx", dependencies=TRUE)
getwd()
list.files()

##################################################################################
########################## CREATE DATAFRAME ######################################
##################################################################################

###Load Portfolio Manager ouput data which has column headings and starts on row 5
library(openxlsx)
mydata <- read.xlsx("2015FinalDataset.xlsx", colNames = TRUE, startRow = 5, check.names = FALSE)
###View dataframe by double-clicking in the global environment

##################################################################################
########################## PRE-PROCESSING ########################################
##################################################################################

###Deal with wierd characters first
#Remove superscript from square feet in column headings/replace with sqft
names(mydata) <- gsub("ft²","sqft", names(mydata), fixed = TRUE)
#Remove - from column headings
names(mydata) <- gsub("-","", names(mydata), fixed = TRUE)
#Remove . from column headings
names(mydata) <- gsub(".","", names(mydata), fixed = TRUE)
#Remove () from column headings
names(mydata) <- gsub("(","", names(mydata), fixed = TRUE)
names(mydata) <- gsub(")","", names(mydata), fixed = TRUE)
#Remove / from column headings
names(mydata) <- gsub("/","", names(mydata), fixed = TRUE)

###Rename long variables names
install.packages("reshape", dependencies=TRUE)
library(reshape)
mydata <- rename(mydata, c(PropertyGFASelfReportedsqft="SqFt"))
mydata <- rename(mydata, c(WaterUseAllWaterSourceskgal="WaterUsekGal"))                      
mydata <- rename(mydata, c(DirectGHGEmissionsMetricTonsCO2e="DirectGHG"))                  
mydata <- rename(mydata, c(IndirectGHGEmissionsMetricTonsCO2e="IndirectGHG"))                
mydata <- rename(mydata, c(DirectGHGEmissionsIntensitykgCO2esqft="DirectGHGSqFt"))
mydata <- rename(mydata, c(IndirectGHGEmissionsIntensitykgCO2esqft="IndirectGHGSqFt"))  
mydata <- rename(mydata, c(WeatherNormalizedSiteEnergyUsekBtu="WeatherSiteEnergykBTU")) 
mydata <- rename(mydata, c(WeatherNormalizedSourceEnergyUsekBtu="WeatherSourceEnergykBTU"))             
mydata <- rename(mydata, c(WeatherNormalizedSiteEUIkBtusqft="WeatherSiteEUIkBTU"))
mydata <- rename(mydata, c(WeatherNormalizedSourceEUIkBtusqft="WeatherSourceEUIkBTU" ))

##################################################################################
###View data types using sapply/sapply is a grouping function/group by class
sapply(mydata, class)
###Change data types as needed; all were characters except time and date, numeric
#Change data types to numeric
mydata[, c("PropertyId", 
           "ParentPropertyId",  
           "PostalCode",
           "SqFt",                    
           "EstimatedValuesEnergy",                                
           "EstimatedValuesWater",                                
           "SiteEnergyUsekBtu",                                 
           "SourceEnergyUsekBtu",                               
           "SiteEUIkBtusqft",                                  
           "SourceEUIkBtusqft",                                
           "WaterUsekGal",                     
           "DirectGHG",                  
           "IndirectGHG",                
           "DirectGHGSqFt",            
           "IndirectGHGSqFt",          
           "WeatherSiteEnergykBTU",                
           "WeatherSourceEnergykBTU",              
           "WeatherSiteEUIkBTU",                 
           "WeatherSourceEUIkBTU",               
           "ENERGYSTARScore",                                     
           "YearBuilt")] <- sapply(mydata[, c("PropertyId", 
                                              "ParentPropertyId",  
                                              "PostalCode",
                                              "SqFt",                    
                                              "EstimatedValuesEnergy",                                
                                              "EstimatedValuesWater",                                
                                              "SiteEnergyUsekBtu",                                 
                                              "SourceEnergyUsekBtu",                               
                                              "SiteEUIkBtusqft",                                  
                                              "SourceEUIkBtusqft",                                
                                              "WaterUsekGal",                     
                                              "DirectGHG",                  
                                              "IndirectGHG",                
                                              "DirectGHGSqFt",            
                                              "IndirectGHGSqFt",          
                                              "WeatherSiteEnergykBTU",                
                                              "WeatherSourceEnergykBTU",              
                                              "WeatherSiteEUIkBTU",                 
                                              "WeatherSourceEUIkBTU",               
                                              "ENERGYSTARScore",                                    
                                              "YearBuilt")], as.numeric)

##################################################################################
################### NON-COMPLIANT RECORDS - NYC DATA QUALITY REVIEW ##############
##################################################################################

###Subset variables required by Ordinance to find missing and inaccurate values and Portfolio Manager Alerts 
#Subset only buildings over 10,000 square feet
#Do not include direct GHG emissions, or weather or size normalizations
#recode NA values to zero
mydata[is.na(mydata)] <- FALSE
missingvalues_dataframe <- subset(mydata, 
                                     SqFt>10000 & 
                                     ParentPropertyId==0)
missingvalues2_dataframe <- subset(missingvalues_dataframe,
                                     KansasCityBuildingReportingID=="Not Available" |
                                     SqFt==0 |
                                     SiteEnergyUsekBtu==0 |
                                     SourceEnergyUsekBtu==0 |
                                     SiteEnergyUsekBtu==0 |
                                     SourceEnergyUsekBtu==0 |
                                     WaterUsekGal==0 |              
                                     IndirectGHG==0 |
                                     YearBuilt<1901 |
                                     AlertDataCenterdoesnothaveanITMeter=="Possible Issue" |
                                     AlertIndividualmonthlymeterentryismorethan65dayslong=="Possible Issue" |
                                     AlertMeterhasoverlaps=="Possible Issue" |
                                     AlertMeterhasgaps=="Possible Issue" |
                                     AlertMeterhaslessthan12fullcalendarmonthsofdata=="Possible Issue" |
                                     AlertNometersareassociatedwiththisproperty=="Possible Issue" |
                                     AlertPropertyhasnouses=="Possible Issue")
#Save non-compliant records to a file
library(openxlsx)
write.table(missingvalues2_dataframe, file="non-compliant.xls", quote = FALSE, sep = "\t", col.names = TRUE, row.names = FALSE)