
library(shiny)


# Define UI for application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Diamonds Price Prediction"),
  
  # Sidebar with a slider and checkboxes
  sidebarLayout(
    sidebarPanel(
       h1("Selections and Model Information"),
       h3("Model Information:"),
       textOutput("modelOut"),
       h3("Select Range of Carat:"),
       sliderInput("maxcarat",
                   "Select carat:",
                   min = 0,
                   max = 5,
                   value = 4,
                   step = 0.1),
       h3("Select or Hide Data Points:"),
       checkboxInput("hide_ideal", "Hide/Show Ideal Cut"),
       checkboxInput("hide_premium", "Hide/Show Premium Cut"),
       checkboxInput("hide_very_good", "Hide/Show Very Good Cut"),
       checkboxInput("hide_good", "Hide/Show Good Cut"),
       checkboxInput("hide_fair", "Hide/Show Fair Cut"),
       submitButton("Submit")
    ),
    
    # Show a plot of the diamond data
    mainPanel(
      h3("Plot of the Diamond Data"),
      h4("The following figure shows the data points of the diamond data of the ggplot2 library."),
      h3("Usage:"),
      h4("* The slider can be used to restrict the maximal range of the carat number. Please push Submit button after selection."),
      h4("* The different cuts of the diamonds can be shown or hidden in the plot with the checkboxes. Hiding all cuts cause an error. If a box is checked, the data points with the specific cut is hidden."),
      h4("* Selecting a rectangle in the plot and then Submit shows a prediction model in the plot."),
       plotOutput("distPlot", brush = brushOpts(
         id = "brush1"),
      ))
  )
))
