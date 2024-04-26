/* Data Cleaning; ell 

Priscilla Orta
03-24-2024
*/


-- Create backup table
CREATE TABLE ell_backup AS
SELECT * FROM ell;


--SELECT * FROM ell;
-------------------------------------------------------------------------------------
             /*     	  Drop Unnecessary Columns  		*/
-------------------------------------------------------------------------------------

-- These columns can be retrieved from joining with other tables

ALTER TABLE ell 
DROP COLUMN county_name,
DROP COLUMN school_name, 
DROP COLUMN district_name;

-------------------------------------------------------------------------------------
             /* 		 Change Data Types   			*/
-------------------------------------------------------------------------------------

-- change lc to char(2)

ALTER TABLE ell ALTER COLUMN lc SET DATA TYPE char(2);

-------------------------------------------------------------------------------------
             /* 		   Fix Academic Year 			*/
-------------------------------------------------------------------------------------

-- Change academic years to be consistent with other tables for merging purposes

UPDATE ell
SET ac_year = REPLACE(ac_year, '2017-2018', '2017-18');

UPDATE ell
SET ac_year = REPLACE(ac_year, '2018-2019', '2018-19');

UPDATE ell
SET ac_year = REPLACE(ac_year, '2019-2020', '2019-20');

UPDATE ell
SET ac_year = REPLACE(ac_year, '2020-2021', '2020-21');

-------------------------------------------------------------------------------------
            /*  Investigate Discrepencies in cds_codes	*/
-------------------------------------------------------------------------------------

-- get a list of schools where cds_code NOT IN schools
--SELECT DISTINCT(school_name)
--FROM ell
--WHERE cds_code NOT IN (SELECT cds_code FROM schools);


-- this code reveals that there are no matches for these cds_codes in schools table
--SELECT e.school_name, e.cds_code, s.cds_code
--FROM ell e
--JOIN schools s
--ON e.school_name=s.school_name AND e.county_code = s.county_code AND e.district_name = s.district_name
--WHERE e.cds_code NOT IN (SELECT cds_code FROM schools)
--AND e.school_name IN (SELECT school_name FROM schools);


-- this code reveals that the majority of the cases where cds_codes are not in schools table
--are called 'Nonpublic, Nonsectarian Schools'. They also seem to have arbitrary cds_codes where the last 5-6 digits are '00001'
--SELECT school_name, cds_code, COUNT(school_name)
--FROM ell 
--WHERE cds_code NOT IN (SELECT cds_code FROM schools)
--GROUP BY school_name, cds_code
--ORDER BY school_name;

-- we want to preserve these cases in event that they are meaningful for some analyses,
-- however cds_codes will be converted to null for primary/foreign key purposes

UPDATE ell
SET cds_code = NULL
WHERE cds_code NOT IN (SELECT cds_code FROM schools);


-------------------------------------------------------------------------------------
             /* 		   Foreign Key Assignment 			*/
-------------------------------------------------------------------------------------

-- assign cds_code foreign key

ALTER TABLE ell ADD CONSTRAINT cds_code_fkey FOREIGN KEY (cds_code) REFERENCES 
schools(cds_code);

-------------------------------------------------------------------------------------
            /* 	   Investigate duplicates/nulls 			*/
-------------------------------------------------------------------------------------

-- check for duplicates
--SELECT cds_code, county_name, school_name, lc, languages, total_ell, ac_year, county_code, COUNT(*)
--FROM ell 
--GROUP BY cds_code, county_name, school_name, lc, languages, total_ell, ac_year, county_code
--HAVING COUNT(*)>1
-- duplicates represent private schools with no cds_codes

-- check for nulls
--SELECT * FROM ell
--WHERE ( lc, languages, total_ell) IS NULL;
-- ^^ No Nulls


