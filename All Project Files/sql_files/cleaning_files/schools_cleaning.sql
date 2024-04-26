 /* Data Cleaning; schools

Priscilla Orta
03-23-2024
*/


-- Create backup table
CREATE TABLE schools_backup AS
SELECT * FROM schools;


--SELECT * FROM schools;

-------------------------------------------------------------------------------------
             /*       Remove Unnecessary Columns    	*/
-------------------------------------------------------------------------------------


-- Delete unneeded columns;
ALTER TABLE schools
DROP COLUMN county_name,
DROP COLUMN st,
DROP COLUMN fax; 


-------------------------------------------------------------------------------------
          /* 		   Change Data Types    			*/
-------------------------------------------------------------------------------------


-- change latitude and longitude columns to numeric data type
ALTER TABLE schools ALTER COLUMN latitude SET DATA TYPE numeric USING(latitude::numeric);
ALTER TABLE schools ALTER COLUMN longitude SET DATA TYPE numeric USING(longitude::numeric); 

-- change last_update, open_date, and close_date to date data type
ALTER TABLE schools ALTER COLUMN last_update SET DATA TYPE date USING(last_update::date); 
ALTER TABLE schools ALTER COLUMN open_date SET DATA TYPE date USING(open_date::date); 
ALTER TABLE schools ALTER COLUMN close_date SET DATA TYPE date USING(close_date::date); 

-- change soc column to char(2)
ALTER TABLE schools ALTER COLUMN soc SET DATA TYPE char(2);
 
 
-------------------------------------------------------------------------------------
             /* 		   Add Column     			*/
-------------------------------------------------------------------------------------
-- add district code column for Primary/Foreign Key Relationship
ALTER TABLE schools ADD COLUMN district_code varchar(12);

-- update column to include district_code from district table
UPDATE schools
SET district_code = (SELECT district_code
					FROM districts 
					WHERE districts.district = schools.district_name
					AND districts.county_code = schools.county_code);
					

-------------------------------------------------------------------------------------
       /* 		   Assign District Code Foreign Key    			*/
-------------------------------------------------------------------------------------

-- Assign District Code as Foreign Key
ALTER TABLE schools ADD CONSTRAINT district_code_fkey FOREIGN KEY (district_code)
REFERENCES districts(district_code);


-------------------------------------------------------------------------------------
             /* 		   Fix gs_offered    			*/
-------------------------------------------------------------------------------------


-- The following code reveals that many values have been miscoded as dates
-- ie 10-Jun should be 6-10

--SELECT DISTINCT(gs_offered)
--FROM schools;


-- replace values that have 'Jan', with '1-'
UPDATE schools 
SET gs_offered = '1-' || gs_offered
WHERE gs_offered LIKE '%Jan';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Jan';

-- replace values that have 'Feb', with '2-'
UPDATE schools
SET gs_offered = '2-' || gs_offered
WHERE gs_offered LIKE '%Feb';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Feb';

-- replace values that have 'Mar', with '3-'
UPDATE schools 
SET gs_offered = '3-' || gs_offered 
WHERE gs_offered LIKE '%Mar';

UPDATE schools 
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Mar';

-- replace values that have 'Apr' with '4-'
UPDATE schools 
SET gs_offered = '4-' || gs_offered 
WHERE gs_offered LIKE '%Apr';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Apr';

-- replace values that have 'May' with '5-'
UPDATE schools 
SET gs_offered = '5-' || gs_offered 
WHERE gs_offered LIKE '%May';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%May';

-- replace values that have 'Jun' with '6-'
UPDATE schools
SET gs_offered = '6-' || gs_offered
WHERE gs_offered LIKE '%Jun';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Jun';

-- replace values that have 'Jul' with '7-'
UPDATE schools
SET gs_offered = '7-' || gs_offered 
WHERE gs_offered LIKE '%Jul';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Jul';

-- replace values that have 'Aug' with '8-'
UPDATE schools
SET gs_offered = '8-' || gs_offered
WHERE gs_offered LIKE '%Aug';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Aug';

-- replace values that have 'Sep' with '9-'
UPDATE schools
SET gs_offered = '9-' || gs_offered
WHERE gs_offered LIKE '%Sep';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Sep';

-- replace values that have 'Oct' with '10-'
UPDATE schools
SET gs_offered = '10-' || gs_offered
WHERE gs_offered LIKE '%Oct';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Oct';

-- replace values that have 'Nov' with '11-'
UPDATE schools
SET gs_offered = '11-' || gs_offered
WHERE gs_offered LIKE '%Nov';

UPDATE schools
SET gs_offered = SUBSTRING(gs_offered, 1, LENGTH(gs_offered)-4)
WHERE gs_offered LIKE '%Nov';

