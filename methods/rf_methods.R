library(randomForest)


predict_rf <- function(model, train, test, optimizecutoff){
  if (optimizecutoff){
    prob <- predict(model, newdata = train, type = "prob")
    cutoff <- InformationValue::optimalCutoff(actuals = as.numeric(train$answer) - 1, 
                                              predictedScores = prob[, 2], 
                                              optimiseFor = "Both")
    prob <- predict(model, newdata = test, type = "prob")
    pred <- factor(ifelse(prob[, 2] >= cutoff, levels(train$answer)[2], 
                  levels(train$answer)[1]), levels = levels(train$answer))
    prob <- prob[, 2]
  }
  else{
    cutoff <- 0.5
    prob <- predict(model, newdata = test, type = "prob")
    pred <- factor(ifelse(prob[, 2] >= cutoff, levels(train$answer)[2], 
                          levels(train$answer)[1]), levels = levels(train$answer))
    prob <- prob[, 2]
  }
  return(list(pred = pred, prob = prob, cutoff = cutoff))
}


rf_1 <- function(train, test, optimizecutoff = FALSE){
  model <- randomForest(answer ~ ., data = train, nodesize = 1, ntree = 100, mtry = round(sqrt(NCOL(train))) + 1)
  predict_rf(model, train, test, optimizecutoff)
}

rf_2 <- function(train, test, optimizecutoff = FALSE){
  model <- randomForest(answer ~ ., data = train, nodesize = 1, ntree = 200, mtry = round(sqrt(NCOL(train))))
  predict_rf(model, train, test, optimizecutoff)
}
