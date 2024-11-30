---
title: HFCE Food Time Series Using Seasonal ARIMA and ETS Model
date: 2024-05-12 00:00:00 +0800
categories: [Data Analytics]
tags: [r programming, time-series]
image: /assets/thumbnails/food-time-series.webp
description: This is my RNotebook in analyzing the trend in Philippine Household Final Consumption Expenditure on Food from 2000 Q1 - 2024 Q1
---

------------------------------------------------------------------------

The data used in this report were downloaded from [Philippines
Statistics
Authority](https://psa.gov.ph/statistics/national-accounts/data-series)
website accessed on **May 10, 2024**. We are going to model and forecast
the Household Final Consumption Expenditure on Food using [Seasonal
ARIMA](#seasonal-arima) and [Error-Trend-Seasonality
Model](#error-trend-seasonality-model)

## Seasonal ARIMA

### Six Major Steps in Developing a Forecast using ARIMA

#### Step 1: Defining the Problem

Research Questions:

1.  What is the spending pattern of Filipinos on food for the first
    quarter of 2000 to fourth quarter of 2023?

2.  What is the best fit model in forecasting the Household Final
    Consumption Expenditure on Food?

3.  What are the forecasted values of the Household Final Consumption
    Expenditure on Food for the years 2024 to 2026?

------------------------------------------------------------------------

#### Step 2: Gathering and Preprocessing Data

Let us load the `library packages` to be used in the analysis.

```r
library(forecast)
library(tidyverse)
library(caret)
library(skimr)
library(nortest)
```

Then, we import the data and use the `skimr` package to see if we
imported the right data by looking at the summary of our data.

```r
data=read.csv("hfce_food.csv")

skim_without_charts(data)
```

```
Data summary

| Name                   | data   |
| :--------------------- | :----- |
| Number of rows         | 97     |
| Number of columns      | 3      |
| ______________________ | ______ |
| Column type frequency: |        |
| numeric                | 3      |
| ______________________ | ______ |
| Group variables        | None   |
```

```
Variable type: numeric

| skim_variable | n_missing | complete_rate |   mean    |    sd     |    p0    |   p25    |   p50    |   p75   |  p100   |
| :-----------: | :-------: | :-----------: | :-------: | :-------: | :------: | :------: | :------: | :-----: | :-----: |
|     year      |     0     |       1       |  2011.63  |   7.04    |  2000.0  |  2006.0  |  2012.0  |  2018   |  2024   |
|    quarter    |     0     |       1       |   2.48    |   1.13    |   1.0    |   1.0    |   2.0    |    3    |    4    |
|     food      |     0     |       1       | 860391.27 | 307237.89 | 423664.9 | 612422.8 | 805192.2 | 1091080 | 1623143 |
```

------------------------------------------------------------------------

Based on the summary, we have 97 observations and 3 columns. We only
want to deal with the third column which is the HFCE on food. So we
select that specific column, then we transform it into a time series
data.

```r
food_data=as.numeric(data$food)

food_ts=data %>% 
  select(food) %>% 
  ts(start=c(2000,1), 
            end=c(2024,1),
            frequency=4)
print(food_ts)
```

    ##           Qtr1      Qtr2      Qtr3      Qtr4
    ## 2000  423664.9  449586.9  450837.2  535605.1
    ## 2001  437332.8  462178.8  469641.0  549648.8
    ## 2002  448134.6  486702.3  489892.4  582316.3
    ## 2003  477251.9  520161.8  524455.6  620645.6
    ## 2004  511667.8  546097.5  557059.0  660502.2
    ## 2005  548598.8  584154.8  588139.3  689083.4
    ## 2006  568914.8  616342.4  609338.3  723959.4
    ## 2007  583249.4  642173.4  624806.2  769099.9
    ## 2008  612422.8  659462.5  653092.0  802253.4
    ## 2009  615291.6  692122.2  668043.1  834584.6
    ## 2010  639867.9  705532.2  675545.2  878615.1
    ## 2011  677039.8  745150.8  738869.8  912114.1
    ## 2012  731346.5  805192.2  773345.2  960484.0
    ## 2013  776755.0  843898.1  825336.2 1014631.5
    ## 2014  813527.2  876161.6  852033.3 1071834.6
    ## 2015  851114.5  933286.2  896797.1 1142641.4
    ## 2016  905304.5 1000299.8  970619.9 1210691.7
    ## 2017  956716.9 1059166.1 1013128.6 1275330.5
    ## 2018 1006691.4 1132968.0 1045322.5 1338920.9
    ## 2019 1065737.7 1195240.4 1091080.1 1402836.4
    ## 2020 1116359.6 1250582.6 1145022.9 1476522.5
    ## 2021 1143280.5 1285705.1 1178278.3 1552717.6
    ## 2022 1256130.4 1357980.1 1227509.8 1613837.9
    ## 2023 1265574.4 1362290.0 1230795.0 1623142.7
    ## 2024 1272534.1

#### Step 3: Exploratory Analysis

Plot the time series data.

```r
autoplot(food_ts,
          main='HFCE on Food',
          xlab='Quarter',
          ylab='in million Php',
          size=0.25)
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-5-1.png)

To better understand the trend and seasonality, let’s decompose the time
series into its trend, seasonality, and residual components. Let us also
make a seasonal plot to have a close up look of the seasonal patterns
that is present in the data.

```r
autoplot(decompose(food_ts))
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-6-1.png)

```r
food_ts_filtered=window(food_ts, end = c(2023, 4))

ggseasonplot(food_ts_filtered, year.labels=TRUE, main="Seasonal Plot",ylab="in million Php", continuous = TRUE)
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-6-2.png)

Research Question 1: What is the spending behavior of Filipinos on food
for the first quarter of 2000 to fourth quarter of 2023?

Over the past 24 years, the Household Final Consumption Expenditure
(HFCE) on food has exhibited an upward trend with remarkable seasonal
patterns. The general upward trend can be attributed to the increasing
population and the increasing inflation. The plot also shows that there
is a spike in spending every second quarter, followed by a decrease in
the third quarter. Notably, there is a major increase every fourth
quarter which is likely due to increased social gatherings and
Christmas-related events that involve higher food consumption.
Additionally, the second and fourth-quarter spending spikes may also be
partly attributed to the distribution of midyear and Christmas bonuses
to employees, respectively.

We can use the Autocorrelation Function and Partial Autocorrelation
Function if we want to manually select the model. In my case, I am going
to use the automated model selection under the forecast package.
Nevertheless, let us show the ACF and PACF for demonstration.

```r
acf(food_ts,lag.max=36)
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-7-1.svg)

