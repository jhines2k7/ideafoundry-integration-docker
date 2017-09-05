CREATE DATABASE IF NOT EXISTS ideafoundrybi;
 
USE ideafoundrybi;
 
CREATE TABLE airtable_person(
   id varchar(32) not null,
   first_name varchar(255) not null,
   last_name varchar(255) not null,
   full_name varchar(255) not null,
   record_id int not null,
   created_at varchar(255) not null,
   updated_at varchar(255) not null,
) ENGINE=InnoDB;
 
CREATE TABLE products(
   prd_id int not null auto_increment primary key,
   prd_name varchar(355) not null,
   prd_price decimal,
   cat_id int not null,
   FOREIGN KEY fk_cat(cat_id)
   REFERENCES categories(cat_id)
   ON UPDATE CASCADE
   ON DELETE RESTRICT
)ENGINE=InnoDB;