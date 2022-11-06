# StrokeClassification
A data science (side-)project to predict patients with stroke.

## Data
Data comes from [Kaggle](https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset).  
There are 5110 observations (patients), each with 12 attributes.  
One attribute is the unique id of the observation, while another is the status of stroke.  
Both these attributes are excluded from the analysis.  
The stroke status will be used to evaluate the classification performance.

## Results
Correlations of numeric attributes shown no well-established links between each other.  
Indicating that all (in combination) could have potential to predict stroke.

| Attribute         | Age  | Avg Glucose Level | BMI  |
|-------------------|:----:|:-----------------:|:----:|
| Age               | 1.00 | 0.24              | 0.22 |
| Avg Glucose Level | 0.24 | 1.00              | 0.08 |
| BMI               | 0.22 | 0.08              | 1.00 |
