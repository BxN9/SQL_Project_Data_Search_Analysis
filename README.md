# Introduction
Welcome to my SQL Portfolio Project, where I delve into the data job market with a focus on data analyst roles. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.

Check out my SQL queries here: [project_sql folder](/project_sql/).

# Background
The motivation behind this project stemmed from my desire to understand the data analyst job market better. I aimed to discover which skills are paid the most and in demand, making my job search more targeted and effective. 

The data for this analysis is from [Luke Barousse’s SQL Course](https://www.lukebarousse.com/products/sql-for-data-analytics). This data includes details on job titles, salaries, locations, and required skills. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?

# Tools I Used
In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on Montreal (where I live) & remote jobs. This query highlights the high paying opportunities in the field.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    salary_hour_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM
    job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst'  AND 
    (job_location LIKE '%Montreal%' OR job_location = 'Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 1000
```
I collect 604 Results in my Dataset, most of them remote, as the dataset i used includes job postings in Canada, but mostly in USA.


### 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
WITH top_paying_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    company_dim.name AS company_name
FROM
    job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst'  AND 
    (job_location LIKE '%Montreal%' OR job_location = 'Anywhere') AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 1000
)
SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

After running an analysis with the exported result of this query, we can summarize answers in this bar chart : 
![Top Paying Jobs Skills](insert image)
*Bar Chart representing the top 10 skills needed in the posted jobs with the higher salary.
ChatGPT Created this graph using the results of my SQL query.

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    (job_work_from_home = TRUE OR job_location LIKE '%Montreal%') --OPTIONAL

GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5
```
Here is the breakdown of the most demanded skills for Data analyst positions in 2023.


| Skills   | Demand Count |
|----------|--------------|
| SQL      | 92,628       |
| Excel    | 67,031       |
| Python   | 57,326       |
| Tableau  | 46,554       |
| Power BI | 39,468       |

SQL stands out as the top skill.
Excel remains essential.
Python is a powerful tool to master.
Familiarity with a visualization tool like Tableau or Power BI is also crucial.


### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    (job_work_from_home = TRUE OR job_location LIKE '%Montreal%') AND 
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25
```
I built this query to get the average salary per skills.  
I'll use this as a CTE on the next query to precise my search.

Nevertheless, ChatGPT gave me some quick insights and trends from the top-paying skills for data analyst roles based on the provided data by classifying results in different sectors :

**High Demand for Big Data & ML Skills**: Top salaries go to analysts skilled in PySpark, DataRobot, and Python libraries like Pandas, reflecting the industry's focus on data processing and predictive modeling.

**Development & Deployment Expertise**: Proficiency in tools like GitLab and Airflow boosts salaries, emphasizing the value of automating and managing data pipelines.

**Cloud Computing Proficiency**: Skills in Databricks,... highlight the importance of cloud-based analytics, significantly increasing earning potential.


### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
--CTE 1 From Query 3 to get skills demand by job postings
WITH  skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND 
        (job_work_from_home = TRUE OR job_location LIKE '%Montreal%') AND --OPTIONAL
        salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
    )

    ---
    --CTE 2 From Query 4 to get average salaries by skills 
    , average_salary AS (
    SELECT
        skills_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND 
        (job_work_from_home = TRUE OR job_location LIKE '%Montreal%') AND 
        salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
    )

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
    INNER JOIN average_salary ON average_salary.skill_id = skills_demand.skill_id
WHERE
    demand_count > 10
ORDER BY
    demand_count DESC ,  avg_salary DESC
LIMIT 25;
```
Considering that I'm, for now, more interested in the skills demand than the average salary.  
Here is the results i've got, ordered in skills_demand descending order : 

| Skills      | Demand Count | Avg Salary |
|-------------|--------------|------------|
| SQL         | 398          | 97,237     |
| Excel       | 256          | 87,288     |
| Python      | 236          | 101,397    |
| Tableau     | 230          | 99,288     |
| R           | 148          | 100,499    |
| Power BI    | 110          | 97,431     |
| SAS         | 63           | 98,902     |
| SAS         | 63           | 98,902     |
| PowerPoint  | 58           | 88,701     |
| Looker      | 49           | 103,795    |
| Word        | 48           | 82,576     |
| Snowflake   | 37           | 112,948    |
| Oracle      | 37           | 104,534    |
| SQL Server  | 35           | 97,786     |
| Azure       | 34           | 111,225    |
| AWS         | 32           | 108,317    |
| Sheets      | 32           | 86,088     |
| Flow        | 28           | 97,200     |
| Go          | 27           | 115,320    |
| SPSS        | 24           | 92,170     |
| VBA         | 24           | 88,783     |
| Hadoop      | 22           | 113,193    |
| Jira        | 20           | 104,918    |
| JavaScript  | 20           | 97,587     |
| SharePoint  | 18           | 81,634     |

With this information, I can now identify the most in-demand skills to focus on for securing a data analyst position, as well as the most valuable skills to learn to advance my career and expertise in data analysis.

# What I Learned

Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

Each query not only served to answer a specific question but also to improve my understanding of SQL and database analysis. Through this project, I learned to leverage SQL's powerful data manipulation capabilities to derive meaningful insights from complex datasets.

# Conclusions

### **Insights**

From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.


### **Closing Thoughts**

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.



