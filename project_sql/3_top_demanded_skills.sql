------------------------------------------------------------
-- 3 - What are the most in-demand skills for data analysts?
------------------------------------------------------------
/*
GOALS : 
- Identify the top 5 in-demand skills for a data analyst.
- This will provide insights into the most valuable skills to develop for my job searching.
*/

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

/*
RESULTS INCLUDING REMOTE : 

"skills","demand_count"
"sql","92628"
"excel","67031"
"python","57326"
"tableau","46554"
"power bi","39468"

RESULTS NOT INCLUDING REMOTE : 

"skills","demand_count"
"sql","7307"
"excel","4614"
"python","4342"
"tableau","3753"
"power bi","2612"

Same Trend -- Most useful tools are SQL, Excel & Python 
+ a Vizualisation Tool

*/


