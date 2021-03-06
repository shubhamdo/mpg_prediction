

library(ggplot2)
library(dplyr)
library(tidyverse)
library(rpart)
library(MASS)
library(klaR)
# 1. Data Import
data <- read.csv("C:/Users/shubh/OneDrive - SRH IT/University/Semester 3/Analytics 3/Codes/auto-mpg.data",na = "?")
head(data)


# 2. Data Cleaning
data$horsepower <- gsub("?",NA,data$horsepower, fixed = TRUE)

data <-  data %>%
  drop_na()

data$mpg <- as.numeric(data$mpg)
data$horsepower <- as.numeric(data$horsepower)
# data$cylinders <- as.factor(data$cylinders)
data$car.name <- as.factor(data$car.name)
# data$model.year <- as.factor(data$model.year)
summary(data)


data <- data %>% 
  mutate(origin_alpha = as.factor(case_when(
    origin == 1 ~ "American",
    origin == 2 ~ "European",
    origin == 3 ~ "Japanese",
    )))
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

### MPG Vs displacement
ggplot(data = data, aes(displacement, mpg)) + geom_jitter()
# Higher Displacement lower mpg

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

unique(data$origin)
# Model
# Independent Variables 
# 1. Prediction of mpg

data_cart <- data %>%
  dplyr::select(-car.name, -origin_alpha)

## Decision Tree
cart <- rpart(mpg ~ ., data = data_cart)
cart$variable.importance

## Pruning
cart.p <- prune(cart, cp = .05)
cart.p$variable.importance


test_data <- data.frame(weight = c(1600),model.year = c(06), acceleration = c(56),horsepower = c(100), origin = c(2), cylinders = c(4), displacement = c(134))
test_data

predict(cart, newdata = test_data)


## Linear Regression

# '''
# Null Hypothesis: There is no relationship between independent variables and mpg
# '''

lin.reg <- lm(mpg ~ . - origin_alpha, data = data)
summary(lin.reg)

lin.reg <- lm(mpg ~ cylinders + horsepower + weight + origin, data = data)
summary(lin.reg)


test_data <- data.frame(weight = c(1600),model.year = c(06), acceleration = c(56),horsepower = c(100), origin = c(2), cylinders = c(4), displacement = c(134))
test_data

predict(lin.reg, newdata = test_data)

## Classification Problem
## What is the origin of a car


## Linear Discriminant Analysis

data_lda <- data %>%
  dplyr::select(-origin, -car.name)

lda.model <- lda(origin_alpha ~ .,data = data_lda)
summary(lda.model)
lda.model

test_data <- data.frame(mpg = c(45),weight = c(1600),model.year = c(06), acceleration = c(56),horsepower = c(100), origin = c(2), cylinders = c(4), displacement = c(134))
test_data

predict(lda.model, newdata = test_data)


## Greedy Wilks

fit.gw <- greedy.wilks(origin_alpha ~ . , data = data_lda)
fit.gw


lda_gw <- lda(fit.gw$formula, data = data_lda)
lda_gw

test_data <- data.frame(mpg = c(45), weight = c(1600),model.year = c(06), acceleration = c(56),horsepower = c(100), origin = c(2), cylinders = c(4), displacement = c(134))
test_data

ps <- predict(lda.model, newdata = test_data)


# f <- table(Observed = data_lda$origin_alpha, Predicted = ps$class)