```r
pacf(food_ts,lag.max=36)
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-7-2.svg)

------------------------------------------------------------------------

#### Step 4: Building and Choosing Tentative Models

Let us set the training set and test set which we will use in evaluating
the accuracy of our model. 80% of the data or 77 observations were
included in the training set and 20% or 20 observations for the test
set.

```r
train_length=floor(0.8*length(food_ts))

train_data=food_ts[1:train_length]

test_data =food_ts[(train_length + 1):length(food_ts)]

food_train=ts(train_data,
            start=c(2000,1), 
            end=c(2019,1),
            frequency=4)

food_test=ts(test_data,
            start=c(2019,2), 
            end=c(2024,1),
            frequency=4)
```

Let us now build the models using an automated model selection method
with the `auto.arima()` function.

    auto.arima(food_train,trace=TRUE,ic="bic")

    ## 
    ##  ARIMA(2,1,2)(1,1,1)[4]                    : 1583.181
    ##  ARIMA(0,1,0)(0,1,0)[4]                    : 1602.32
    ##  ARIMA(1,1,0)(1,1,0)[4]                    : 1572.197
    ##  ARIMA(0,1,1)(0,1,1)[4]                    : 1571.667
    ##  ARIMA(0,1,1)(0,1,0)[4]                    : 1568.198
    ##  ARIMA(0,1,1)(1,1,0)[4]                    : 1571.647
    ##  ARIMA(0,1,1)(1,1,1)[4]                    : 1575.534
    ##  ARIMA(1,1,1)(0,1,0)[4]                    : 1567.132
    ##  ARIMA(1,1,1)(1,1,0)[4]                    : 1571.408
    ##  ARIMA(1,1,1)(0,1,1)[4]                    : 1571.408
    ##  ARIMA(1,1,1)(1,1,1)[4]                    : 1575.684
    ##  ARIMA(1,1,0)(0,1,0)[4]                    : 1568.29
    ##  ARIMA(2,1,1)(0,1,0)[4]                    : 1571.356
    ##  ARIMA(1,1,2)(0,1,0)[4]                    : Inf
    ##  ARIMA(0,1,2)(0,1,0)[4]                    : 1568.104
    ##  ARIMA(2,1,0)(0,1,0)[4]                    : 1568.534
    ##  ARIMA(2,1,2)(0,1,0)[4]                    : 1575.215
    ## 
    ##  Best model: ARIMA(1,1,1)(0,1,0)[4]

    ## Series: food_train 
    ## ARIMA(1,1,1)(0,1,0)[4] 
    ## 
    ## Coefficients:
    ##           ar1      ma1
    ##       -0.3976  -0.4370
    ## s.e.   0.1532   0.1558
    ## 
    ## sigma^2 = 141548569:  log likelihood = -777.15
    ## AIC=1560.3   AICc=1560.66   BIC=1567.13

Let us choose top 5 best models generated by the `auto.arima()`
function.

```
    Model                    BIC
