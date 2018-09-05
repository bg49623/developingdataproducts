
library(shiny)
library(ggvis)
library(rmarkdown)
library(e1071)
library(klaR)
library(kernlab)
library(MASS)
library(dplyr)
library(caret)
library(randomForest)


shinyUI(
      navbarPage("Comparing the 'ML' algorithms through the 'mtcars' Data", 
                 tabPanel("Please select the algorithm as well as the amount of data to use", 
                          sidebarPanel(
                                selectInput("models",
                                            "Choose your ML model:",
                                            choices = c("Random Forest" = "rf", 
                                                        "Naive Bayes" = "nb", 
                                                        "SVM" = "svmRadial", 
                                                        "LDA" = "lda", 
                                                        "CART" = "rpart",
                                                        "K-Nearest Neighbors" = "knn", 
                                                        "Neural Network" = "nnet")),
                                sliderInput("prob", label = "Portion(%) of the Training set: ", 
                                            min = 10, 
                                            max = 100, 
                                            value = 50),
                                div(
                                      actionButton(inputId = "run", 
                                                   label = "Run the Machine Learning"), 
                                      style = "text-align: center;")
                          ),
                          mainPanel(
                                div(
                                      h3("The Scatter Plot of the mtcars Data"),
                                      style = "text-align: center;"), 
                                div(style = "color:red", 
                                    h5(textOutput("plot.title"), align = "center")
                                ),
                                div(align = "center", 
                                    ggvisOutput("resultPlot"), 
                                    uiOutput("resultPlot_ui")
                                ), 
                                div(
                                      h3(textOutput("comp.title"), align = "center"), 
                                      h5(textOutput("comp.explain"), align = "center"), 
                                      style = "text-align: center;"),
                                div(align = "center", 
                                    tableOutput("comp.matrix")
                                ),
                                div(
                                      h3(textOutput("conf.title"), align = "center"), 
                                      h5(textOutput("conf.explain"), align = "center"), 
                                      style = "text-align: center;"),
                                div(align = "center", 
                                    tableOutput("conf.matrix")
                                )
                          )
                 )
                 
      )
)
