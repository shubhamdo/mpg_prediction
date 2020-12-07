library(ggplot2)
library(dplyr)
library(tidyverse)

# 1. Data Import
data <- read.csv("C:/Users/shubh/OneDrive - SRH IT/University/Semester 3/Analytics 3/auto-mpg.data",na = "?")
head(data)


# 2. Data Cleaning
data$horsepower <- gsub("?",NA,data$horsepower, fixed = TRUE)

data <-  data %>%
  drop_na()

data$mpg <- as.numeric(data$mpg)
data$horsepower <- as.numeric(data$horsepower)
data$cylinders <- as.factor(data$cylinders)
data$car.name <- as.factor(data$car.name)
data$model.year <- as.factor(data$model.year)
summary(data)

# 3. Descriptive Data Analysis

## a. Summary
summary(data)

## b. head()
head(data)

## c. structure
str(data)

## d. Plots

### MPG Vs CYL

ggplot(data = data, aes(cylinders, mpg)) + geom_jitter(aes(color = cylinders))
# Higher cyl has lower mpg

ggplot(data = data, aes(cylinders, mpg)) + geom_boxplot(aes(color = cylinders))
# Higher cyl has lower mpg

### MPG Vs displacement
ggplot(data = data, aes(displacement, mpg)) + geom_jitter()
# Higher Displacement lower mpg

### MPG Vs horsepower
ggplot(data = data, aes(horsepower, mpg)) + geom_jitter()
# Higher Horsepower lower mpg

### MPG Vs horsepower
ggplot(data = data, aes(horsepower, mpg)) + geom_jitter()
# Higher Horsepower lower mpg

### MPG vs weight
ggplot(data = data, aes(weight, mpg)) + geom_jitter()
# Higher Weight lower mpg

### MPG vs acceleration
ggplot(data = data, aes(acceleration, mpg)) + geom_point()
# MPG increases with acceleration
# Average Acceleration has better mpg

### MPG vs Model Year
ggplot(data = data, aes(x = model.year, y = mpg)) + geom_boxplot()
## Recent cars are more efficient, have better mpg.

# Correlation Matrix - Filter Factorial/Char Columns from Dataframe
exclude_vec <- c("model.year", "car.name","cylinders")
cor_data <- data %>% 
  select(setdiff(s, exclude_vec))

# Correlation Matrix
cor(cor_data)


# Model

# 1. Prediction of mpg


# 2. 


