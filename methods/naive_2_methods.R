library(klaR)

predict_naive_klaR <- function(model, train, test, optimizecutoff){
  if (optimizecutoff){
    prob <- predict(model, newdata = train)$posterior
    cutoff <- InformationValue::optimalCutoff(actuals = as.numeric(train$answer) - 1, 
                                              predictedScores = prob[, 2], 
                                              optimiseFor = "Both")
    prob <- predict(model, newdata = test)$posterior
    pred <- factor(ifelse(prob[, 2] >= cutoff, levels(train$answer)[2], 
                  levels(train$answer)[1]), levels = levels(train$answer))
    prob <- prob[, 2]
  }
  else{
    cutoff <- 0.5
    prob <- predict(model, newdata = test)$posterior
    pred <- factor(ifelse(prob[, 2] >= cutoff, levels(train$answer)[2], 
                          levels(train$answer)[1]), levels = levels(train$answer))
    prob <- prob[, 2]
  }
  return(list(pred = pred, prob = prob, cutoff = cutoff))
}


naive_bayes_2 <- function(train, test, optimizecutoff = FALSE, ...) {
  model <- klaR::NaiveBayes(answer ~ ., data = train)
  predict_naive_klaR(model, train, test, optimizecutoff)
}
