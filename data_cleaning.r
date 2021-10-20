library(tidyverse)
library(readxl)

# This script is used to clean the data into a csv file for our app file to reference. 

data <- read_excel('data/raw/StockX-Data-Contest-2019-3.xlsx', sheet = 2)

# Renaming columns
names(data) <- make.names(names(data), unique = TRUE)

# categoricals
data$Sneaker.Name <- as.factor(data$Sneaker.Name)
data$Buyer.Region <- as.factor(data$Buyer.Region)

# new column
data$Sneaker.General.Type <- ifelse(grepl("Yeezy-Boost-350", data$Sneaker.Name), "Adidas Yeezy", 
                            ifelse(grepl("Off-White",  data$Sneaker.Name), "Nike Off White","no"))

data$Sneaker.Specific.Type <- ifelse(grepl("Yeezy-Boost-350", data$Sneaker.Name), "Yeezy", 
                                     ifelse(grepl("Air-Max-90",  data$Sneaker.Name), "Air Max 90",
                                            ifelse(grepl("VaporMax", data$Sneaker.Name), "VaporMax",
                                                   ifelse(grepl("Air-Presto", data$Sneaker.Name), "Air Presto",
                                                          ifelse(grepl("Air-Jordan-1", data$Sneaker.Name), "Air Jordan 1",
                                                                 ifelse(grepl("Blazer", data$Sneaker.Name), "Blazer",
                                                                        ifelse(grepl("Air-Force", data$Sneaker.Name),"Air Force 1",
                                                                               ifelse(grepl("Air-Max-97", data$Sneaker.Name),"Air Max 97",
                                                                                      ifelse(grepl("Hyperdunk", data$Sneaker.Name),"Hyperdunk 2017",
                                                                                             ifelse(grepl("Zoom-Fly", data$Sneaker.Name),"Zoom Fly","no"))))))))))
data$Order.Year.Month <- format(as.Date(data$Order.Date), "%Y-%m")

write.csv(data, "data/processed/cleaned_stockX_data.csv", row.names = FALSE)