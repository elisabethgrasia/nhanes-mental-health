# nhanes-mental-health

🧠 Population Mental Health Analysis Using NHANES Data
Project Overview


This project demonstrates construction of an analysis-ready population health dataset using publicly available NHANES survey data. Multiple health survey modules were integrated to simulate registry-based epidemiological workflows commonly used in population health research.
The analysis investigates associations between socioeconomic status, physical comorbidity, healthcare access, and depression outcomes.

📊 Data Sources


- Demographics (DEMO)


- Depression Screener (DPQ)


- Medical Conditions (MCQ)


- Health Insurance (HIQ)


---Data obtained from the National Health and Nutrition Examination Survey (NHANES).---

⚙️ Workflow
1. Import and harmonize multi-cycle datasets
2. Construct demographic and socioeconomic variables
3. Create comorbidity index from diagnosed conditions
4. Define depression outcome (PHQ-9 ≥ 10)
5. Merge datasets into analysis-ready cohort
6. Perform logistic regression analysis

📉 Results


Higher socioeconomic status was associated with lower odds of depression, while comorbidity burden and lack of insurance were associated with increased depression risk.

🔁 Reproducibility


Run scripts sequentially:


  01_import_demo.R

  
  02a_import_dpq.R

  
  02b_import_mcq.R

  
  02c_import_hiq.R

  
  03_merge_dataset.R

  
  04_analysis.R
  


🛠 Tools


R, tidyverse, ggplot2, epidemiological modeling


