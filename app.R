library(shiny)
library(ggplot2)
library(tidyverse)
library(RColorBrewer)
library(shinythemes)
data(quakes) 


ui <- fluidPage(
  theme = shinytheme("cosmo"), ##FEATURE 7 (NEW) added a theme
  titlePanel("Visualizing the Quakes Dataset and Performing Prediction"),
  sidebarLayout(
    sidebarPanel(
      "This shiny app allows you to explore the Quakes dataset.",
      br(),
      br(),
      "The latitude and longitude variables are numeric describing the location of the event.",
      "The depth variable describes the depth of the earthquake in km, also a numeric variable.",
      "The stations variable is a numeric variable describing the number of stations who reported the earthquake.",
      "The magnitude variable is based on the Richter scale, we treat it as categorical.",
      br(),
      br(),
      "First, in the table tab, you can view some summary statistics of each variable.",
      br(),
      br(),
      "Next, in the plots tab, you can visualize the different variables in a boxplot or a scatterplot (depending on variable type).",
      br(),
      br(),
      "Finally, in the regression model tab, we fit a predictive model for magnitude. We can assess the predictive
      accuracy using the mean squared prediction error (MSPE).",
    ),
   mainPanel(
     # FEATURE 5 (NEW)
     # We introduce tabs, to make the layout more organized.
     tabsetPanel(type = "tabs",
                 tabPanel("Table",
                          
                          #FEATURE 3 (same as previous assignment)
                          # This code allows the user to choose the columns they want to view 
                          # the mean of/the columns to be included in the table of means.
                          
                          checkboxGroupInput("summary","Please choose the columns you would like to view",
                                             choices = c("lat", "long","mag", "stations", "depth"),
                                             selected = c("lat", "long", "mag", "stations", "depth")),
                          h3("Summary Statistics for Each Variable Selected"),
                          tableOutput("statsummary")
                          
                 ),
                 tabPanel("Plots",
                          "We treat magnitude as a categorical variable as the earthquakes magnitude is measured on the Richter scale 
                          and is only reported to one decimal place. For example, since we don't have a value of 4.15, only 4.1 and 4.2, 
                          we treat these as different groups instead of a continuous scale.",
                          br(),
                          br(),
                          "Since there are a lot of different magnitudes, the slider below allows you to essentially zoom in 
                          on parts of the graph.",
                          br(),
                          # FEATURE 1 (same as previous assignment)
                          # They user can choose the the range of magnitudes to be included in the graphs
                          tags$div(sliderInput("mag", "Please select the range of magnitudes to be shown on both graphs below.", 
                                               value = c(min(quakes$mag),max(quakes$mag)), 
                                               min = min(quakes$mag), max = max(quakes$mag),
                                               step = 0.1),  style="display:inline-block"),
                          # FEATURE 4 (NEW)
                          # The user can select what variable they would like to see on the y-axis of the boxplot.
                         br(),
                           "Please choose if you would like to see stations or depth on the y-axis of the boxplot.",
                          br(),
                          selectInput("vars","Select stations or depth:",choices = 
                                        c("stations", "depth")),
                          
                          h3("Varying Ritcher Magnitudes"),
                          plotOutput("myplot"), 
                          
                          # FEATURE 2 (same as previous assignment)
                          # This implements a select input for the user to choose what color
                          # they want the points on the scatter plot to be. 
                          "Customize the colour of your scatterplot below!",
                          br(),
                          tags$div(selectInput("cols","Please choose a color for the scatterplot:",choices = 
                                                 c("Greens","Blues","Oranges","Purples")), 
                                   style="display:inline-block"),
                          h3("Locations of Earthquakes of Varying Ritcher Magnitudes"),
                          plotOutput("myplot2")),
                 
                  # FEATURE 6 (NEW)
                 # Here we introduce a new feature where we allow the use to choose the size of a training set
                 # Then we fit a regression model and show the predictive accuracy
                 tabPanel("Regression Model",
                          "We can fit a multivariate linear regression model to predict the Ritcher magnitude's of Earthquakes.",
                          "To fit a model and assess it's predictive accuracy, we must split the dataset into a training and test dataset.",
                          br(),
                          br(),
                          sliderInput("trainingsize","Please select proportion for training set.",
                                      value = 0.75,
                                      min = 0.5, max = 0.9,
                                      step = 0.05
                          ),
                          "The training set is of size:",
                          textOutput("train"),
                          "The testing set is of size:",
                          textOutput("test"),
                          br(),
                          "The summary of the linear model is shown below, remember this model is trained on the training set.",
                          h3("Summary of Model Output"),
                          tableOutput("modelsummary"),
                          br(),
                          br(),
                          "We can then use this model to predict the values in the training set and find the difference between the predicted and true magnitudes.",
                          "The mean value of all the squared differences is the mean prediction error.",
                          br(),
                          br(),
                          "The mean squared prediction error is:",
                          textOutput("meanprediction")
                          
                                           )
                 
     
    )
  )
)
)


server <- function(input, output) {
  # This allows us to filter the dataset depending on the range of magnitudes
  #  that was inputted
  d <- reactive({
    quakes %>%
      select(c(mag, input$vars)) %>%
      filter(mag >= input$mag[1],
             mag <= input$mag[2]) 
    
  }) 
  
  d2 <- reactive({
    quakes %>%
      filter(mag >= input$mag[1],
             mag <= input$mag[2]) 
  })
  
  # Here we make a boxplot of number of stations for different magnitudes
  # Since there are so many magnitudes, the user can specify the range
  # Essentially zooming in on sections of the boxplots
  
  output$myplot <- renderPlot({
    ggplot(d(), aes(as.factor(mag), d()[,2])) +
      geom_boxplot() + 
      theme_classic() +
      xlab("Ritcher Magnitude") +
      ylab(input$vars) 
  })
  
  # Here we make a scatterplot of locations, with the colors being chosen
  # by the user. The points are colored based on magnitude also.
  output$myplot2  <- renderPlot({
    ggplot(d2(), aes(x = lat, y = long, 
                    color = mag)) +
      geom_point() +
      scale_color_distiller(palette = input$cols) + 
      xlab("Latitude") +
      ylab("Longitude") 
  })

  # Here we make a table showing the means of the columns selected by the user.
  output$statsummary <- renderTable({cbind("Summary Statistic" =c("Min.", "1st Qu.","Median","Mean","3rd Qu.","Max."),
    data.frame(quakes) %>% 
     reframe(across(input$summary, summary)) )
  })
  
  # Here we split our data into a training and testing set for the regression model to do prediction
  smp_size <- reactive(floor(input$trainingsize * nrow(quakes)))
  
  set.seed(123)
  train_ind <- reactive(sample(seq_len(nrow(quakes)), size = smp_size()))
  
  train <- reactive(quakes[train_ind(), ])
  test <- reactive(quakes[-train_ind(), ])
  output$modelsummary <- renderTable({cbind("Variable" = c("Intercept","Latitude","Longitude","Depth","Stations"), 
                                            round(summary(lm(mag ~ lat+long+depth+stations, data = train()))$coef,6))
  })
  
  output$train <- renderText(smp_size())
  output$test <- renderText(c(1000-smp_size()))
  
  output$meanprediction <- renderText(mean((predict(lm(mag ~ lat+long+depth+stations, data = train()), test())- test()$mag)^2))

    
}

shinyApp(ui = ui, server = server)
