library(shiny)
shinyServer(function(input, output) {
      data(mtcars)
      result_mtcars <- mtcars 
      result_mtcars$Predicted <- mtcars$mpg
      models <- data.frame(comm = c("rf", "nb", "svmRadial", "lda", "rpart", "knn", "nnet"), 
                           model.name = c("Random Forest", 
                                          "Naive Bayes", 
                                          "SVM", 
                                          "LDA", 
                                          "CART", 
                                          "K-Nearest Neighbors", 
                                          "Neural Network"))
      
      observeEvent(input$run, {
            index <- createDataPartition(mtcars$mpg, list = F, p = input$prob / 100)
            fit <- train(mpg ~ ., method = input$models, data = mtcars[index, ])
            result_mtcars$Predicted <- predict(fit, newdata = mtcars[, -1])
            result_mtcars$result <- c(result_mtcars$mpg == result_mtcars$Predicted)
            result_mtcars$result[result_mtcars$result == T] <- "Right"
            result_mtcars$result[result_mtcars$result == F] <- "Error"
            m.name <- models$model.name[models$comm == input$models]        
            output$plot.title <- renderText(paste("Predicted using the", m.name))
            output$comp.title <- renderText("Comparison Table")
            output$comp.explain <- renderText(
                  "The horizontal axis is the Predicted value, and The vertical axis is the Original value.")
            output$comp.matrix <- renderTable({
                  with(result_mtcars, confusionMatrix(mpg, wt)$table)
            })
            
            
            result_mtcars %>% 
                  ggvis(~mpg, ~wt, 
                        fill = ~Predicted, opacity := 0.3, 
                        shape = ~result, 
                        size := 150) %>% 
                  layer_points() %>% 
                  add_legend("shape", orient = "left", title = "Predictions") %>% 
                  bind_shiny("resultPlot", "resultPlot_ui")
      })
      
      reactive ({
            result_mtcars %>% 
                  ggvis(~mpg, ~wt, 
                        fill = ~Predicted, opacity := 0.8, 
                        size := 150) %>% 
                  layer_points()
      }) %>% bind_shiny("resultPlot", "resultPlot_ui")
})
