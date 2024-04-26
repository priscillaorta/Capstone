/* Queries
part II
detailed information about enrollment, graduation, free or reduced meal plan students, 
absences, etc.

Priscilla Orta
03-30-2024
*/



-------------------------------------------------------------------------------------
                          /*      Query 1		 */
-------------------------------------------------------------------------------------
-- enrollment rates and pct change of enrollment per high school/academic year


SELECT enr_19.school_name,
((enr_total_20::numeric-enr_total_19::numeric)/enr_total_20::numeric*100) AS pct_change_19_20,  
((enr_total_21::numeric-enr_total_20::numeric)/enr_total_21::numeric*100) AS pct_change_20_21
FROM
	(SELECT cds_code, s.school_name, SUM(enr_total) AS enr_total_19
	FROM enrollment e
	JOIN schools s
	USING(cds_code)
	WHERE ac_year = '2018-19' AND 
	soc_type IN ('High Schools (Public)', 'High Schools in 1 School Dist')
	GROUP BY cds_code, s.school_name) AS enr_19
JOIN
	(SELECT cds_code, s.school_name, SUM(enr_total) AS enr_total_20
	FROM enrollment e
	JOIN schools s
	USING(cds_code)
	WHERE ac_year = '2019-20' AND 
	soc_type IN ('High Schools (Public)', 'High Schools in 1 School Dist')
	GROUP BY cds_code, s.school_name) AS enr_20
	USING(cds_code)
JOIN
	(SELECT cds_code, s.school_name, SUM(enr_total) AS enr_total_21
	FROM enrollment e
	JOIN schools s
	USING(cds_code)
	WHERE ac_year = '2020-21' AND 
	soc_type IN ('High Schools (Public)', 'High Schools in 1 School Dist')
	GROUP BY cds_code, s.school_name) AS enr_21
	USING(cds_code)
ORDER BY pct_change_20_21 DESC;

-------------------------------------------------------------------------------------
                         /*      Query 2		 */
-------------------------------------------------------------------------------------
-- grad counts and pct change of grad counts per academic year/county

WITH 
	grads_19(county_name, total_grads_19) AS 
	(SELECT county_name, SUM(grad_count)
	FROM graduates
	JOIN counties
	USING(county_code)
	WHERE reporting_cat = 'Total' AND ac_year = '2018-19'
	GROUP BY county_name),
	
	grads_20(county_name, total_grads_20) AS 
	(SELECT county_name, SUM(grad_count)
	FROM graduates
	JOIN counties
	USING(county_code)
	WHERE reporting_cat = 'Total' AND ac_year = '2019-20'
	GROUP BY county_name),
	
	grads_21(county_name, total_grads_21) AS
	(SELECT county_name, SUM(grad_count)
	FROM graduates
	JOIN counties
	USING(county_code)
	WHERE reporting_cat = 'Total' AND ac_year = '2020-21'
	GROUP BY county_name)
	
SELECT grads_19.county_name, 
((total_grads_20::numeric-total_grads_19::numeric)/total_grads_19::numeric*100) AS pct_chg_19_20, 
((total_grads_21::numeric-total_grads_20::numeric)/total_grads_20::numeric*100) AS pct_chg_20_21
FROM grads_19
JOIN grads_20
USING(county_name)
JOIN grads_21 
USING(county_name)
ORDER BY pct_chg_20_21;


-------------------------------------------------------------------------------------
                         /*      Query 3		 */
-------------------------------------------------------------------------------------
-- average percent of students who are eligible for a reduced meal plan, unexcused absence
-- rate, and college going rate, per county

SELECT county_name, ROUND(AVG(frpm_count::numeric/enr::numeric)*100, 2) AS avg_frmp_elig, 
ROUND(AVG(unexc_absences_pct), 2) AS avg_unexc_abs, 
ROUND(AVG((enr_college::numeric/hs_completers::numeric)*100), 2) AS avg_cgr
FROM fr_lunch 
JOIN absents
USING(cds_code)
JOIN college_gr
USING(cds_code)
JOIN counties
ON college_gr.county_code = counties.county_code
GROUP BY county_name
ORDER BY avg_cgr; 


-------------------------------------------------------------------------------------
                         /*      Query 4		 */
-------------------------------------------------------------------------------------
-- get correlation between unexcused absent rate, frmp eligible and cgr

