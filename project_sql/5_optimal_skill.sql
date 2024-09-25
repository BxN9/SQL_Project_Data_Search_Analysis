--------------------------------------------------
-- 5 - What are the most optimal skills to learn ?
--------------------------------------------------
/*
FINAL QUERY REGROUPING PREVIOUS RESULTS 

GOALS : 
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- This will help me Targets skills that offer high job demand and high salaries, offering strategic insights for career development in data analysis
*/

---
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

/*
RESULTS : 

ORDER BY SALARY DESC : 
"skill_id","skills","demand_count","avg_salary"
8,"go","27","115320"
234,"confluence","11","114210"
97,"hadoop","22","113193"
80,"snowflake","37","112948"
74,"azure","34","111225"
77,"bigquery","13","109654"
76,"aws","32","108317"
4,"java","17","106906"
194,"ssis","12","106683"
233,"jira","20","104918"
79,"oracle","37","104534"
185,"looker","49","103795"
2,"nosql","13","101414"
1,"python","236","101397"
5,"r","148","100499"
78,"redshift","16","99936"
187,"qlik","13","99631"
182,"tableau","230","99288"
197,"ssrs","14","99171"
92,"spark","13","99077"
13,"c++","11","98958"
186,"sas","63","98902"
7,"sas","63","98902"
61,"sql server","35","97786"
9,"javascript","20","97587"

ORDER BY SKILLS DEMAND DESC: 
"skill_id","skills","demand_count","avg_salary"
0,"sql","398","97237"
181,"excel","256","87288"
1,"python","236","101397"
182,"tableau","230","99288"
5,"r","148","100499"
183,"power bi","110","97431"
7,"sas","63","98902"
186,"sas","63","98902"
196,"powerpoint","58","88701"
185,"looker","49","103795"
188,"word","48","82576"
80,"snowflake","37","112948"
79,"oracle","37","104534"
61,"sql server","35","97786"
74,"azure","34","111225"
76,"aws","32","108317"
192,"sheets","32","86088"
215,"flow","28","97200"
8,"go","27","115320"
199,"spss","24","92170"
22,"vba","24","88783"
97,"hadoop","22","113193"
233,"jira","20","104918"
9,"javascript","20","97587"
195,"sharepoint","18","81634"

