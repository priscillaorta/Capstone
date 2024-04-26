/* Data Cleaning; districts

Priscilla Orta
03-23-2024
*/


-- Create a backup table 
CREATE TABLE districts_backup AS 
SELECT * FROM districts; 

--SELECT * FROM districts; 

-------------------------------------------------------------------------------------
             /* 	 Remove Unnecessary Columns      */
-------------------------------------------------------------------------------------
-- Delete unnecessary/redundant columns

ALTER TABLE districts 
DROP COLUMN st,
DROP COLUMN fax,
DROP COLUMN county;

-------------------------------------------------------------------------------------
             /* 	   Change Data Types     	*/
-------------------------------------------------------------------------------------

-- change lastup_date column to date data type
ALTER TABLE districts ALTER COLUMN lastup_date SET DATA TYPE date USING(lastup_date::date); 

-- change doc column to char(2)
ALTER TABLE districts ALTER COLUMN doc SET DATA TYPE char(2);


-------------------------------------------------------------------------------------
             /* 	  Replace 'No Data' with NULL      	*/
-------------------------------------------------------------------------------------


-- the following queries reveal that null values are represented with the text string:
-- 'No Data'

--SELECT * FROM districts 
--WHERE 'No Data' in (district_code, county, district, street, city, zip, phone, email, 
				   --adm_email, county_code);
				   

				   
-- Update table so that 'No Data' is properly coded as NULL
UPDATE districts 
SET phone = NULL
WHERE phone = 'No Data';

UPDATE districts
SET email = NULL
WHERE email = 'No Data';

UPDATE districts 
SET adm_email = NULL
WHERE adm_email = 'No Data';

-- NOTE: since district code is primary key, no need to check for null or duplicate values



