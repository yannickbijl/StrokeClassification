library(tidyverse)

# Load entire dataset
stroke_data <- read_csv("./data/healthcare-dataset-stroke-data.csv")

# Save outcomes separately (as boolean)
outcomes <- stroke_data %>%
            select(stroke) %>%
            mutate(stroke = as.logical(stroke))
# Remove unnecessary columns for classification
stroke_data <- stroke_data %>% select(!c(id))

# Encode data for summarization and further analysis
stroke_coded <- stroke_data %>%
                mutate(hypertension = as.logical(hypertension),
                       heart_disease = as.logical(heart_disease),
                       stroke = as.logical(stroke)) %>%
                mutate(gender = as.factor(gender),
                       ever_married = as.factor(ever_married),
                       work_type = as.factor(work_type),
                       Residence_type = as.factor(Residence_type),
                       smoking_status = as.factor(smoking_status)) %>%
                mutate(bmi = ifelse(bmi == "N/A", 0, bmi)) %>%
                mutate(bmi = as.numeric(bmi)) %>%
                rename(residence_type = Residence_type)

# Summarize data
sink("results/summary_stroke.txt")
print(summary(stroke_coded), width = 250) # large enough, but could need adjustment with different dataset
sink()

# Get pairwise correlations between numeric attributes
cors <- round(cor(stroke_coded %>% select(where(is.numeric))), 2)
write_csv(as.data.frame(cors), "results/correlations_stroke.txt")

# Visualize difference of stroke outcome between numeric attributes
stroke_long <- stroke_coded %>%
               select(stroke, where(is.numeric)) %>%
               pivot_longer(!stroke)
box <- ggplot(stroke_long, aes(x = name, y = value, color = stroke)) +
       geom_boxplot() +
       xlab("Attribute") +
       ylab("Stroke")
ggsave("results/test.png", plot = box)

# Get contingency tables between factor/logical attributes against stroke outcome
write.table(table(stroke_coded %>% select(gender, stroke)), "results/contingency_gender.csv")
write.table(table(stroke_coded %>% select(hypertension, stroke)), "results/contingency_hypertension.csv")
write.table(table(stroke_coded %>% select(heart_disease, stroke)), "results/contingency_heart_disease.csv")
write.table(table(stroke_coded %>% select(ever_married, stroke)), "results/contingency_ever_married.csv")
write.table(table(stroke_coded %>% select(work_type, stroke)), "results/contingency_work_type.csv")
write.table(table(stroke_coded %>% select(residence_type, stroke)), "results/contingency_residence_type.csv")
write.table(table(stroke_coded %>% select(smoking_status, stroke)), "results/contingency_smoking_status.csv")

pca_results <- prcomp(stroke_coded %>% select(where(is.numeric)), scale = TRUE)
sink("results/pca_stroke.txt")
print(pca_results, width = 250) # large enough, but could need adjustment with different dataset
sink()
