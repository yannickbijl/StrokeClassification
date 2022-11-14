# StrokeClassification
A data science (side-)project to predict patients with stroke.

## Data
Data comes from [Kaggle](https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset).  
There are 5110 observations (patients), each with 12 attributes.  
One attribute is the unique id of the observation, while another is the status of stroke.  
Both these attributes are excluded from the analysis.  
The stroke status will be used to evaluate the classification performance.

## Results
Summary of the stroke data shows a large imbalance between the stoke classes with 4861 non-stroke patients and 249 stroke patients.  
Similar imbalances can be seen for the hypertension and heart attack attributes.

Correlations of numeric attributes shown no well-established links between each other.  
Indicating that all (in combination) could have potential to predict stroke.

| Attribute         | Age  | Avg Glucose Level | BMI  |
|-------------------|:----:|:-----------------:|:----:|
| Age               | 1.00 | 0.24              | 0.22 |
| Avg Glucose Level | 0.24 | 1.00              | 0.08 |
| BMI               | 0.22 | 0.08              | 1.00 |

Boxplots of the numeric data show major difference between the TRUE and FALSE classes of stroke for age and avg_glucose_level.
There is no clear difference for bmi. 

![Atrributes](/results/attributes.png)

Contingency tables between stroke and other categorical data show no direct solution for classification.
From these initial results it becomes clear that multiple factors are needed for classification.

A multi-linear regression is used to make a classifier using 70% of the data.
The remaining 30% is used as test data.
The samples are split randomly. For the multi-linear regression the attributes hypertension, heart_disease, work_type, smoking_status, age, bmi, avg_glucose_level are used.
The threshold by the classifier is set at 0.0015.
The resulting classification can be seen in the figure below by the shape.
The color indicates the actual stroke outcome.
The threshold is given as a black solid line in the figure.

![Outcomes](/results/outcomes.png)
