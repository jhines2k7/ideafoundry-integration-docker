CREATE DATABASE IF NOT EXISTS ideafoundry;
 
USE ideafoundry;
 
-- CREATE TABLE person(
--    id varchar(255) not null primary key,
--    email varchar(255),
--    address varchar(255),
--    zip varchar(255),
--    city varchar(255),
--    phone varchar(255),
--    first_name varchar(255),
--    last_name varchar(255),
--    full_name varchar(255),
--    record_id int(11),
--    created_at varchar(255),
--    updated_at varchar(255)
-- )ENGINE=InnoDB;

-- CREATE TABLE occasion_order(
--    id varchar(255) not null primary key,
--    person_id varchar(255),
--    record_id int(11),
--    gift_card_amount double,
--    coupon_amount double,
--    outstanding_balance double,
--    subtotal double,
--    total double,
--    coupon_description varchar(255),
--    tax_percentage double,
--    payment_status varchar(255),
--    status varchar(255),
--    balance double,
--    price double,
--    description varchar(255),
--    verification_code varchar(255),
--    quantity int(11),
--    tax double,
--    created_at varchar(255),
--    updated_at varchar(255),
--    FOREIGN KEY fk_person_id(person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT
-- )ENGINE=InnoDB;

-- CREATE TABLE question(
--    id varchar(255) not null primary key,
--    answer longtext,
--    question longtext,
--    order_id varchar(255),
--    person_id varchar(255),
--    record_id int(11),
--    created_at varchar(255),
--    updated_at varchar(255),
--    FOREIGN KEY fk_question_person_id(person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT,
--    FOREIGN KEY fk_question_order_id(order_id) REFERENCES occasion_order(id) ON UPDATE CASCADE ON DELETE RESTRICT
-- )ENGINE=InnoDB;

-- CREATE TABLE occurrence(
--    id varchar(255) not null primary key,
--    order_id varchar(255),
--    closes_at varchar(255),
--    created_at varchar(255),
--    ends_at varchar(255),
--    is_active tinyint(1),
--    schedule_id varchar(255),
--    starts_at varchar(255),
--    time_slot_id varchar(255),
--    updated_at varchar(255),
--    FOREIGN KEY fk_occurrence_order_id(order_id) REFERENCES occasion_order(id) ON UPDATE CASCADE ON DELETE RESTRICT
-- )ENGINE=InnoDB;

-- create table order_question(
--   order_id varchar(255),
--   question_id varchar(255),
--   CONSTRAINT order_question_pk PRIMARY KEY (order_id, question_id),
--   CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES occasion_order (id),
--   CONSTRAINT fk_question FOREIGN KEY (question_id) REFERENCES question (id)
-- )ENGINE=InnoDB;

-- create table person_question(
--   person_id varchar(255),
--   question_id varchar(255),
--   CONSTRAINT person_question_pk PRIMARY KEY (person_id, question_id),
--   CONSTRAINT fk_person FOREIGN KEY (person_id) REFERENCES person (id),
--   CONSTRAINT fk_question FOREIGN KEY (question_id) REFERENCES question (id)
-- )ENGINE=InnoDB;