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
        htmlH4(htmlLabel('Date Range')),
        dccDatePickerRange(
            id='date_picker',
            display_format = "MMM Y",
            start_date_placeholder_text = "MMM Y",
            start_date = format(as.Date("2017-9-1"), format  =  "%Y,%m,%d"),
            min_date_allowed = format(as.Date("2017-9-1"), format  =  "%Y,%m,%d"),
            max_date_allowed = format(as.Date("2019-2-28"), format  =  "%Y,%m,%d"),
            end_date = format(as.Date("2019-2-28"), format  =  "%Y,%m,%d")
        ),
        htmlBr(),
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
        
          # Sneaker Size Filter Checklist
          htmlH4(htmlLabel('Sneaker Size')),
          dccChecklist(
              id = 'sneaker_size',
              options = list(
                  list('label' = '3.5', 'value' = '3.5'),
                  list('label' = '4.0', 'value' = '4.0'),
                  list('label' = '4.5', 'value' = '4.5'),
                  list('label' = '5.0', 'value' = '5.0'),
                  list('label' = '5.5', 'value' = '5.5'),
                  list('label' = '6.0', 'value' = '6.0'),
                  list('label' = '6.5', 'value' = '6.5'),
                  list('label' = '7.0', 'value' = '7.0'),
                  list('label' = '7.5', 'value' = '7.5'),
                  list('label' = '8.0', 'value' = '8.0'),
                  list('label' = '8.5', 'value' = '8.5'),
                  list('label' = '9.0', 'value' = '9.0'),
                  list('label' = '9.5', 'value' = '9.5'),
                  list('label' = '10.0', 'value' = '10.0'),
                  list('label' = '10.5', 'value' = '10.5'),
                  list('label' = '11.0', 'value' = '11.0'),
                  list('label' = '11.5', 'value' = '11.5'),
                  list('label' = '12.0', 'value' = '12.0'),
                  list('label' = '12.5', 'value' = '12.5'),
                  list('label' = '13.0', 'value' = '13.0'),
                  list('label' = '13.5', 'value' = '13.5'),
                  list('label' = '14.0', 'value' = '14.0'),
                  list('label' = '14.5', 'value' = '14.5'),
                  list('label' = '15.0', 'value' = '15.0'),
                  list('label' = '16.0', 'value' = '16.0'),
                  list('label' = '17.0', 'value' = '17.0')),         
              value = list('3.5', '4.0', '4.5', '5.0', '5.5', '6.0', '6.5', '7.0', '7.5', '8.0', '8.5', '9.0', '9.5', '10.0', '10.5', '11.0', '11.5', '12.0', '12.5', '13.0','13.5', '14.0', '14.5', '15.0', '16.0', '17.0'),            
              labelStyle = list('display'='inline-block')
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

TITLE_BAR_STYLE <- list(
    backgroundColor = 'forestgreen', 
    color = 'white', 
    borderRadius = '3', 
    textAlign = 'center'
 )

content <- htmlDiv(list(
  htmlH2('StockX', style = TITLE_BAR_STYLE),
  htmlBr(),
  # Chart 1 figure
  dccGraph(id='price_time_chart'),
  htmlBr(),
  # Chart 2 figure
  dccGraph(id='violin_plot')  
),
  style=CONTENT_STYLE
)

# first_row <- htmlDiv(list(
#     dbcRow(dbcCol(htmlDiv('Title')
# )))

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
  list(input('sneaker_model', 'value'), 
       input('sneaker_size', 'value'),
       input('date_picker', property = 'start_date'),
       input('date_picker', property = 'end_date')),
  function(sneaker_model_chosen, sneaker_size_chosen, start_date_chosen, end_date_chosen) {
      p <- ggplot(data %>% filter(Sneaker.Specific.Type %in% sneaker_model_chosen &
                                  Shoe.Size %in% sneaker_size_chosen &
                                  Order.Year.Month >= as.Date(gsub(",","-",start_date_chosen)) &
                                  Order.Year.Month <= as.Date(gsub(",","-",end_date_chosen))), 
      aes(y = Sale.Price, x = Order.Year.Month, color = Sneaker.Specific.Type, group = Sneaker.Specific.Type)) + 
      geom_line(stat = 'summary', fun = mean) + 
      labs(x = "Time", y = "Sale Price", title = "Sale Price vs Time") + 
      theme(axis.text.x = element_text(angle = 90))

    ggplotly(p)
  }
)

app$callback(
  output('violin_plot', 'figure'),
  list(input('sneaker_model', 'value'), 
       input('sneaker_size', 'value'),
       input('date_picker', property = 'start_date'),
       input('date_picker', property = 'end_date')),
  function(sneaker_model_chosen, sneaker_size_chosen, start_date_chosen, end_date_chosen) {
      p <- ggplot(data %>% filter(Sneaker.Specific.Type %in% sneaker_model_chosen &
                                  Shoe.Size %in% sneaker_size_chosen &
                                  Order.Year.Month >= as.Date(gsub(",","-",start_date_chosen)) &
                                  Order.Year.Month <= as.Date(gsub(",","-",end_date_chosen))), 
      aes(x = Sneaker.Specific.Type, y = Sale.Price)) + 
      geom_violin() + 
      geom_point(stat = 'summary', fun = 'mean', color = 'red', alpha = 0.3) + labs(title = "Sale Price")
      
    ggplotly(p)
  }
)

app$run_server(debug = T, host = '0.0.0.0')