CREATE DATABASE IF NOT EXISTS ideafoundry;
 
USE ideafoundry;
 
CREATE TABLE person(
   id varchar(255) not null primary key,
   email varchar(255),
   address varchar(255),
   zip varchar(255),
   city varchar(255),
   phone varchar(255),
   first_name varchar(255),
   last_name varchar(255),
   full_name varchar(255),
   record_id int(11),
   created_at varchar(255),
   updated_at varchar(255)
)ENGINE=InnoDB;

CREATE TABLE order(
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
   FOREIGN KEY fk_person_id(person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT
)ENGINE=InnoDB;

CREATE TABLE question(
   id varchar(255) not null primary key,
   answer longtext,
   question longtext,
   order_id varchar(255),
   person_id varchar(255),
   record_id int(11),
   created_at varchar(255),
   updated_at varchar(255),
   FOREIGN KEY fk_question_person_id(person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT,
   FOREIGN KEY fk_question_order_id(order_id) REFERENCES order(id) ON UPDATE CASCADE ON DELETE RESTRICT
)ENGINE=InnoDB;

CREATE TABLE occurence(
   id varchar(255) not null primary key,
   order_id varchar(255),
   closes_at varchar(255),
   created_at varchar(255),
   ends_at varchar(255),
   is_active tinyint(1),
   schedule_id varchar(255),
   starts_at varchar(255),
   time_slot_id varchar(255),
   updated_at varchar(255),
   FOREIGN KEY fk_occurrence_order_id(order_id) REFERENCES order(id) ON UPDATE CASCADE ON DELETE RESTRICT
)ENGINE=InnoDB;