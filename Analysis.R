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
ggsave("results/attributes.png", plot = box)

# Get contingency tables between factor/logical attributes against stroke outcome
write.table(table(stroke_coded %>% select(gender, stroke)), "results/contingency_gender.csv")
write.table(table(stroke_coded %>% select(hypertension, stroke)), "results/contingency_hypertension.csv")
write.table(table(stroke_coded %>% select(heart_disease, stroke)), "results/contingency_heart_disease.csv")
write.table(table(stroke_coded %>% select(ever_married, stroke)), "results/contingency_ever_married.csv")
write.table(table(stroke_coded %>% select(work_type, stroke)), "results/contingency_work_type.csv")
write.table(table(stroke_coded %>% select(residence_type, stroke)), "results/contingency_residence_type.csv")
write.table(table(stroke_coded %>% select(smoking_status, stroke)), "results/contingency_smoking_status.csv")

# PCA analysis
pca_results <- prcomp(stroke_coded %>% select(where(is.numeric)), scale = TRUE)
sink("results/pca_stroke.txt")
print(pca_results, width = 250) # large enough, but could need adjustment with different dataset
sink()

# Split data in training (70%) and test (30%) set.
sample_divide <- sample(c(TRUE, FALSE), nrow(stroke_coded), replace = TRUE, prob = c(0.7, 0.3))
stroke_train <- stroke_coded[sample_divide, ]
stroke_test <- stroke_coded[!sample_divide, ]

# Make Multiple Linear Regression Classifier
classifier <- glm(data = stroke_train, stroke ~ hypertension + heart_disease + work_type + smoking_status + age + bmi + avg_glucose_level)
threshold <- classifier$coefficients[1] %>% as.vector()
# Test Classifier
stroke_test_results <- predict(classifier, stroke_test)

stroke_test_results <- data.frame(stroke_test_results, stroke_test$stroke) %>%
                       rownames_to_column(var = "ids") %>%
                       rename(result = stroke_test_results, stroke = stroke_test.stroke) %>%
                       mutate(prediction = ifelse(result > threshold, TRUE, FALSE))

class <- ggplot(stroke_test_results, aes(x = ids, y = result, color = stroke, shape = prediction)) +
         geom_point() +
         geom_hline(yintercept = threshold)
ggsave("results/outcomes.png", plot = class)
