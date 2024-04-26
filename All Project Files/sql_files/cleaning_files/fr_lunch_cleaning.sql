/* Data Cleaning; fr_lunch 

Priscilla Orta
03-24-2024
*/


-- Create backup table
CREATE TABLE fr_lunch_backup AS
SELECT * FROM fr_lunch;

--SELECT * FROM fr_lunch;
-------------------------------------------------------------------------------------
             /* 	   Drop Unnecessary Columns 			*/
-------------------------------------------------------------------------------------

-- The following columns will be dropped because information can be inferred from other
-- tables/ data not relevant for purposes of this analysis


ALTER TABLE fr_lunch 
DROP COLUMN district_code,
DROP COLUMN county,
DROP COLUMN school_code,
DROP COLUMN school,
DROP COLUMN district,
DROP COLUMN fm_elig_pct,
DROP COLUMN frpm_elig_pct;

-------------------------------------------------------------------------------------
                 /*     Remove '%' and ','  	*/
-------------------------------------------------------------------------------------

-- a number of columns have ',' and '%'. Replace them so they can be converted to 
-- the proper data type


UPDATE fr_lunch 
SET enr = REPLACE(enr, ',', '');

UPDATE fr_lunch 
SET fm_count = REPLACE(fm_count, ',', '');

UPDATE fr_lunch 
SET frpm_count = REPLACE(frpm_count, ',', '');
	

-------------------------------------------------------------------------------------
              /* 		   Change Data Types			*/
-------------------------------------------------------------------------------------

-- change enr, fm_count, frpm_count to int
ALTER TABLE fr_lunch ALTER COLUMN enr SET DATA TYPE int USING(enr::int);
ALTER TABLE fr_lunch ALTER COLUMN fm_count SET DATA TYPE int USING(fm_count::int);
ALTER TABLE fr_lunch ALTER COLUMN frpm_count SET DATA TYPE int USING(frpm_count::int);



-------------------------------------------------------------------------------------
                /* 		    Fix ac_year 			*/
-------------------------------------------------------------------------------------

-- fix academic year so that it matches formatting with other tables for merging

UPDATE fr_lunch
SET ac_year = REPLACE(ac_year, '2017-2018', '2017-18');

UPDATE fr_lunch
SET ac_year = REPLACE(ac_year, '2018-2019', '2018-19');

UPDATE fr_lunch
SET ac_year = REPLACE(ac_year, '2019-2020', '2019-20');

UPDATE fr_lunch
SET ac_year = REPLACE(ac_year, '2020-2021', '2020-21');




-------------------------------------------------------------------------------------
                /* 	  Investigate duplicates/nulls		*/
-------------------------------------------------------------------------------------
-- check for duplicates
--SELECT ac_year, county_code, county, district, school, school_type, ed_type, low_grade, 
--high_grade, cds_code, COUNT(*)
--FROM fr_lunch 
--GROUP BY ac_year, county_code, county, district, school, school_type, ed_type, low_grade, 
--high_grade, cds_code
--HAVING COUNT(*) >1
-- no duplicates

-- check for nulls
--SELECT * FROM fr_lunch 
--WHERE (enr, fm_count, fm_elig_pct, frpm_count, frpm_elig_pct) IS NULL;
-- ^ no nulls in these cases




