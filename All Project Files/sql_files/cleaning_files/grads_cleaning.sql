/* Data Cleaning; graduates 

Priscilla Orta
03-25-2024
*/


-- Create backup table
CREATE TABLE grads_backup AS
SELECT * FROM graduates;


--SELECT * FROM graduates;
-------------------------------------------------------------------------------------
             /* 		   Drop unnecessary columns  			*/
-------------------------------------------------------------------------------------

-- These columns are not needed and will be dropped from the table

ALTER TABLE graduates 
DROP COLUMN district_name,
DROP COLUMN district_code, 
DROP COLUMN county_name,
DROP COLUMN school_name;


-------------------------------------------------------------------------------------
             /*    Replace reporting_category Codes	*/
-------------------------------------------------------------------------------------
-- change data type for reporting category 
ALTER TABLE graduates ALTER COLUMN reporting_cat SET DATA TYPE varchar(50);


-- update reporting_category codes for better readability
UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'RB', 'African American');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'RI', 'American Indian or Alaska Native');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'RA', 'Asian');

UPDATE graduates 
SET reporting_cat = REPLACE(reporting_cat, 'RD', 'Did not Report');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'RP', 'Pacific Islander');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'RF', 'Filipino');

UPDATE graduates 
SET reporting_cat = REPLACE(reporting_cat, 'RH', 'Hispanic or Latino');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'RT', 'Two or More Races');

UPDATE graduates 
SET reporting_cat = REPLACE(reporting_cat, 'RW', 'White'); 

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'GM', 'Male'); 

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'GF', 'Female');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'GX', 'Non-Binary');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'GZ', 'Missing Gender');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'SE', 'English Learners');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'SD', 'Students with Disabilities');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'SS', 'Socioeconomically Disadvantaged');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'SM', 'Migrant');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'SF', 'Foster');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'SH', 'Homeless');

UPDATE graduates
SET reporting_cat = REPLACE(reporting_cat, 'TA', 'Total');



-------------------------------------------------------------------------------------
              /* 		   Remove Commas			*/
-------------------------------------------------------------------------------------

-- remove commas in grad_count to prepare for changing data type

UPDATE graduates 
SET grad_count = REPLACE(grad_count, ',', '');

-------------------------------------------------------------------------------------
              /* 		   Change Data Types			*/
-------------------------------------------------------------------------------------

-- change grad_count to int

ALTER TABLE graduates ALTER COLUMN grad_count SET DATA TYPE int USING(grad_count::int);


-------------------------------------------------------------------------------------
                /* 		 Check for Duplicates/Nulls		*/
-------------------------------------------------------------------------------------

-- check for duplicates
--SELECT ac_year, county_code, district_name, school_name, grad_count, reporting_cat, cds_code, COUNT(*)
--FROM graduates
--GROUP BY ac_year, county_code, school_name, reporting_cat, cds_code, district_name, grad_count
--HAVING COUNT(*) >1;
-- No duplicates here

-- check for NULLS
--SELECT * FROM graduates
--WHERE grad_count IS NULL;
-- no nulls here ^