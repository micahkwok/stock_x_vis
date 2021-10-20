library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(tidyverse)
library(readxl)
library(plotly)

# to change
app = Dash$new(external_stylesheets = 'https://stackpath.bootstrapcdn.com/bootswatch/4.5.2/lux/bootstrap.min.css')

app$title("StockX Dashboard")

data <- read_csv("data/processed/cleaned_stockX_data.csv")

SIDEBAR_STYLE <- list(
    'position'="fixed",
    'top'=0,
    'left'=0,
    'bottom'=0,
    'width'="18rem",
    'padding'="2rem 1rem",
    'background-color'="#f8f9fa"
)

sidebar <- htmlDiv(list(
        htmlBr(),       
        
        #Age Filter - to change to time
        htmlH4(htmlLabel('Age')),
        dccRangeSlider(
          id='age-range-slider',
          min=15,
          max=75,
          step=2,
          marks=list(
            "15" = "15",
            "25" = "25",
            "35" = "35",
            "45" = "45",
            "55" = "55",
            "65" = "65",
            "75" = "75"
          ),
          value=list(15, 75)),
          htmlBr(),
        
          # Sneaker Model Checklist - to change to sneaker type
          htmlH4(htmlLabel('Sneaker Model')),
          dccChecklist(
              id = 'sneaker_model',
              options = list(
                  list('label'='Air Force 1', 'value' ='Air Force 1'),
                  list('label' = 'Air Jordan 1',  'value' = 'Air Jordan 1'),
                  list('label' = 'Air Max 90', 'value' = 'Air Max 90'),
                  list('label' = 'Air Max 97', 'value' = 'Air Max 97'),
                  list('label' = 'Air Presto', 'value' = 'Air Presto'),
                  list('label' = 'Blazer', 'value' = 'Blazer'),
                  list('label' = 'Hyperdunk 2017', 'value' = 'Hyperdunk 2017'),
                  list('label' = 'VaporMax', 'value' = 'VaporMax'),
                  list('label' = 'Yeezy', 'value' = 'Yeezy'),
                  list('label' = 'Zoom Fly', 'value' = 'Zoom Fly')),
              value = list('Air Force 1', 'Air Jordan 1', 'Air Max 90', 'Air Max 97', 'Air Presto', 'Blazer', 'Hyperdunk 2017', 'VaporMax', 'Yeezy', 'Zoom Fly'),
              labelStyle = list('display'='block')
          ),
          htmlBr(),
        
          # Self-Employed Filter Checklist
          htmlH4(htmlLabel('Self-Employed')),
          dccChecklist(
              id = 'self_emp_checklist',
              options = list(
                  list('label' = ' Yes', 'value' = 'Yes'),
                  list('label' = ' No', 'value' = 'No')),
              value = list('Yes', 'No'),            
              labelStyle = list('display'='block')
              
          ),          
          
         
      htmlDiv(id='output-container-range-slider')
    ), 
    style=SIDEBAR_STYLE
  )

CONTENT_STYLE <- list(
    'margin-left'="25rem",
    'margin-right'="2rem",
    'padding'="2rem 1rem"    
)

content <- htmlDiv(list(
  htmlH2('StockX'),
  htmlBr(),
  # Chart 1 figure
  dccGraph(id='price_time_chart'),
  htmlBr(),
  # Chart 2 figure
  dccGraph(id='violin_plot')  
),
  style=CONTENT_STYLE
)

#Main Layout
app$layout(
    
    htmlDiv(
    
      list(
      #side bar div
      sidebar,
      #content div
      content
      ) 
  ))

# Price Time Chart
app$callback(
  output('price_time_chart', 'figure'),
  list(input('sneaker_model', 'value')),
  function(sneaker_model_chosen) {
      p <- ggplot(data %>% filter(Sneaker.Specific.Type %in% sneaker_model_chosen), 
      aes(y = Sale.Price, x = Order.Year.Month, color = Sneaker.Specific.Type, group = Sneaker.Specific.Type)) + 
      geom_line(stat = 'summary', fun = mean) + 
      labs(x = "Time", y = "Sale Price", title = "Sale Price vs Time") + 
      theme(axis.text.x = element_text(angle = 90))
      
    ggplotly(p)
  }
)

app$callback(
  output('violin_plot', 'figure'),
  list(input('sneaker_model', 'value')),
  function(sneaker_model_chosen) {
      p <- ggplot(data %>% filter(Sneaker.Specific.Type %in% sneaker_model_chosen), 
      aes(x = Sneaker.Specific.Type, y = Sale.Price)) + geom_violin() + geom_point(stat = 'summary', fun = 'mean', color = 'red', alpha = 0.3) + labs(title = "Sale Price")
      
    ggplotly(p)
  }
)

app$run_server(debug = T, host = '0.0.0.0')