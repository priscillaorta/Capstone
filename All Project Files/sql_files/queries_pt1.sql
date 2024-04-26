/* Queries
pt I: high level information about college going rates grouped by county, district, demographic
info, etc.

Priscilla Orta
03-30-2024
*/


-------------------------------------------------------------------------------------
                          /*      Query 1		 */
-------------------------------------------------------------------------------------
--college going rate for the state of California; all demographic groups

SELECT round(AVG((enr_college::numeric/hs_completers::numeric))*100, 2) AS cgr
FROM college_gr;


-------------------------------------------------------------------------------------
                         /*      Query 2		 */
-------------------------------------------------------------------------------------
-- college going rate across California; grouped by demographic info

SELECT reporting_cat, ROUND(AVG((enr_college::numeric/hs_completers::numeric))*100, 2) AS cgr
FROM college_gr
WHERE completer_type = 'TA'
GROUP BY reporting_cat
ORDER BY cgr DESC;


-------------------------------------------------------------------------------------
                         /*      Query 3		 */
-------------------------------------------------------------------------------------
-- percentage of students who enroll in community college

SELECT AVG(ccc_enr::numeric/hs_completers::numeric * 100)
FROM college_gr
WHERE completer_type = 'TA' AND reporting_cat = 'Total';




-------------------------------------------------------------------------------------
                         /*      Query 4		 */
-------------------------------------------------------------------------------------
-- percentage of students who enroll in community college, grouped by demographic info

SELECT reporting_cat, ROUND(AVG(ccc_enr::numeric/hs_completers::numeric * 100), 2) AS ccc_cgr
FROM college_gr
WHERE completer_type = 'TA'
GROUP BY reporting_cat
ORDER BY ccc_cgr;


-------------------------------------------------------------------------------------
                         /*      Query 5		 */
-------------------------------------------------------------------------------------
-- list of schools where college going rate is below state average

SELECT school_name, AVG(enr_college::numeric/hs_completers::numeric * 100) AS cgr
FROM college_gr
JOIN schools
USING(cds_code)
GROUP BY school_name
HAVING AVG(enr_college::numeric/hs_completers::numeric * 100) <
(SELECT AVG(enr_college::numeric/hs_completers::numeric * 100) FROM college_gr)
ORDER BY cgr;



-------------------------------------------------------------------------------------
                         /*      Query 6		 */
-------------------------------------------------------------------------------------
-- the query above reveals that many continuation schools have very low college going rates
-- and may have an impact on the overall average
-- whats the college going rate for California high school students, excluding continuation schools?


SELECT  ROUND(AVG(enr_college::numeric/hs_completers::numeric * 100), 2) AS cgr
FROM college_gr
JOIN schools
USING(cds_code)
WHERE cds_code NOT IN (SELECT cds_code FROM schools WHERE soc_type = 'Continuation High Schools');


-------------------------------------------------------------------------------------
                         /*      Query 7		 */
-------------------------------------------------------------------------------------
-- categorize counties by the average college going rate (ie above average, below 
--average, or within range)

WITH 
	counties_cgr(county_name, cgr) AS 
	(SELECT county_name, ROUND(AVG((enr_college::numeric/hs_completers::numeric)*100), 2)
	FROM counties
	JOIN college_gr
	USING(county_code)
	GROUP BY county_name)
	
SELECT county_name,  
	CASE WHEN cgr < (SELECT AVG(enr_college::numeric/hs_completers::numeric*100)-5 
					FROM college_gr
					JOIN counties
					USING(county_code)) THEN 'Below Average'
		WHEN cgr > (SELECT AVG(enr_college::numeric/hs_completers::numeric*100)+5 
					FROM college_gr
					JOIN counties
					USING(county_code)) THEN 'Above Average'
		ELSE 'Within 5 Percent'
	END AS avg_cat
FROM counties_cgr
ORDER BY county_name;



-------------------------------------------------------------------------------------
                         /*      Query 8		 */
-------------------------------------------------------------------------------------
-- college going rates grouped by county and district; window function to show overall and 
-- withing county ranks


WITH 
	districts_cgr (county_name, district_name, cgr) AS
	(SELECT county_name, district_name, ROUND(AVG(enr_college::numeric/hs_completers::numeric) * 100, 2) AS cgr
	FROM college_gr cgr
	 JOIN schools s
	 USING(cds_code)
	 JOIN districts d
	 USING(district_code)
	JOIN counties co
	ON d.county_code = co.county_code
	GROUP BY county_name, district_name
	)
SELECT county_name, district_name, cgr,
RANK()  OVER (ORDER BY cgr DESC) AS overall_rank,
RANK() OVER (PARTITION BY county_name ORDER BY cgr DESC) AS county_rank
FROM districts_cgr;


					
	