WITH 
	cgr (cds_code, cgr) AS
	(SELECT cds_code, AVG(enr_college::numeric/ hs_completers::numeric * 100) AS college_gr
	 FROM college_gr
	 GROUP BY cds_code), 
	 
	 absences (cds_code, unexc_abs_pct) AS 
	 (SELECT cds_code, AVG(unexc_absences_pct)
	  FROM absents
	  GROUP BY cds_code), 
	 
	 frmp (cds_code, frmp_elig) AS 
	 (SELECT cds_code, AVG(frpm_count::numeric/enr::numeric * 100) AS frmp_elig
	 FROM fr_lunch
	 WHERE enr > 0
	 GROUP BY cds_code)
	 
SELECT corr(unexc_abs_pct, cgr) AS abs_cgr_corr, corr(frmp_elig, cgr) AS frmp_cgr_corr
FROM cgr
JOIN absences
ON cgr.cds_code = absences.cds_code
JOIN frmp
ON absences.cds_code = frmp.cds_code;


-------------------------------------------------------------------------------------
                         /*      Query 5		 */
-------------------------------------------------------------------------------------
-- filter schools that are active and get the respective unexcused absence percentage

SELECT county_name, district_name, school_name, street, city, zip,  
AVG(unexc_absences_pct) AS unexc_abs_avg
FROM schools s
LEFT JOIN 
absents ab
USING(cds_code)
JOIN counties co
ON ab.county_code = co.county_code
WHERE status_type = 'Active'
GROUP BY county_name, district_name, school_name, street, city, zip
ORDER BY unexc_abs_avg DESC;

-- NOTE: many unexcused absence percentages are 100 pct and 0 percent, which seems very unlikely
-- questions the validity of the absents data. Better data collection for these schools?

-------------------------------------------------------------------------------------
                         /*      Query 6		 */
-------------------------------------------------------------------------------------
-- get from fr lunch where the percentage of students that are eligible for reduced meal plan 
-- is above average and the college going rate is ALSO above average
-- get descriptive info about the schools

WITH 
	frmp_elig(cds_code, avg_frmp) AS
	(SELECT cds_code, AVG(frpm_count::numeric/enr::numeric * 100)
	FROM fr_lunch
	GROUP BY cds_code
	HAVING AVG(frpm_count::numeric/enr::numeric * 100) > 
	(SELECT AVG(frpm_count::numeric/enr::numeric * 100) FROM fr_lunch)),
	
	cgr(cds_code, avg_cgr) AS
	(SELECT cds_code, AVG(enr_college::numeric/hs_completers::numeric * 100) AS avg_cgr
	FROM college_gr
	GROUP BY cds_code
	 HAVING AVG(enr_college::numeric/hs_completers::numeric * 100) > 
	 (SELECT AVG(enr_college::numeric/hs_completers::numeric * 100) FROM college_gr)),
	
	school_info(cds_code, district_name, school_name, city, soc_type, ed_ops_name, eil_name,
				gs_offered, virtual, year_round) AS
				(SELECT cds_code, district_name, school_name, city, soc_type, ed_ops_name, eil_name, 
				gs_offered, virtual, year_round FROM schools)
				
SELECT district_name, school_name, city, soc_type, ed_ops_name, eil_name, 
gs_offered, virtual, year_round, ROUND(avg_frmp, 2) AS avg_frmp, ROUND(avg_cgr, 2) AS avg_cgr
FROM frmp_elig
JOIN cgr
USING(cds_code)
JOIN school_info
ON cgr.cds_code = school_info.cds_code;



/* note: need to run this code to remove inaccuracies/ allow for calculations before running query^

DELETE FROM fr_lunch 
WHERE enr = 0 

deletes 6 instances where enr = 0 & solves division by 0 error
*/


	
-------------------------------------------------------------------------------------
                         /*      Query 7		 */
-------------------------------------------------------------------------------------
-- percentage of english language learners enrolled in schools,  grouped by
-- academic year/county

WITH 
	ell_counties(county_name, ac_year, languages, sum_ell) AS
	(SELECT county_name, ac_year, languages, SUM(total_ell) as sum_ell
	FROM ell
	JOIN counties
	USING(county_code)
	GROUP BY county_name, ac_year, languages), 
	
	enr_counties(county_name, ac_year, sum_enr) AS
	(SELECT county_name, ac_year, SUM(enr_total) AS sum_enroll
	FROM enrollment
	JOIN counties
	USING(county_code)
	GROUP BY county_name, ac_year) 
	
SELECT ell_counties.county_name, ell_counties.ac_year, languages,
ROUND((sum_ell::numeric/sum_enr::numeric)*100, 2) AS pct_ell
FROM ell_counties
JOIN enr_counties
USING(county_name, ac_year)
ORDER BY pct_ell DESC;
