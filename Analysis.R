library(tidyverse)

# Load entire dataset
stroke_data <- read_csv("./data/healthcare-dataset-stroke-data.csv")

# Save outcomes separately (as boolean)
outcomes <- stroke_data %>%
            select(stroke) %>%
            mutate(stroke = as.logical(stroke))
# Remove unnecessary columns for classification
stroke_data <- stroke_data %>% select(!c(id, stroke))

# Encode data for summarization and further analysis
stroke_coded <- stroke_data %>%
                mutate(hypertension = as.logical(hypertension),
                       heart_disease = as.logical(heart_disease)) %>%
                mutate(gender = as.factor(gender),
                       ever_married = as.factor(ever_married),
                       work_type = as.factor(work_type),
                       Residence_type = as.factor(Residence_type),
                       smoking_status = as.factor(smoking_status)) %>%
                mutate(bmi = ifelse(bmi == "N/A", 0, bmi)) %>%
                mutate(bmi = as.numeric(bmi)) %>%
                rename(residence_type = Residence_type)

# Summarize data
sink("summary_stroke.txt")
print(summary(stroke_coded), width = 250) # large enough, but could need adjustment with different dataset
sink()

# Get pairwise correlations between numeric attributes
cors <- round(cor(stroke_coded %>% select(where(is.numeric))), 2)
write_csv(as.data.frame(cors), "correlations_stroke.txt")
