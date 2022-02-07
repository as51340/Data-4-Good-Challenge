library(openxlsx)

data_1 <- read.csv("Dataset 1 - Climate Change.csv")
data_2 <- read.csv("Dataset 2 - Sea Level Change.csv")
data_3 <- read.csv("Dataset 3 - Economic _ Demographic Indicators.csv")
data_4 <- read.csv("Dataset 4 - Emissions _ Energy Consumption.csv")
data_5 <- read.csv("Dataset 5 - ISSP Survey.csv")

variance <- c()
maximum <- c()
minimum <- c()
for (i in 1:157) {
  df <- data_1[data_1[, 1] == unique(data_1[, 1])[i], ]
  variance <- append(variance, var(df$sfcwind, na.rm = TRUE))
  maximum <- append(maximum, max(df$sfcwind, na.rm = TRUE))
  minimum <- append(minimum, min(df$sfcwind, na.rm = TRUE))
}


df_summary <- data.frame(unique(data_1[, 1]), variance, maximum, minimum)

min_from_max <- c()
max_from_min <- c()
for (i in 1:157) {
  df <- data_1[data_1[, 1] == unique(data_1[, 1])[i], ]
  wm <- which.max(df$tas)
  wm <- df[wm, ]$yearmonth
  wm <- substring(wm, first = 6, last = 7)
  df <- df[substring(df$yearmonth, first = 6, last = 7) == wm, ]
  min_from_max <- append(min_from_max, min(df$tas, na.rm = TRUE))

  df <- data_1[data_1[, 1] == unique(data_1[, 1])[i], ]
  wm <- which.min(df$tas)
  wm <- df[wm, ]$yearmonth
  wm <- substring(wm, first = 6, last = 7)
  df <- df[substring(df$yearmonth, first = 6, last = 7) == wm, ]
  max_from_min <- append(max_from_min, max(df$tas, na.rm = TRUE))
}


df_summary <- cbind(df_summary, min_from_max, max_from_min)
max_min_difference <- df_summary$maximum - df_summary$min_from_max
min_max_difference <- df_summary$minimum - df_summary$max_from_min
df_summary <- cbind(df_summary, max_min_difference, -min_max_difference)



df_summer <- df_summary[df_summary$max_min_difference > 8, ]
nrow(df_summer)
sum(df_summer$max_min_difference) / 1398
df_winter <- df_summary[df_summary$`-min_max_difference` > 11, ]
nrow(df_winter)
sum(df_winter$`-min_max_difference`) / 2007.678

df_summer[unique(df_summer[, 1]) %in% c(unique(df_winter[, 1])), ]
inter <- intersect(df_summary[, 1], df_winter[, 1])

df_summary[df_summary[, 1] %in% inter, ]

narrowed_df <- df_summary[df_summary$max_min_difference > 8, ]
narrowed_df <- koko[koko$`-min_max_difference` > 11, ]
