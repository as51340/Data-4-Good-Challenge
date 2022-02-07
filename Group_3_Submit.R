# D4GC - Group 3 - Andi, Pawel, Amit, Pankaj

# Libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

data4_no_na_co2 <- read_excel("C:/Users/panka/OneDrive/Desktop/D4GC/d4gc-datasets-download/d4_co2_no_na.xlsx")
total_co2_per_country <- as.data.frame(sapply(split(data4_no_na_co2$co2, data4_no_na_co2$country), sum))
colnames(total_co2_per_country) <- "Total_CO2"
total_co2_overall <- sum(total_co2_per_country) # 1315069
share_co2_per_country <- total_co2_per_country/total_co2_overall
data_co2_per_country <- data.frame(total_co2_per_country, )
class(total_co2_per_country)
x <- as.vector(total_co2_per_country)
View(total_co2_per_country)

total_co2_per_country[1][1]
write.table(total_co2_per_country, file = "f1.txt")

setwd("C:/Users/panka/OneDrive/Desktop/D4GC/d4gc-datasets-download")
x <- data.frame(total_co2_per_country[,1])
write.table(x, file = "f2.txt")

co2 <- read_excel("Overall.xlsx")
colnames(co2) <- c("Country","Total_CO2_from_1960_to_2019")
co2$share <- co2$Total_CO2_from_1960_to_2019/total_co2_overall * 100
top_10_data <- as.data.frame(head(arrange(co2,desc(share)), n = 10))
top_10_data$Country[9] <- "UAE"
top_10_data$Country <- factor(top_10_data$Country, levels = top_10_data$Country)
top_10_countries <- c(top_10_data[1]) # Top 10 CO2 emitters in last ~60 years

ggplot(top_10_data, aes(x = Country, y = share, colour = Country, level = share)) +
  labs(x = "Country", y = "Total CO2 Share as %") + 
  labs(title = "Top CO2 Emitters | 1960 - 2019") + theme_bw() + geom_point(size = 2.5) + geom_text(aes(label=Country, size = 2),hjust=0, vjust=0)

tas_data_top_co2 <- read_excel("C:/Users/panka/OneDrive/Desktop/D4GC/d4gc-datasets-download/Final_TAS.xlsx")
View(tas_data_top_co2)
ggplot(data = tas_data_top_co2) +  geom_line(aes(x = Country, y = TAS))

