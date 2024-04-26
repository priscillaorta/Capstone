/* Data Cleaning; enrollment 

Priscilla Orta
03-24-2024
*/


-- Create backup table
CREATE TABLE enr_backup AS
SELECT * FROM enrollment;



--SELECT * FROM enrollment;
-------------------------------------------------------------------------------------
             /* 	 Replace Ethnic Codes     	*/
-------------------------------------------------------------------------------------

-- change data type; ethnic

ALTER TABLE enrollment ALTER COLUMN ethnic SET DATA TYPE varchar(50);


-- update ethnic codes for better readability
UPDATE enrollment
SET ethnic = REPLACE(ethnic, '0', 'Not reported');

UPDATE enrollment
SET ethnic = REPLACE(ethnic, '1', 'American Indian or Alaska Native');

UPDATE enrollment
SET ethnic = REPLACE(ethnic, '2', 'Asian');

UPDATE enrollment 
SET ethnic = REPLACE(ethnic, '3', 'Pacific Islander');

UPDATE enrollment 
SET ethnic = REPLACE(ethnic, '4', 'Filipino');

UPDATE enrollment 
SET ethnic = REPLACE(ethnic, '5', 'Hispanic or Latino');

UPDATE enrollment 
SET ethnic = REPLACE(ethnic, '6', 'African American'); 

UPDATE enrollment 
SET ethnic = REPLACE(ethnic, '7', 'White'); 

UPDATE enrollment 
SET ethnic = REPLACE(ethnic, '9', 'Two or More Races, Not Hispanic');


-------------------------------------------------------------------------------------
             /* 	  Drop Unnecessary Columns 		*/
-------------------------------------------------------------------------------------

-- The following columns are not needed and will be dropeed from the table

ALTER TABLE enrollment 
DROP COLUMN county_name,
DROP COLUMN ungr_sec_enr,
DROP COLUMN district_name, 
DROP COLUMN school_name;

  
-------------------------------------------------------------------------------------
        /* 	  Investigate discrepancies in cds_code 		*/
-------------------------------------------------------------------------------------

-- some cds_codes in enrollment dont exist in schools table; correct this issue for
-- a valid Primary/Foreign Key relationship

-- get a list of schools where cds_code is not in schools table
--SELECT *
--FROM enrollment 
--WHERE cds_code NOT IN (SELECT cds_code FROM schools);


-- get a list of schools where cds_code IS NOT in schools BUT school_name IS
--SELECT DISTINCT(school_name), cds_code
--FROM enrollment 
--WHERE cds_code NOT IN (SELECT cds_code FROM schools)
--AND school_name IN (SELECT school_name FROM schools);


-- this code reveals that there are some discrepancies between school and ell cds_codes

--SELECT e.school_name, e.cds_code, s.cds_code
--FROM enrollment e
--JOIN schools s
--ON e.school_name=s.school_name AND e.county_code = s.county_code AND e.district_name = s.district_name
--WHERE e.cds_code NOT IN (SELECT cds_code FROM schools)
--AND e.school_name IN (SELECT school_name FROM schools);

-- update cases where cds_codes in enrollment are not accurate

--UPDATE enrollment
--SET cds_code = (SELECT cds_code FROM schools 
			   --WHERE schools.school_name = enrollment.school_name
			   --AND schools.county_code = enrollment.county_code)
--WHERE cds_code NOT IN (SELECT cds_code FROM schools)
--AND school_name IN (SELECT school_name FROM schools);

-- check remaining cases where cds_code not in schools

--SELECT * FROM enrollment
--WHERE cds_code NOT IN (SELECT cds_school FROM schools);


-- this code reveals that the majority of these cases are called 'Nonpublic, Nonsectarian Schools'
-- they also seem to have arbitrary cds_codes where the last 5-6 digits are '00001'
--SELECT school_name, cds_code, COUNT(school_name)
--FROM enrollment 
--WHERE cds_code NOT IN (SELECT cds_code FROM schools)
--GROUP BY school_name, cds_code
--ORDER BY school_name
;

-- we want to preserve these cases in the event that they are meaningful for some analyses,
-- however cds_codes will be converted to null for primary/foreign key purposes
UPDATE enrollment 
SET cds_code = NULL
WHERE cds_code NOT IN (SELECT cds_code FROM schools);
				

-------------------------------------------------------------------------------------
             /* 	  Assign Foreign Keys     	*/
-------------------------------------------------------------------------------------

-- assign cds_code foreign key
ALTER TABLE enrollment ADD CONSTRAINT cds_fkey FOREIGN KEY (cds_code)
REFERENCES schools(cds_code);


-------------------------------------------------------------------------------------
             /* 	 Check for duplicates/nulls   	*/
-------------------------------------------------------------------------------------

-- check for duplicates
--SELECT cds_code, district_name, school_name, ethnic, gender, ac_year, county_code,  COUNT(*)
--FROM enrollment 
--GROUP BY cds_code, district_name, school_name, ethnic, gender, ac_year, county_code
--HAVING COUNT(*) >1;
-- ^^ this code reveals that there are no duplicates

-- check for nullS
--SELECT *
--FROM enrollment
--WHERE (kin_enr,gr1_enr ,gr2_enr, gr4_enr, gr5_enr, gr6_enr, gr7_enr, gr8_enr, gr9_enr, 
	  --gr10_enr, gr11_enr, gr12_enr, enr_total, adult_enr) IS NULL;
-- ^ this code reveals that there are no instances where every value here is null





