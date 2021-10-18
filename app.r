library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(tidyverse)
library(readxl)

app = Dash$new()

app$layout(htmlDiv("Hellow World"))

app$run_server(debug = T)