1.  ARIMA(1,1,1)(0,1,0)_4    1567.132

2.  ARIMA(0,1,2)(0,1,0)_4    1568.104

3.  ARIMA(0,1,1)(0,1,0)_4    1568.198

4.  ARIMA(1,1,0)(0,1,0)_4    1568.29

5.  ARIMA(2,1,0)(0,1,0)_4    1568.534
```

Personally, I do not want to choose the top 1 immediately as the best
model because it might not be the best in the other criteria. And
looking at the BIC, they are relatively the same. So, let us build our
tentative models and name each model as model1, model2, model3, model4,
and model5, respectively.

```r
model1=arima(food_train,order=c(1,1,1),seasonal=list(order=c(0,1,0)))
model2=arima(food_train,order=c(0,1,2),seasonal=list(order=c(0,1,0)))
model3=arima(food_train,order=c(0,1,1),seasonal=list(order=c(0,1,0)))
model4=arima(food_train,order=c(1,1,0),seasonal=list(order=c(0,1,0)))
model5=arima(food_train,order=c(2,1,0),seasonal=list(order=c(0,1,0)))
```

Let us compare the Bayesian Information Criteria and Akaike Information
Criteria of the top 5 tentative models.

```r
rbind(Model1=data.frame(BIC=BIC(model1),AIC=AIC(model1)),
      Model2=data.frame(BIC=BIC(model2),AIC=AIC(model2)),
      Model3=data.frame(BIC=BIC(model3),AIC=AIC(model3)),
      Model4=data.frame(BIC=BIC(model4),AIC=AIC(model4)),
      Model5=data.frame(BIC=BIC(model5),AIC=AIC(model5)))
