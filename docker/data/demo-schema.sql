CREATE DATABASE IF NOT EXISTS ideafoundrybi;
 
USE ideafoundrybi;
 
CREATE TABLE air_table_person(
   id varchar(255) not null primary key,
   email varchar(255),
   zip varchar(255),
   first_name varchar(255),
   last_name varchar(255),
   full_name varchar(255),
   record_id int(11),
   created_at varchar(255),
   updated_at varchar(255)
)ENGINE=InnoDB;

CREATE TABLE air_table_order(
   id varchar(255) not null primary key,
   person_id varchar(255),
   payment_status varchar(255),
   status varchar(255),
   balance double,
   price double,
   coupon_amount double,
   coupon_description varchar(255),
   description varchar(255),
   verification_code varchar(255),
   record_id int(11),
   quantity int(11),
   tax double,
   tax_percentage double,
   created_at varchar(255),
   updated_at varchar(255),
   FOREIGN KEY fk_person_id(person_id) REFERENCES air_table_person(id) ON UPDATE CASCADE ON DELETE RESTRICT
)ENGINE=InnoDB;

CREATE TABLE air_table_question(
   id varchar(255) not null primary key,
   answer varchar(255),
   question varchar(255),
   order_id varchar(255),
   person_id varchar(255),
   record_id int(11),
   created_at varchar(255),
   updated_at varchar(255),
   FOREIGN KEY fk_question_person_id(person_id) REFERENCES air_table_person(id) ON UPDATE CASCADE ON DELETE RESTRICT,
   FOREIGN KEY fk_question_order_id(order_id) REFERENCES air_table_order(id) ON UPDATE CASCADE ON DELETE RESTRICT
)ENGINE=InnoDB;