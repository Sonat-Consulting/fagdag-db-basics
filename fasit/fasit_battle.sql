-- Step 1
alter table person alter column last_name set not null;

-- Step 2
alter table city
	add constraint city_country_code_fk
		foreign key (countrycode) references country;

-- Step 3
create unique index person_world_sec_nr_uindex
	on person (world_sec_nr);

-- Step 4
alter table countrylanguage
    add constraint percentage check (percentage <= 100);