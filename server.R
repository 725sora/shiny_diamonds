
library(shiny)
library(ggplot2)
library(dplyr)
library(modelr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    data(diamonds)
    
    model <- reactive({
      brushed_data <- brushedPoints(diamonds, input$brush1,
                                    xvar = "carat", yvar = "price")
      if(nrow(brushed_data) < 2){
        return(NULL)
      }
      brushed_data2 <- brushed_data %>%
        filter(carat <= 2.5) %>%
        mutate(logprice = log2(price), logcarat = log2(carat))
      ideal_cut <- ifelse(input$hide_ideal, "Ideal", "NA")
      premium_cut <- ifelse(input$hide_premium, "Premium", "NA")
      very_good_cut <- ifelse(input$hide_very_good, "Very Good", "NA")
      good_cut <- ifelse(input$hide_good, "Good", "NA")
      fair_cut <- ifelse(input$hide_fair, "Fair", "NA")
      brushed_data2 <- brushed_data2 %>% filter(cut != ideal_cut)
      brushed_data2 <- brushed_data2 %>% filter(cut != premium_cut)
      brushed_data2 <- brushed_data2 %>% filter(cut != very_good_cut)
      brushed_data2 <- brushed_data2 %>% filter(cut != good_cut)
      brushed_data2 <- brushed_data2 %>% filter(cut != fair_cut)
      mod_brushed <- lm(logprice ~ logcarat, data = brushed_data2)
      brushed_data2 %>%
        data_grid(carat = seq_range(carat, 20)) %>%
        mutate(logcarat = log2(carat)) %>%
        add_predictions(mod_brushed, "logprice") %>%
        mutate(price = 2^ logprice) %>%
        select(carat, price)
    })
    
  
    output$modelOut <- renderText({ if(is.null(model())){
      "No Area for Modeling selected or Model not Found"
    } else { "Prediction Model for the Price is shown in red."
    } })
          
    output$distPlot <- renderPlot({  

    # draw the histogram with the specified number of bins
    max_carat <- input$maxcarat
    diamonds2 <- diamonds %>% 
      filter(carat <= max_carat)
    ideal_cut <- ifelse(input$hide_ideal, "Ideal", "NA")
    premium_cut <- ifelse(input$hide_premium, "Premium", "NA")
    very_good_cut <- ifelse(input$hide_very_good, "Very Good", "NA")
    good_cut <- ifelse(input$hide_good, "Good", "NA")
    fair_cut <- ifelse(input$hide_fair, "Fair", "NA")
    diamonds2 <- diamonds2 %>% filter(cut != ideal_cut)
    diamonds2 <- diamonds2 %>% filter(cut != premium_cut)
    diamonds2 <- diamonds2 %>% filter(cut != very_good_cut)
    diamonds2 <- diamonds2 %>% filter(cut != good_cut)
    diamonds2 <- diamonds2 %>% filter(cut != fair_cut)
    
    plot(diamonds2$carat, diamonds2$price, col=diamonds2$cut, xlab = "carat", ylab = "price")
    legend("bottomright", legend = unique(diamonds2$cut), col = 1:length(diamonds2$cut), pch = 19, bty = "n")
    if(!is.null(model())){
      lines(model(), col = "red", lwd = 2)}
  })
  
})
