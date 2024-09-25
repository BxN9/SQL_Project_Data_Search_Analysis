-----------------------------------------------
-- 4 - What are the top skills based on salary?
-----------------------------------------------
/*
GOALS : 
- Look at the average salary associated with each skill for Data Analyst positions.
- This will reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve.
*/

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

/*
CHAT GPT 
PROMPT : Here are top paying skills for data analysts, the top 25. 
Can you provide some quick insights into some trends into the top paying jobs 
+ JSON EXPORT the result of the Query 4 Above

RESULTS : 

Here are some quick insights and trends from the top-paying skills for data analyst roles based on the provided data:

### 1. **Big Data and Distributed Computing Technologies**:
   - **PySpark** ($208,172) is the top-paying skill, highlighting the demand for distributed computing frameworks that can handle large datasets.
   - **Databricks** ($141,907) also ranks high, showing the growing importance of cloud-based data engineering platforms.

### 2. **Version Control Systems**:
   - **Bitbucket** ($189,155) and **GitLab** ($154,500) are high-paying skills, emphasizing the value of knowledge in version control systems and collaboration tools in data teams.
   
### 3. **Cloud and Containerization**:
   - **Kubernetes** ($132,500) and **GCP** ($122,500) reflect the increasing reliance on cloud infrastructure and container orchestration for scaling data applications.
   
### 4. **AI and Machine Learning Platforms**:
   - Tools like **DataRobot** ($155,486) and **Watson** ($160,515) rank high, indicating the demand for expertise in machine learning automation and AI platforms.

### 5. **Programming Languages and Frameworks**:
   - **Swift** ($153,750), **Golang** ($145,000), and **Scala** ($124,903) suggest that knowledge of diverse programming languages is highly valued, particularly for developing data-centric applications.

### 6. **Data Science Libraries**:
   - **Pandas** ($151,821), **NumPy** ($143,513), and **scikit-learn** ($125,781) are essential data science and machine learning libraries, underscoring their importance in analytics and data manipulation.

### 7. **DevOps and CI/CD**:
   - **Jenkins** ($125,436) and **Airflow** ($126,103) reflect the need for automating data pipelines and continuous integration/deployment in data workflows.

### 8. **Database Technologies**:
   - **Couchbase** ($160,515) and **PostgreSQL** ($123,879) suggest that both NoSQL and SQL databases are critical, especially in handling large and diverse datasets.

### 9. **Visualization and Communication**:
   - **Jupyter** ($152,777) is a popular tool for data exploration and communication, indicating its high value for creating reproducible analysis.

### Summary:
   - The highest-paying roles often demand **big data**, **cloud computing**, **AI/ML platforms**, and **DevOps** tools. Skills in cloud infrastructure (Kubernetes, GCP), big data frameworks (PySpark, Databricks), and machine learning tools (Watson, DataRobot) are highly valued, along with core data science libraries (Pandas, NumPy) and programming languages (Swift, Scala).


*/


