# SOURCE: Garrett Grolemund @ Shiny Developer Conference 2016 (https://github.com/rstudio/ShinyDeveloperConference/blob/master/Modules/Demo/app.R) with updates 

#..............................setup.............................
library(shiny)
library(gapminder)
library(dplyr)

# Note: This code creates data sets to use in each tab.
# It removes Kuwait since Kuwait distorts the gdp scale
all_data <- filter(gapminder, country != "Kuwait")
africa_data <- filter(gapminder, continent == "Africa")
americas_data <- filter(gapminder, continent == "Americas")
asia_data <- filter(gapminder, continent == "Asia", country != "Kuwait")
europe_data <- filter(gapminder, continent == "Europe")
oceania_data <- filter(gapminder, continent == "Oceania")

#...............................ui...............................
ui <- fluidPage(
  
  # app title ----
  titlePanel("Gapminder"),
  
  # continent tabsetPanel ----
  tabsetPanel(id = "continent", 
              
              # All tab ----
              tabPanel(title = "All", 
                       plotOutput(outputId = "all_plot"),
                       sliderInput(inputId = "all_year", label = "Select Year", 
                                   value = 1952, min = 1952, max = 2007, step = 5, 
                                   animate = animationOptions(interval = 500))
              ), # END All tab
              
              # Africa tab ----
              tabPanel(title = "Africa", 
                       plotOutput(outputId = "africa_plot"),
                       sliderInput(inputId = "africa_year", label = "Select Year", 
                                   value = 1952, min = 1952, max = 2007, step = 5, 
                                   animate = animationOptions(interval = 500))
              ), # END Africa tab 
              
              # Americas tab ----
              tabPanel(title = "Americas", 
                       plotOutput(outputId = "americas_plot"),
                       sliderInput(inputId = "americas_year", label = "Select Year", 
                                   value = 1952, min = 1952, max = 2007, step = 5, 
                                   animate = animationOptions(interval = 500))
              ), # END Americas tab
              
              # Asia tab ----
              tabPanel(title = "Asia", 
                       plotOutput(outputId = "asia_plot"),
                       sliderInput(inputId = "asia_year", label = "Select Year", 
                                   value = 1952, min = 1952, max = 2007, step = 5, 
                                   animate = animationOptions(interval = 500))
              ), # END Asia tab
              
              # Europe tab ----
              tabPanel(title = "Europe", 
                       plotOutput(outputId = "europe_plot"),
                       sliderInput(inputId = "europe_year", label = "Select Year", 
                                   value = 1952, min = 1952, 
                                   max = 2007, step = 5, animate = animationOptions(interval = 500))
              ), # END Europe
              
              # Oceania tab ----
              tabPanel(title = "Oceania", 
                       plotOutput(outputId = "oceania_plot"),
                       sliderInput(inputId = "oceania_year", label = "Select Year", 
                                   value = 1952, min = 1952, max = 2007, step = 5, 
                                   animate = animationOptions(interval = 500))
              ) # END Oceania tab
              
  ) # END continent tabsetPanel
  
) # END fluidPage

