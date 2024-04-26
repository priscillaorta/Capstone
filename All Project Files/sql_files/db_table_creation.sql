/* Database Creation, Table Creation & Custom Data Types

Priscilla Orta
03-21-2024
*/



-------------------------------------------------------------------------------------
             /* 		      Create Database	       			*/
-------------------------------------------------------------------------------------

-- cal_schools
CREATE DATABASE cal_schools;


-------------------------------------------------------------------------------------
             /* 		  Create Custom Data Types	      		*/
-------------------------------------------------------------------------------------

-- District Type
CREATE TYPE dt AS ENUM ('County Office of Education (COE)', 'State Special Schools',
       'Unified School District', 'Elementary School District',
       'Regional Occupation Center/Program (ROC/P)',
       'State Board of Education', 'High School District',
       'Non-School Locations', 'Statewide Benefit Charter');
	   
	   
-- Status Type
CREATE TYPE st AS ENUM('Active', 'Closed');


-- School Status Type
CREATE TYPE sts AS ENUM('Active', 'Closed', 'Merged', 'Pending');


-- Gender
CREATE TYPE gen AS ENUM('F', 'M', 'X');


------------------------------------------------------------------------------------
                /* 			Create Tables				*/
------------------------------------------------------------------------------------

-- Create Table; counties
CREATE TABLE counties(
county_code char(2) CONSTRAINT cc_code_key PRIMARY KEY,
	county_name varchar(30), 
	school_count int
);



-- Create Table: districts; 
CREATE TABLE districts(
	county_code char(2) REFERENCES counties(county_code),
	district_code char(8) CONSTRAINT d_code_key PRIMARY KEY,
	county varchar(30), 
	district varchar(150), 
	street varchar(150), 
	city varchar(120), 
	zip varchar(12), 
	st char(2), 
	phone varchar(20), 
	fax varchar(20),
	email varchar(100),
	adm_email varchar(100), 
	latitude numeric, 
	longitude numeric, 
	doc int, 
	doc_type dt, 
	status_type st, 
	lastup_date varchar(20) 
);


-- Create Table: schools;
CREATE TABLE schools (
	county_code char(2) REFERENCES counties(county_code),
	cds_code char(15) CONSTRAINT cds_key PRIMARY KEY, 
	county_name varchar(30), 
	district_name varchar(150), 
	school_name varchar(120), 
	status_type sts, 			  
	street varchar(150), 
	city varchar(120), 
	zip varchar(12), 
	st char(2),  
	phone varchar(20), 
	fax varchar(20), 
	email varchar(100), 
	website varchar(120), 
	open_date varchar(20), 
	close_date varchar(20), 
	charter boolean, 
	soc varchar(75), 
	soc_type varchar(75), 
	ed_ops_name varchar(50), 
	eil_name varchar(50), 
	gs_offered varchar(50), 
	virtual varchar(12), 
	year_round boolean, 
	latitude varchar(20), 
	longitude varchar(20), 
	adm_email varchar(120), 
	last_update varchar(20)
	);
	


-- Create Table: enrollment;
CREATE TABLE enrollment(
	ac_year varchar(12), 
	cds_code char(15), 
	county_code char(2) REFERENCES counties(county_code),
	county_name varchar(30), 
	district_name varchar(120), 
	school_name varchar(120), 
	ethnic int, 
	gender gen, 
	kin_enr int, 
	gr1_enr int, 
	gr2_enr int, 
	gr3_enr int, 
	gr4_enr int, 
	gr5_enr int, 
	gr6_enr int, 
	gr7_enr int, 
	gr8_enr int,
	gr9_enr int, 
	gr10_enr int, 
	gr11_enr int, 
	gr12_enr int,
	adult_enr int,
	enr_total int,
	ungr_sec_enr int 
	);


-- Create Table: absents;
CREATE TABLE absents(
ac_year varchar(12), 
	county_code char(2),
	cds_code char(15) REFERENCES schools(cds_code),
	county varchar(120), 
	district_name varchar(120), 
	school_name varchar(120), 
	reporting_cat varchar(20), 
	eligible_enr varchar(20), 
	mult_abs_count varchar(20), 
	avg_days_absent varchar(20), 
	total_absences varchar(20), 
	exc_absences_pct varchar(20), 
	unexc_absences_pct varchar(20), 
	oos_susp_pct varchar(20) 
	);


-- Create Table: ell;
CREATE TABLE ell(
	ac_year varchar(20),
	county_code char(2) REFERENCES counties(county_code),
	cds_code char(15), 
	county_name varchar(120), 
	district_name varchar(120), 
	school_name varchar(120), 
	lc int, 
	languages varchar(75), 
	kdgn int, 
	gr1 int, 
	gr2 int, 
	gr3 int, 
	gr4 int, 
	gr5 int, 
	gr6 int, 
	gr7 int, 
	gr8 int, 
	gr9 int, 
	gr10 int, 
	gr11 int, 
	gr12 int, 
	total_ell int
	);


-- Create Table: fr_lunch;
CREATE TABLE fr_lunch(
	ac_year varchar(20), 
	county_code CHAR(2) REFERENCES counties(county_code), 
	cds_code char(15) REFERENCES schools(cds_code),
	district_code varchar(20), 
	school_code varchar(20), 
	county varchar(120), 
	district varchar(120), 
	school varchar(120), 
	low_grade varchar(50), 
	high_grade varchar(50), 
	enr varchar(20), 
	fm_count varchar(20), 
	fm_elig_pct varchar(20), 
	frpm_count varchar(20), 
	frpm_elig_pct varchar(20)	
	);
	

-- Create Table: graduates;
CREATE TABLE graduates(
	ac_year varchar(15),
	county_code varchar(12) REFERENCES counties(county_code), 
	cds_code char(15) REFERENCES schools(cds_code),
	district_code varchar(20), 
	county_name varchar(120), 
	district_name varchar(120), 
	school_name varchar(120), 
	reporting_cat varchar(20), 
	grad_count varchar(20) 

);
	

-- Create Table: college_gr;
CREATE TABLE college_gr(
ac_year varchar(12), 
	county_code int, 
	cds_code char(15) REFERENCES schools(cds_code),
	district_code numeric, 
	school_code numeric, 
	county_name varchar(120), 
	district_name varchar(120), 
	school_name varchar(120), 
	reporting_cat varchar(20), 
	completer_type varchar(20), 
	hs_completers varchar(20), 
	enr_college varchar(20), 
	enr_instate varchar(20), 
	enr_oos varchar(20), 
	not_enr_college varchar(20), 
	uc_enr varchar(20), 
	csu_enr varchar(20), 
	ccc_enr varchar(20), 
	enr_instate_private varchar(20), 
	enr_oos_4yr varchar(20), 
	enr_oos_2yr varchar(20) 
);
	
	   