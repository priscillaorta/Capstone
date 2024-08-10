# MS Data Science | Capstone Project
## College Enrollment Analysis

## Project Overview
For this project, I created a database containing information about schools in California. The database was then connected to R, to analyze college enrollment rates among students in California. Visualizations were created to communicate important insights to educational agencies and stakeholders, with the ultimate goal to promote equitable education. 
 

## Data Source
This project utilizes data from the [California Department of Education](https://www.cde.ca.gov/ds/ad/downloadabledata.asp)

## Tools
1. Python/ Jupyter Notebooks
   - Pre-processing
2. PostgreSQL / pgAdmin
   - Database Creation
   - Data Cleaning
   - Queries
3. R (RODBC, DBI, tidyverse)
    - Connection to Database
    - Data Analysis
    - Data visualizations
  
## Database Design 

The database consists of 8 tables:
|Table |Description|
|------|-----------|
|counties| contains information about schools, per county|
|districts| includes location, contact, and descriptive information about each district in California|
|schools| includes location, contact, and descriptive information about each school in California|
|enrollment| includes enrollment counts, per school|
|absents| includes excused and unexcused absent counts, per school|
|ell| includes counts of English language learners and respective languages, per school|
|fr_lunch| includes counts of students who are eligible for free or reduced meal plan, per school|
|graduates| includes counts of graduating students, per school|
|college_gr| includes counts of students who enroll in college within 12 months of graduating, per school|


## Data Cleaning & Prep
Data was processed and prepared prior to loading data into pgAdmin. Pre-processing included:
1. Reformatting tables and columns
2. Map district, county, and school codes
3. Add columns containing Academic School Year
4. Filter aggregate data
   
Once data was loaded into pgAdmin, additional cleaning was performed, including:
1. Changing data types
2. Updating codes for better readability
3. Removing duplicate data
4. Remove missing data

## Analysis
Database was queried to answer questions, such as:
1. Average college enrollment rate in California 
2. College enrollment rates disaggregated by counties, districts, and schools
3. College enrollment rates disaggregated by demographic group
   
Database was then connected to R, and analyses was conducted to:
1. Identify factors correlated with low college enrollment
2. Plot distributions of college enrollment rates among various demographic groups
3. Create visualizations

## Results / Findings
### Factors correlated with college enrollment rates
- Percentage of students who come from low-socio economic backgrounds, percentage of students who are english language learners, and unexcused absents rate are all negatively correlated with college enrollment rate
![scatter_cgr_frmp](https://github.com/user-attachments/assets/6814bd5a-43db-4a20-b6c0-635b464c5907)
![scatter_cgr_ell](https://github.com/user-attachments/assets/60ed875a-1905-41da-9f02-e00b770b06d1)
![scatter_cgr_unexcabs](https://github.com/user-attachments/assets/ae414b4c-0bc1-4540-be15-92b86015b5e0)

### College enrollment rates among demographic groups
- Density plots to visualize the distribution of college enrollment rates among different demographic groups. Asian american, Filipino, and White students demostrate a right-skewed distribution.

![cgr_dems_facet](https://github.com/user-attachments/assets/33e57670-f903-4449-bf15-a2068ef97e41)
- Line chart to visualize college enrollment rates per demographic group, from 2017 - 2021. Asian American students have the highest average college enrollment rate and American Indian / Alaska Native students have lowest average enrollment rates.

![cgr_dems_line](https://github.com/user-attachments/assets/0d346b9d-3e82-412e-8b1d-934297b68d50)


## File Structure
- `All Project Files` contains all files.
- `pre_analysis.ipynb` is a jupyter notebook that contains code that pre processes the data to prepare it for import using pgAdmin.
- `sql_files` contains sql files containing database and table creation statements, code used to clean and manipulate data, and queries used to provide insights.
- `r_files` contains R markdown files that provide a statistical analysis of the data in addition to visualizations created to communicate insights to non-technical audiences.
