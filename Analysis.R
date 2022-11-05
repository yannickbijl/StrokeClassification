library(tidyverse)

# Load entire dataset
stroke_data <- read_csv("./data/healthcare-dataset-stroke-data.csv")

# Save outcomes separately (as boolean)
outcomes <- stroke_data %>%
            select(stroke) %>%
            mutate(stroke = as.logical(stroke))
# Remove unnecessary columns for classification
stroke_data <- stroke_data %>% select(!c(id, stroke))