```

    ##             BIC      AIC
    ## Model1 1567.132 1560.302
    ## Model2 1568.104 1561.274
    ## Model3 1568.198 1563.645
    ## Model4 1568.290 1563.737
    ## Model5 1568.534 1561.704

As can be seen from the table, the BIC and AIC of the top 5 models are
relatively the same so we consider all 5 as our tentative models and
further compare them in the residuals and normality tests and the
accuracy metrics.

------------------------------------------------------------------------

#### Step 5: Model Diagnostics

Check the residuals of the training set using Ljung-Box Test to test
autocorrelation and Lilliefors Test to test for normality.

```r
rbind(
  checkresiduals(model1),
  checkresiduals(model2),
  checkresiduals(model3),
  checkresiduals(model4),
  checkresiduals(model5)
)
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-12-1.svg)

    ## 
    ##  Ljung-Box test
    ## 
    ## data:  Residuals from ARIMA(1,1,1)(0,1,0)[4]
    ## Q* = 7.294, df = 6, p-value = 0.2945
    ## 
    ## Model df: 2.   Total lags used: 8

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-12-2.svg)

    ## 
    ##  Ljung-Box test
    ## 
    ## data:  Residuals from ARIMA(0,1,2)(0,1,0)[4]
    ## Q* = 9.0145, df = 6, p-value = 0.1728
    ## 
    ## Model df: 2.   Total lags used: 8

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-12-3.svg)

    ## 
    ##  Ljung-Box test
    ## 
    ## data:  Residuals from ARIMA(0,1,1)(0,1,0)[4]
    ## Q* = 19.002, df = 7, p-value = 0.008182
    ## 
    ## Model df: 1.   Total lags used: 8

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-12-4.svg)

    ## 
    ##  Ljung-Box test
    ## 
    ## data:  Residuals from ARIMA(1,1,0)(0,1,0)[4]
    ## Q* = 13.965, df = 7, p-value = 0.05181
    ## 
    ## Model df: 1.   Total lags used: 8

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-12-5.svg)

    ## 
    ##  Ljung-Box test
    ## 
    ## data:  Residuals from ARIMA(2,1,0)(0,1,0)[4]
    ## Q* = 8.4782, df = 6, p-value = 0.2051
    ## 
    ## Model df: 2.   Total lags used: 8

    ##      statistic parameter p.value     method          
    ## [1,] 7.294047  6         0.2945078   "Ljung-Box test"
    ## [2,] 9.014542  6         0.1727619   "Ljung-Box test"
    ## [3,] 19.00179  7         0.008181724 "Ljung-Box test"
    ## [4,] 13.96482  7         0.05181069  "Ljung-Box test"
    ## [5,] 8.478157  6         0.2051221   "Ljung-Box test"
    ##      data.name                              
    ## [1,] "Residuals from ARIMA(1,1,1)(0,1,0)[4]"
    ## [2,] "Residuals from ARIMA(0,1,2)(0,1,0)[4]"
    ## [3,] "Residuals from ARIMA(0,1,1)(0,1,0)[4]"
    ## [4,] "Residuals from ARIMA(1,1,0)(0,1,0)[4]"
    ## [5,] "Residuals from ARIMA(2,1,0)(0,1,0)[4]"

```r
rbind(
  lillie.test(residuals(model1)),
  lillie.test(residuals(model2)),
  lillie.test(residuals(model3)),
  lillie.test(residuals(model4)),
  lillie.test(residuals(model5))
)
```

    ##      statistic  p.value    method                                          
    ## [1,] 0.07841714 0.2863736  "Lilliefors (Kolmogorov-Smirnov) normality test"
    ## [2,] 0.07833954 0.2877793  "Lilliefors (Kolmogorov-Smirnov) normality test"
    ## [3,] 0.07745631 0.304094   "Lilliefors (Kolmogorov-Smirnov) normality test"
    ## [4,] 0.1075675  0.02775728 "Lilliefors (Kolmogorov-Smirnov) normality test"
    ## [5,] 0.093978   0.08931557 "Lilliefors (Kolmogorov-Smirnov) normality test"
    ##      data.name          
    ## [1,] "residuals(model1)"
    ## [2,] "residuals(model2)"
    ## [3,] "residuals(model3)"
    ## [4,] "residuals(model4)"
    ## [5,] "residuals(model5)"

Model 3 will be eliminated in the tentative models since it failed the
autocorrelation test on the residuals. Model 4 will also be eliminated
since it failed the normality test on the residuals.

Compute the accuracy metrics for the training set and test set of the
three remaining tentative ARIMA models:

