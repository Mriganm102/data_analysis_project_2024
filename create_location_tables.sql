drop table if exists fact_location;

create table fact_location (
	location_id INT PRIMARY KEY AUTO_INCREMENT,
	state TEXT,
	city_or_county TEXT,
	congressional_district INT
);

drop table if exists dim_number_guns;

create table dim_number_guns (
	number_guns_id INT PRIMARY KEY AUTO_INCREMENT,
	number_guns INT
);

drop table if exists dim_shooter_info;

create table dim_shooter_info (
	shooterInfo_id INT PRIMARY KEY AUTO_INCREMENT,
	gender TEXT,
	age TEXT,
	status TEXT,
	type TEXT,
	age_group TEXT
);

drop table if exists dim_gun;

create table dim_gun (
	gun_id INT PRIMARY KEY AUTO_INCREMENT,
	gun_type TEXT
);

drop table if exists dim_incident;

create table dim_incident (
	incident_id INT PRIMARY KEY AUTO_INCREMENT,
	incident_type TEXT,
	incident_number INT
);

INSERT INTO fact_location (state, city_or_county, congressional_district)
SELECT state, city_or_county, congressional_district
FROM gun_violence_data_01_2013_03_2018;

INSERT INTO dim_number_guns (number_guns)
SELECT n_guns_involved
FROM gun_violence_data_01_2013_03_2018
WHERE n_guns_involved not like "0";

INSERT INTO dim_shooter_info (gender, age, status, type, age_group)
SELECT participant_gender, participant_age, participant_status, participant_type, participant_age_group
FROM gun_violence_data_01_2013_03_2018;

INSERT INTO dim_gun (gun_type)
SELECT gun_type
FROM gun_violence_data_01_2013_03_2018
WHERE gun_type not like "" AND gun_type NOT LIKE '0::Unknown' and gun_type not like '0:Unknown' and gun_type not like "%0::Unknown||1::Unknown%";

insert into dim_incident (incident_type, incident_number)
select incident_characteristics, incident
from gun_violence_data_01_2013_03_2018;

