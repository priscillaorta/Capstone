/* Data Cleaning; college_gr 

Priscilla Orta
03-25-2024
*/


-- Create backup table
CREATE TABLE cgr_backup AS
SELECT * FROM college_gr;


--SELECT * FROM college_gr

-------------------------------------------------------------------------------------
             /* 		  Drop Unnecessary Columns  		*/
-------------------------------------------------------------------------------------

-- These columns are not needed and will be dropped from the table

ALTER TABLE college_gr
DROP COLUMN school_code,
DROP COLUMN district_code,
DROP COLUMN county_name,
DROP COLUMN school_name, 
DROP COLUMN district_name;


-------------------------------------------------------------------------------------
             /*    Replace reporting_category Codes	*/
-------------------------------------------------------------------------------------

-- change data type for reporting category 
ALTER TABLE college_gr ALTER COLUMN reporting_cat SET DATA TYPE varchar(50);


-- update reporting category codes for better readability
UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'RB', 'African American');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'RI', 'American Indian or Alaska Native');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'RA', 'Asian');

UPDATE college_gr 
SET reporting_cat = REPLACE(reporting_cat, 'RD', 'Did not Report');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'RP', 'Pacific Islander');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'RF', 'Filipino');

UPDATE college_gr 
SET reporting_cat = REPLACE(reporting_cat, 'RH', 'Hispanic or Latino');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'RT', 'Two or More Races');

UPDATE college_gr 
SET reporting_cat = REPLACE(reporting_cat, 'RW', 'White'); 

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'GM', 'Male'); 

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'GF', 'Female');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'GX', 'Non-Binary');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'GZ', 'Missing Gender');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'SE', 'English Learners');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'SD', 'Students with Disabilities');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'SS', 'Socioeconomically Disadvantaged');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'SM', 'Migrant');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'SF', 'Foster');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'SH', 'Homeless');

UPDATE college_gr
SET reporting_cat = REPLACE(reporting_cat, 'TA', 'Total');

-- make sure that all values have been properly updated
--SELECT DISTINCT(reporting_cat)
--FROM college_gr;
	


-------------------------------------------------------------------------------------
              /* 		   Change Data Types			*/
-------------------------------------------------------------------------------------
-- change hs_completers, enr_college, enr_instate, enr_oos, not_enr_college, 
-- uc_enr, csu_enr, ccc_enr, enr_instate_private, enr_oos_4yr, enr_oos_2yr, 
-- cds_code to int
ALTER TABLE college_gr ALTER COLUMN hs_completers SET DATA TYPE int USING(hs_completers::int);
ALTER TABLE college_gr ALTER COLUMN enr_college SET DATA TYPE int USING(enr_college::int); 
ALTER TABLE college_gr ALTER COLUMN enr_instate SET DATA TYPE int USING(enr_instate::int);
ALTER TABLE college_gr ALTER COLUMN enr_oos SET DATA TYPE int USING(enr_oos::int); 
ALTER TABLE college_gr ALTER COLUMN not_enr_college SET DATA TYPE int USING(not_enr_college::int);
ALTER TABLE college_gr ALTER COLUMN uc_enr SET DATA TYPE int USING(uc_enr::int); 
ALTER TABLE college_gr ALTER COLUMN csu_enr SET DATA TYPE int USING(csu_enr::int);
ALTER TABLE college_gr ALTER COLUMN ccc_enr SET DATA TYPE int USING(ccc_enr::int); 
ALTER TABLE college_gr ALTER COLUMN enr_instate_private SET DATA TYPE int USING(enr_instate_private::int);
ALTER TABLE college_gr ALTER COLUMN enr_oos_4yr SET DATA TYPE int USING(enr_oos_4yr::int); 
ALTER TABLE college_gr ALTER COLUMN enr_oos_2yr SET DATA TYPE int USING(enr_oos_2yr::int); 

-- change county code to char(2)
ALTER TABLE college_gr ALTER COLUMN county_code SET DATA TYPE char(2);

-------------------------------------------------------------------------------------
              /* 		   Fix county_code			*/
-------------------------------------------------------------------------------------

-- fix county code so that it can properly be merged with other columns

UPDATE college_gr 
SET county_code = '0' || county_code
WHERE (LENGTH(county_code)<2);



-------------------------------------------------------------------------------------
                /* 		    Assign Foreign Key		*/
-------------------------------------------------------------------------------------

-- assign cc_code as foreign key

ALTER TABLE college_gr ADD CONSTRAINT cc_code_key FOREIGN KEY(county_code)
REFERENCES counties(county_code);


-------------------------------------------------------------------------------------
                /* 	 Investigate Duplicates/Nulls	*/
-------------------------------------------------------------------------------------
-- check for duplicates
--SELECT ac_year, county_code, county_name, district_name, school_name, reporting_cat, completer_type, 
--cds_code,hs_completers, enr_college, cgr, enr_instate, enr_oos, not_enr_college, uc_enr, csu_enr, 
	  --ccc_enr, enr_instate_private, enr_oos_4yr, enr_oos_4yr, enr_oos_2yr, COUNT(*)
--FROM college_gr 
--GROUP BY ac_year, county_code, county_name, district_name, school_name, reporting_cat, completer_type, 
--cds_code, hs_completers, enr_college, cgr, enr_instate, enr_oos, not_enr_college, uc_enr, csu_enr, 
	  --ccc_enr, enr_instate_private, enr_oos_4yr, enr_oos_4yr, enr_oos_2yr
--HAVING COUNT(*)>1;

-- check for nulls
--SELECT *
--FROM college_gr
--WHERE (hs_completers, enr_college, cgr, enr_instate, enr_oos, not_enr_college, uc_enr, csu_enr, 
	  --ccc_enr, enr_instate_private, enr_oos_4yr, enr_oos_4yr, enr_oos_2yr) IS NULL;


-- remove data where all meaningful columns are null
DELETE FROM college_gr WHERE (hs_completers, enr_college, enr_instate, enr_oos, not_enr_college, uc_enr, csu_enr, 
	 ccc_enr, enr_instate_private, enr_oos_4yr, enr_oos_4yr, enr_oos_2yr) IS NULL;
	 

	  