```r
autoplot(food_ts,series="Actual Values",main="ARIMA(1,1,1)(0,1,0)[4]",size=0.25)+
  autolayer(fitted(model1),series="Training Set",size=0.25)+
  autolayer(forecast(model1,h=length(food_test))$mean,series="Test Set",size=0.25)+
  xlab("Quarter")+
  ylab("in million Php")+
  guides(colour=guide_legend(title=""))+
  scale_color_manual(values=c('black','red2','blue'))
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-13-1.png)

```r
autoplot(food_ts,series="Actual Values",main="ARIMA(0,1,2)(0,1,0)[4]",size=0.25)+
  autolayer(fitted(model2),series="Training Set",size=0.25)+
  autolayer(forecast(model2,h=length(food_test))$mean,series="Test Set",size=0.25)+
  xlab("Quarter")+
  ylab("in million Php")+
  guides(colour=guide_legend(title=""))+
  scale_color_manual(values=c('black','red2','blue'))
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-13-2.png)

```r
autoplot(food_ts,series="Actual Values",main="ARIMA(2,1,0)(0,1,0)[4]",size=0.25)+
  autolayer(fitted(model5),series="Training Set",size=0.25)+
  autolayer(forecast(model5,h=length(food_test))$mean,series="Test Set",size=0.25)+
  xlab("Quarter")+
  ylab("in million Php")+
  guides(colour=guide_legend(title=""))+
  scale_color_manual(values=c('black','red2','blue'))
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-13-3.png)

```r
rbind(
  Model1=data.frame(accuracy(forecast(model1,h=length(food_test)),food_test)),
  Model2=data.frame(accuracy(forecast(model2,h=length(food_test)),food_test)),
  Model5=data.frame(accuracy(forecast(model5,h=length(food_test)),food_test))
)
```

    ##                             ME     RMSE       MAE        MPE     MAPE      MASE
    ## Model1.Training set   1400.610 11343.74  8859.332  0.1544905 1.168872 0.2374846
    ## Model1.Test set     -15145.694 39645.53 29695.972 -1.3201820 2.303153 0.7960349
    ## Model2.Training set   1288.535 11422.34  8931.468  0.1377005 1.174586 0.2394183
    ## Model2.Test set     -13298.800 38593.82 28860.258 -1.1783996 2.234844 0.7736326
    ## Model5.Training set   1156.821 11459.56  8823.302  0.1155627 1.156377 0.2365188
    ## Model5.Test set     -15968.152 40577.58 30536.624 -1.3867164 2.373970 0.8185695
    ##                            ACF1 Theil.s.U
    ## Model1.Training set -0.02114274        NA
    ## Model1.Test set     -0.01046222 0.1477099
    ## Model2.Training set -0.04724610        NA
    ## Model2.Test set     -0.02739125 0.1440597
    ## Model5.Training set -0.05387640        NA
    ## Model5.Test set     -0.02389871 0.1509217

------------------------------------------------------------------------

#### Step 6: Choosing the Best Model and Making Forecast

Research Question 2: What is the best ARIMA model in forecasting the
Household Final Consumption Expenditure on Food?

Based on the accuracy metrics the best fit ARIMA model is Model 2 with
parameters **ARIMA(0,1,2)(0,1,0)\[4\]** since it outperformed models 1
and 5 especially in the accuracy in the test set. This means that it has
a better performance in new and unseen data.

Research Question 3: What are the forecasted values of the Household
Final Consumption Expenditure on Food for the years 2024 to 2025?

Using the identified best fit ARIMA model, we make forecast for the next
12 quarters or in the next 3 years.

```r
coefs=model2$coef
best_fit=arima(food_ts, order=c(0,1,2), seasonal=c(0,1,0),fixed=coefs)
print(fitted(best_fit))
```

    ##           Qtr1      Qtr2      Qtr3      Qtr4
    ## 2000  423420.3  449457.4  450751.3  535634.9
    ## 2001  438330.3  463000.1  464385.2  549943.5
    ## 2002  452836.5  476741.5  484895.7  568288.1
    ## 2003  470609.9  513870.1  519866.2  614693.8
    ## 2004  511866.0  556207.1  558575.6  651990.7
    ## 2005  544218.6  581560.6  594084.0  697063.7
    ## 2006  582212.9  613332.4  614595.7  715306.3
    ## 2007  595447.1  642745.0  632626.2  745654.9
    ## 2008  607367.6  673012.5  654377.2  795090.3
    ## 2009  639425.7  683752.7  672983.1  823291.9
    ## 2010  637207.7  717317.3  691707.0  852342.1
    ## 2011  658515.5  734098.2  710731.5  921750.1
    ## 2012  725326.5  792178.2  789797.4  963198.0
    ## 2013  777868.8  850838.4  817428.6 1004323.3
    ## 2014  824457.9  892114.7  867895.8 1050312.2
    ## 2015  849290.1  917571.5  896809.9 1120484.8
    ## 2016  903874.0  991775.9  957221.8 1207655.2
    ## 2017  974186.4 1066688.3 1031303.5 1266146.6
    ## 2018 1009393.7 1113606.5 1070496.0 1332801.0
    ## 2019 1059088.9 1188108.9 1103427.0 1396492.7
    ## 2020 1121441.6 1251565.7 1145969.6 1457307.6
    ## 2021 1174163.8 1307393.9 1190191.5 1514130.4
    ## 2022 1185112.1 1350235.4 1261762.4 1631754.4
    ## 2023 1323393.6 1410092.7 1256489.2 1626258.0
    ## 2024 1271079.0

```r
arima_forecast=forecast(best_fit,h=11)
autoplot(food_ts,series="Actual Values",main="Forecasts from ARIMA(0,1,2)(0,1,0)[4]",size=0.25)+
  autolayer(arima_forecast,series="Forecasted Values",size=0.25)+
  xlab("Quarter")+
  ylab("in million Php")+
  guides(colour=guide_legend(title=""))+
  scale_color_manual(values=c('black','blue','darkorchid4'))
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-14-1.svg)