#.............................server.............................
server <- function(input, output) {
  
  # ---- collect one year of data ----
  ydata_all <- reactive({
    filter(all_data, year == input$all_year)
  })
  
  ydata_africa <- reactive({
    filter(africa_data, year == input$africa_year)
  })
  
  ydata_americas <- reactive({
    filter(americas_data, year == input$americas_year)
  })
  
  ydata_asia <- reactive({
    filter(asia_data, year == input$asia_year)
  })  
  
  ydata_europe <- reactive({
    filter(europe_data, year == input$europe_year)
  })
  
  ydata_oceania <- reactive({
    filter(oceania_data, year == input$oceania_year)
  })
  
  # ---- compute plot ranges ----
  xrange_all <- range(all_data$gdpPercap)
  yrange_all <- range(all_data$lifeExp)
  
  xrange_africa <- range(africa_data$gdpPercap)
  yrange_africa <- range(africa_data$lifeExp)
  
  xrange_americas <- range(americas_data$gdpPercap)
  yrange_americas <- range(americas_data$lifeExp)
  
  xrange_asia <- range(asia_data$gdpPercap)
  yrange_asia <- range(asia_data$lifeExp)
  
  xrange_europe <- range(europe_data$gdpPercap)
  yrange_europe <- range(europe_data$lifeExp)
  
  xrange_oceania <- range(oceania_data$gdpPercap)
  yrange_oceania <- range(oceania_data$lifeExp)
  
  # ---- render plots ----
  
  # render all countries ----
  output$all_plot <- renderPlot({
    
    # draw background plot with legend 
    plot(all_data$gdpPercap, all_data$lifeExp, type = "n", 
         xlab = "GDP per capita", ylab = "Life Expectancy", 
         panel.first = {
           grid()
           text(mean(xrange_all), mean(yrange_all), input$all_year, 
                col = "grey90", cex = 5)
         }
    )
    
    # build legend
    legend("bottomright", legend = levels(all_data$continent), 
           cex = 1.3, inset = 0.01, text.width = diff(xrange_all)/5,
           fill = c("#E41A1C99", "#377EB899", "#4DAF4A99", "#984EA399", "#FF7F0099")
    )
    
    # Determine bubble colors
    cols <- c("Africa" = "#E41A1C99",
              "Americas" = "#377EB899",
              "Asia" = "#4DAF4A99",
              "Europe" = "#984EA399",
              "Oceania" = "#FF7F0099")[ydata_all()$continent]
    
    # add bubbles 
    symbols(ydata_all()$gdpPercap, ydata_all()$lifeExp, 
            circles = sqrt(ydata_all()$pop), bg = cols, inches = 0.5, fg = "white", 
            add = TRUE)
  })
  
  # render africa ----
  output$africa_plot <- renderPlot({
    
    # draw background plot with legend
    plot(africa_data$gdpPercap, africa_data$lifeExp, type = "n", 
         xlab = "GDP per capita", ylab = "Life Expectancy", 
         panel.first = {
           grid()
           text(mean(xrange_africa), mean(yrange_africa), input$africa_year, 
                col = "grey90", cex = 5)
         }
    )
    
    # build legend
    legend("bottomright", legend = levels(africa_data$continent), 
           cex = 1.3, inset = 0.01, text.width = diff(xrange_africa)/5,
           fill = c("#E41A1C99", "#377EB899", "#4DAF4A99", "#984EA399", "#FF7F0099")
    )
    
    # Determine bubble colors
    cols <- c("Africa" = "#E41A1C99",
              "Americas" = "#377EB899",
              "Asia" = "#4DAF4A99",
              "Europe" = "#984EA399",
              "Oceania" = "#FF7F0099")[ydata_africa()$continent]
    
    # add bubbles
    symbols(ydata_africa()$gdpPercap, ydata_africa()$lifeExp, 
            circles = sqrt(ydata_africa()$pop), bg = cols, inches = 0.5, fg = "white", 
            add = TRUE)
  })
  
  # render americas ----
  output$americas_plot <- renderPlot({
    
    # draw background plot with legend
    plot(americas_data$gdpPercap, americas_data$lifeExp, type = "n", 
         xlab = "GDP per capita", ylab = "Life Expectancy", 
         panel.first = {
           grid()
           text(mean(xrange_americas), mean(yrange_americas), input$americas_year, 
                col = "grey90", cex = 5)
         }
    )
    
    # build legend
    legend("bottomright", legend = levels(americas_data$continent), 
           cex = 1.3, inset = 0.01, text.width = diff(xrange_americas)/5,
           fill = c("#E41A1C99", "#377EB899", "#4DAF4A99", "#984EA399", "#FF7F0099")
    )
    
    # Determine bubble colors
    cols <- c("Africa" = "#E41A1C99",
              "Americas" = "#377EB899",
              "Asia" = "#4DAF4A99",
              "Europe" = "#984EA399",
              "Oceania" = "#FF7F0099")[ydata_americas()$continent]
    
    # add bubbles
    symbols(ydata_americas()$gdpPercap, ydata_americas()$lifeExp, 
            circles = sqrt(ydata_americas()$pop), bg = cols, inches = 0.5, fg = "white", 
            add = TRUE)
  })
  
  # render asia ----
  output$asia_plot <- renderPlot({
    
    # draw background plot with legend
    plot(asia_data$gdpPercap, asia_data$lifeExp, type = "n", 
         xlab = "GDP per capita", ylab = "Life Expectancy", 
         panel.first = {
           grid()
           text(mean(xrange_asia), mean(yrange_asia), input$asia_year, 
                col = "grey90", cex = 5)
         }
    )
    
    # build legend
    legend("bottomright", legend = levels(asia_data$continent), 
           cex = 1.3, inset = 0.01, text.width = diff(xrange_asia)/5,
           fill = c("#E41A1C99", "#377EB899", "#4DAF4A99", "#984EA399", "#FF7F0099")
    )
    
    # Determine bubble colors
    cols <- c("Africa" = "#E41A1C99",
              "Americas" = "#377EB899",
              "Asia" = "#4DAF4A99",
              "Europe" = "#984EA399",
              "Oceania" = "#FF7F0099")[ydata_asia()$continent]
    
    # add bubbles
    symbols(ydata_asia()$gdpPercap, ydata_asia()$lifeExp, 
            circles = sqrt(ydata_asia()$pop), bg = cols, inches = 0.5, fg = "white", 
            add = TRUE)
  })
  
  # render europe ----
  output$europe_plot <- renderPlot({
    stop("Error: Don't look at Europe")
    # draw background plot with legend
    plot(europe_data$gdpPercap, europe_data$lifeExp, type = "n", 
         xlab = "GDP per capita", ylab = "Life Expectancy", 
         panel.first = {
           grid()
           text(mean(xrange_europe), mean(yrange_europe), input$europe_year, 
                col = "grey90", cex = 5)
         }
    )
    
    # build legend
    legend("bottomright", legend = levels(europe_data$continent), 
           cex = 1.3, inset = 0.01, text.width = diff(xrange_europe)/5,
           fill = c("#E41A1C99", "#377EB899", "#4DAF4A99", "#984EA399", "#FF7F0099")
    )
    
    # Determine bubble colors
    cols <- c("Africa" = "#E41A1C99",
              "Americas" = "#377EB899",
              "Asia" = "#4DAF4A99",
              "Europe" = "#984EA399",
              "Oceania" = "#FF7F0099")[ydata_europe()$continent]
    
    # add bubbles
    symbols(ydata_europe()$gdpPercap, ydata_europe()$lifeExp, 
            circles = sqrt(ydata_europe()$pop), bg = cols, inches = 0.5, fg = "white", 
            add = TRUE)
  })
  
  # render oceania ----
  output$oceania_plot <- renderPlot({
    
    # draw background plot with legend
    plot(oceania_data$gdpPercap, oceania_data$lifeExp, type = "n", 
         xlab = "GDP per capita", ylab = "Life Expectancy", 
         panel.first = {
           grid()
           text(mean(xrange_oceania), mean(yrange_oceania), input$oceania_year, 
                col = "grey90", cex = 5)
         }
    )
    
    # build legend
    legend("bottomright", legend = levels(oceania_data$continent), 
           cex = 1.3, inset = 0.01, text.width = diff(xrange_oceania)/5,
           fill = c("#E41A1C99", "#377EB899", "#4DAF4A99", "#984EA399", "#FF7F0099")
    )
    
    # Determine bubble colors
    cols <- c("Africa" = "#E41A1C99",
              "Americas" = "#377EB899",
              "Asia" = "#4DAF4A99",
              "Europe" = "#984EA399",
              "Oceania" = "#FF7F0099")[ydata_oceania()$continent]
    
    # add bubbles ----
    symbols(ydata_oceania()$gdpPercap, ydata_oceania()$lifeExp, 
            circles = sqrt(ydata_oceania()$pop), bg = cols, inches = 0.5, fg = "white", 
            add = TRUE)
  })
  
} # END server

# Run the application 
shinyApp(ui = ui, server = server)