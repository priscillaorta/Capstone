/* Data Cleaning; absents 

Priscilla Orta
03-24-2024
*/


-- Create backup table
CREATE TABLE absents_backup AS
SELECT * FROM absents;


--SELECT * FROM absents;

-------------------------------------------------------------------------------------
             /*      Drop Unnecessary Columns 		*/
-------------------------------------------------------------------------------------

-- The following columns are not needed and will be dropped from the table

ALTER TABLE absents 
DROP COLUMN county,   
DROP COLUMN oos_susp_pct, 
DROP COLUMN district_name,
DROP COLUMN school_name;

-------------------------------------------------------------------------------------
             /* 	 Replace reporting_cat Codes     	*/
-------------------------------------------------------------------------------------

-- change data type for reporting category 
ALTER TABLE absents ALTER COLUMN reporting_cat SET DATA TYPE varchar(50);


-- update reporting category codes for better readability
UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'RB', 'African American');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'RI', 'American Indian or Alaska Native');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'RA', 'Asian');

UPDATE absents 
SET reporting_cat = REPLACE(reporting_cat, 'RD', 'Did not Report');

UPDATE absents 
SET reporting_cat = REPLACE(reporting_cat, 'RP', 'Pacific Islander');

UPDATE absents 
SET reporting_cat = REPLACE(reporting_cat, 'RF', 'Filipino');

UPDATE absents 
SET reporting_cat = REPLACE(reporting_cat, 'RH', 'Hispanic or Latino');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'RT', 'Two or More Races');

UPDATE absents 
SET reporting_cat = REPLACE(reporting_cat, 'RW', 'White'); 

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GM', 'Male'); 

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GF', 'Female');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GX', 'Non-Binary');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GZ', 'Missing Gender');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'SE', 'English Learners');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'SD', 'Students with Disabilities');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'SS', 'Socioeconomically Disadvantaged');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'SM', 'Migrant');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'SF', 'Foster');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'SH', 'Homeless');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GRKN', 'Kindergarten');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GR13', 'Grades 1-3');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GR46', 'Grades 4-6');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GR78', 'Grades 7-8');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GR912', 'Grades 9-12');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GRUG', 'Ungraded Elementary and Secondary');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'TA', 'Total');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'CAY', 'Chronically Absent');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'CAN', 'Not Chronically Absent');

UPDATE absents
SET reporting_cat = REPLACE(reporting_cat, 'GRK8', 'Grades K-8');



-------------------------------------------------------------------------------------
             /* 		   Change Data Types    			*/
-------------------------------------------------------------------------------------

-- change appropriate columns to numeric data type
ALTER TABLE absents ALTER COLUMN eligible_enr SET DATA TYPE numeric USING(eligible_enr::numeric);
ALTER TABLE absents ALTER COLUMN mult_abs_count SET DATA TYPE numeric USING(mult_abs_count::numeric);
ALTER TABLE absents ALTER COLUMN total_absences SET DATA TYPE numeric USING(total_absences::numeric);
ALTER TABLE absents ALTER COLUMN avg_days_absent SET DATA TYPE numeric USING(avg_days_absent::numeric);
ALTER TABLE absents ALTER COLUMN exc_absences_pct SET DATA TYPE numeric USING(exc_absences_pct::numeric);
ALTER TABLE absents ALTER COLUMN unexc_absences_pct SET DATA TYPE numeric USING(unexc_absences_pct::numeric);


-------------------------------------------------------------------------------------
             /* 		   Fix County Code 			*/
-------------------------------------------------------------------------------------

-- fix county code so that they can properly merge with other tables
-- example: in this table Alameda is coded as '1', but in most other tables are 
-- coded as '01'

UPDATE absents
SET county_code = '0' || county_code
WHERE (LENGTH(county_code)<2);


-------------------------------------------------------------------------------------
             /* 		   Foreign Key Assignment 			*/
-------------------------------------------------------------------------------------

-- assign county_code foreign key

ALTER TABLE absents ADD CONSTRAINT cc_code_fkey FOREIGN KEY (county_code) REFERENCES 
counties(county_code);


-------------------------------------------------------------------------------------
             /* 		   Investigate Nulls/Duplicates			*/
-------------------------------------------------------------------------------------

-- check for duplicates
--SELECT ac_year, county_code, district_name, school_name, reporting_cat, eligible_enr, cds_code, 
--COUNT(*)
--FROM absents
--GROUP BY ac_year, county_code, district_name, school_name, reporting_cat, eligible_enr, cds_code
--HAVING COUNT(*) >1;
------ ^ No duplicates

-- check for nulls
--SELECT * FROM absents
--WHERE (eligible_enr, mult_abs_count, avg_days_absent, total_absences, exc_absences_pct, 
	  --unexc_absences_pct) IS NULL;
	  
-- delete data where there are null values in all of eligible_enr, mult_ab_count, avg_days_absent, total_absences, 
-- exc_absences_pct, unexc_absences_pct

DELETE FROM absents
WHERE (eligible_enr, mult_abs_count, avg_days_absent, total_absences, exc_absences_pct, 
	  unexc_absences_pct) IS NULL;
	  