```r
print(arima_forecast)
```

    ##         Point Forecast   Lo 80   Hi 80   Lo 95   Hi 95
    ## 2024 Q2        1367296 1345489 1389103 1333945 1400647
    ## 2024 Q3        1236160 1213981 1258340 1202239 1270081
    ## 2024 Q4        1628508 1604408 1652607 1591651 1665365
    ## 2025 Q1        1277899 1252022 1303777 1238323 1317475
    ## 2025 Q2        1372661 1332101 1413222 1310630 1434693
    ## 2025 Q3        1241525 1198786 1284265 1176160 1306890
    ## 2025 Q4        1633873 1587160 1680586 1562432 1705314
    ## 2026 Q1        1283264 1232891 1333638 1206225 1360304
    ## 2026 Q2        1378027 1313291 1442762 1279022 1477031
    ## 2026 Q3        1246890 1178224 1315557 1141874 1351907
    ## 2026 Q4        1639238 1564977 1713500 1525665 1752811

Aside from ARIMA models another model that we might consider to model
our data is ETS (Error-Trend-Seasonality Model). We are going to build
the best fit ETS model using the `ets()` function. After that we compare
the performance of the ARIMA model and ETS model and identify which
among the two better fits the model and has better accuracy metrics.

## Error-Trend-Seasonality Model

```r
ets_train=ets(food_train,ic="bic")
summary(ets_train)
```

    ## ETS(M,A,M) 
    ## 
    ## Call:
    ## ets(y = food_train, ic = "bic")
    ## 
    ##   Smoothing parameters:
    ##     alpha = 0.1983 
    ##     beta  = 0.1523 
    ##     gamma = 0.5768 
    ## 
    ##   Initial states:
    ##     l = 456406.391 
    ##     b = 6173.0731 
    ##     s = 1.1338 0.9676 0.9729 0.9257
    ## 
    ##   sigma:  0.0152
    ## 
    ##      AIC     AICc      BIC 
    ## 1774.791 1777.478 1795.885 
    ## 
    ## Training set error measures:
    ##                    ME     RMSE      MAE        MPE     MAPE      MASE
    ## Training set 741.7796 11219.51 8837.716 0.07204593 1.174295 0.2369052
    ##                    ACF1
    ## Training set -0.0915097

