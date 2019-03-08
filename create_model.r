# IMPORTANT: set the working directory to the location of this script
#setwd("<add your script directory here>")

library(jsonlite)

### Get and Analyze Data
set.seed(123)
x <- 0:49
y <- 5 * x + 2 + rnorm(50, sd = 20)
plot(x, y, col=adjustcolor(col="darkblue", alpha.f=0.3), pch=20)


### Train Model 
model <- lm(y ~ x)


### Test Model
abline(model, col="red")


### Azure Machine Learning Services-related

# define an init() function
# note: we'll let the score.py script call this function when the prediction service is
#       initialized
init <- function() {
}

# define a run() function for AMLS
# note: we'll let the score.py script call this function when the prediction service is used
run <- function(inputJsonString) {
  # load required libraries
  library(jsonlite)
  # get input
  inputJson <- fromJSON(inputJsonString)
  x <- inputJson$x
  # apply model
  y <- as.numeric(predict(model, data.frame(x = x)))
  # return result
  outputJsonString <- paste0('{"y": ', as.character(y), '}')
  return(outputJsonString)
}

# Save model (workspace)
# note: depending on the objects in your workspace, it might make sense
#       to cleanup unused variables first using rm(). alternatively,
#       saving only the required variables.
#
save.image("model.RData")


### Testing

# clean workspace
rm(list=ls())

# load model
load("model.RData")

# invoke init() method
init()

# invoke run() method
cat(run('{"x": 123.45}'))