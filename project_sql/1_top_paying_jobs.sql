
-------------------------------------------------
-- 1 - What are the top-paying data analyst jobs?
-------------------------------------------------
/*
GOALS : 
- Identify the top highest-paying Data Analyst roles meeting my criterias.
*/

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
LIMIT 10