```r
ETS_Model=data.frame(AIC=AIC(ets_train),BIC=BIC(ets_train))
print(ETS_Model)
```

    ##        AIC      BIC
    ## 1 1774.791 1795.885

```r
ets_test=forecast(ets_train,h=20)
print(ets_test)
```

    ##         Point Forecast   Lo 80   Hi 80   Lo 95   Hi 95
    ## 2019 Q2        1179971 1157040 1202902 1144902 1215041
    ## 2019 Q3        1102504 1079829 1125179 1067825 1137182
    ## 2019 Q4        1405240 1373377 1437102 1356510 1453969
    ## 2020 Q1        1115136 1086374 1143898 1071148 1159124
    ## 2020 Q2        1236961 1191495 1282427 1167427 1306495
    ## 2020 Q3        1155120 1108038 1202202 1083114 1227125
    ## 2020 Q4        1471516 1404585 1538447 1369154 1573879
    ## 2021 Q1        1167120 1107787 1226453 1076378 1257862
    ## 2021 Q2        1294053 1213169 1374936 1170352 1417753
    ## 2021 Q3        1207831 1125304 1290357 1081616 1334045
    ## 2021 Q4        1537914 1423168 1652659 1362426 1713402
    ## 2022 Q1        1219200 1120077 1318323 1067605 1370795
    ## 2022 Q2        1351250 1225197 1477303 1158469 1544031
    ## 2022 Q3        1260640 1134205 1387076 1067274 1454006
    ## 2022 Q4        1604437 1431763 1777111 1340354 1868519
    ## 2023 Q1        1271379 1124867 1417892 1047308 1495451
    ## 2023 Q2        1408558 1229033 1588084 1133998 1683119
    ## 2023 Q3        1313553 1135819 1491288 1041732 1585375
    ## 2023 Q4        1671092 1431457 1910726 1304602 2037581
    ## 2024 Q1        1323663 1122852 1524474 1016550 1630777

```r
autoplot(food_ts,series="Actual Values",main="ETS(M,A,M)",size=0.25)+
  autolayer(ets_train$fitted,series="Training Set",size=0.25)+
  autolayer(ets_test$mean,series="Test Set",size=0.25)+
  xlab("Quarter")+
  ylab("in million Php")+
  guides(colour=guide_legend(title=""))+
  scale_color_manual(values=c('black','red2','blue'))
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-15-1.png)

```r
data.frame(accuracy(ets_train))
```

    ##                    ME     RMSE      MAE        MPE     MAPE      MASE
    ## Training set 741.7796 11219.51 8837.716 0.07204593 1.174295 0.2369052
    ##                    ACF1
    ## Training set -0.0915097

```r
data.frame(accuracy(ets_test$mean,food_test))
```

    ##                 ME     RMSE      MAE        MPE     MAPE      ACF1 Theil.s.U
    ## Test set -12485.83 30778.07 22784.45 -0.9902832 1.768978 0.4716438 0.1145338

```r
checkresiduals(ets_train)
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-15-2.svg)

    ## 
    ##  Ljung-Box test
    ## 
    ## data:  Residuals from ETS(M,A,M)
    ## Q* = 8.0934, df = 8, p-value = 0.4244
    ## 
    ## Model df: 0.   Total lags used: 8

```r
lillie.test(residuals(ets_train))
```

    ## 
    ##  Lilliefors (Kolmogorov-Smirnov) normality test
    ## 
    ## data:  residuals(ets_train)
    ## D = 0.079349, p-value = 0.2699

```r
ets=ets(food_ts)
print(fitted(ets))
```

    ##           Qtr1      Qtr2      Qtr3      Qtr4
    ## 2000  428161.2  454628.2  455616.2  537858.5
    ## 2001  440136.1  466834.2  467185.4  555901.5
    ## 2002  452456.6  477544.5  486961.7  574253.5
    ## 2003  472715.7  511571.2  518541.1  616820.0
    ## 2004  506024.9  551128.2  552059.9  654466.9
    ## 2005  539210.7  582487.4  592754.9  698846.5
    ## 2006  573101.1  607467.3  616288.3  722067.5
    ## 2007  597548.1  636269.8  634010.4  746276.7
    ## 2008  614441.1  671954.5  653683.3  792668.8
    ## 2009  635758.3  680427.7  676770.3  821988.7
    ## 2010  643331.8  714942.1  690945.9  848048.3
    ## 2011  660713.6  739862.9  718207.8  931791.5
    ## 2012  708032.1  789230.3  781053.4  972819.6
    ## 2013  764720.5  841462.3  813315.6 1021000.2
    ## 2014  817916.4  886655.1  857137.8 1053443.2
    ## 2015  850853.5  920479.4  901882.9 1123965.7
    ## 2016  899753.3  983873.7  955779.2 1217884.8
    ## 2017  962549.2 1054394.9 1018894.0 1271548.5
    ## 2018 1007227.4 1111416.9 1073943.9 1335262.4
    ## 2019 1054634.8 1180933.9 1108759.6 1406679.1
    ## 2020 1113233.6 1243244.0 1145490.7 1471947.8
    ## 2021 1171058.3 1295813.6 1181495.0 1516675.0
    ## 2022 1196470.7 1375614.2 1258853.6 1628849.7
    ## 2023 1287378.2 1390828.0 1255252.0 1635187.9
    ## 2024 1282793.3

```r
ets_forecast=forecast(ets,h=11)
autoplot(food_ts,series="Actual Values",main="Forecasts from ETS(M,A,M)",size=0.25)+
  autolayer(ets_forecast,series="Forecasted Values",size=0.25)+
  xlab("Quarter")+
  ylab("in million Php")+
  guides(colour=guide_legend(title=""))+
  scale_color_manual(values=c('black','blue','darkorchid4'))
```

![](/assets/data-analytics/food-time-series/figure-markdown_strict/unnamed-chunk-15-3.svg)

    print(ets_forecast)

    ##         Point Forecast   Lo 80   Hi 80   Lo 95   Hi 95
    ## 2024 Q2        1383043 1354801 1411285 1339850 1426235
    ## 2024 Q3        1255615 1227837 1283393 1213132 1298098
    ## 2024 Q4        1656745 1616762 1696727 1595597 1717892
    ## 2025 Q1        1301961 1267559 1336363 1249348 1354574
    ## 2025 Q2        1413967 1364286 1463648 1337987 1489948
    ## 2025 Q3        1283535 1235465 1331605 1210019 1357052
    ## 2025 Q4        1693383 1625649 1761116 1589793 1796973
    ## 2026 Q1        1330596 1273698 1387495 1243578 1417615
    ## 2026 Q2        1444940 1371499 1518381 1332622 1557258
    ## 2026 Q3        1311499 1241112 1381887 1203851 1419147
    ## 2026 Q4        1730078 1631989 1828167 1580064 1880092

Let us take a look at the summary table comparing the accuracy of the
ARIMA and ETS model in both the training set and test set.

```
|         Models         | Training RMSE | Training MAE | Training MAPE | Test RMSE | Test MAE | Test MAPE |
| :--------------------: | :-----------: | :----------: | :-----------: | :-------: | :------: | :-------: |
| ARIMA(0,1,2)(0,1,0)_4_ |    11422.3    |    8931.4    |     1.17      |  38593.8  | 28860.2  |   2.23    |
|       ETS(M,A,M)       |    11219.5    |    8837.7    |     1.17      |  30778.1  | 22784.5  |   1.77    |
```

## Conclusion

From the analysis, the HFCE on food exhibited a general upward trend
from 2000 - 2023. There is a seasonal pattern in expenditure
specifically a spike in the second and fourth quarters and decline in
the first and third quarters. Moreover, upon comparison of the
performance of the ARIMA and ETS model ETS(M,A,M) was determined to be
the best fit and better for forecasting unseen data.

Further insight from the analysis emphasizes the need for policies
ensuring food security and price stability due to rising food
expenditure. Seasonal spending peaks gives businesses insights for
targeted marketing and planning. The ARIMA and ETS models are effective
for economic forecasting.
