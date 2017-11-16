CREATE DATABASE IF NOT EXISTS ideafoundry;
 
USE ideafoundry;
 
CREATE TABLE person(
    id int(11) not null primary key,
    email varchar(255),
    address varchar(255),
    zip varchar(255),
    city varchar(255),
    phone varchar(255),
    first_name varchar(255),
    last_name varchar(255),
    full_name varchar(255),
    created_at varchar(255),
    updated_at varchar(255)
)ENGINE=InnoDB;

CREATE TABLE occasion_order(
    id int(11) not null primary key,
    person_id int(11),
    gift_card_amount double,
    coupon_amount double,
    outstanding_balance double,
    subtotal double,
    total double,
    coupon_description varchar(255),
    tax_percentage double,
    payment_status varchar(255),
    status varchar(255),
    balance double,
    price double,
    description varchar(255),
    verification_code varchar(255),
    quantity int(11),
    tax double,
    created_at varchar(255),
    updated_at varchar(255),
    FOREIGN KEY fk_person_id(person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT
)ENGINE=InnoDB;

CREATE TABLE question(
    id int(11) not null primary key,
    question longtext,
    created_at varchar(255),
    updated_at varchar(255)
)ENGINE=InnoDB;

CREATE TABLE answer(
    id int(11) not null primary key,
    answer longtext,
    created_at varchar(255),
    updated_at varchar(255)
)ENGINE=InnoDB;

CREATE TABLE occurrence(
    id int(11) not null primary key,
    order_id int(11),
    closes_at varchar(255),
    created_at varchar(255),
    ends_at varchar(255),
    is_active tinyint(1),
    schedule_id varchar(255),
    starts_at varchar(255),
    time_slot_id varchar(255),
    updated_at varchar(255),
    FOREIGN KEY fk_order_id(order_id) REFERENCES occasion_order(id) ON UPDATE CASCADE ON DELETE RESTRICT
)ENGINE=InnoDB;

create table question_answer(
    question_id int(11),
    answer_id int(11),
    CONSTRAINT question_answer_pk PRIMARY KEY (question_id, answer_id),
    CONSTRAINT fk_question_answer_answer FOREIGN KEY (answer_id) REFERENCES answer (id),
    CONSTRAINT fk_question_answer_question FOREIGN KEY (question_id) REFERENCES question (id)
)ENGINE=InnoDB;

create table order_question(
    order_id int(11),
    question_id int(11),
    CONSTRAINT order_question_pk PRIMARY KEY (order_id, question_id),
    CONSTRAINT fk_order_question_order FOREIGN KEY (order_id) REFERENCES occasion_order (id),
    CONSTRAINT fk_order_question_question FOREIGN KEY (question_id) REFERENCES question (id)
)ENGINE=InnoDB;

create table order_answer(
    order_id int(11),
    answer_id int(11),
    CONSTRAINT order_answer_pk PRIMARY KEY (order_id, answer_id),
    CONSTRAINT fk_order_answer_order FOREIGN KEY (order_id) REFERENCES occasion_order (id),
    CONSTRAINT fk_order_answer_answer FOREIGN KEY (answer_id) REFERENCES answer (id)
)ENGINE=InnoDB;

create table person_question(
    person_id int(11),
    question_id int(11),
    CONSTRAINT person_question_pk PRIMARY KEY (person_id, question_id),
    CONSTRAINT fk_person_question_person FOREIGN KEY (person_id) REFERENCES person (id),
    CONSTRAINT fk_person_question_question FOREIGN KEY (question_id) REFERENCES question (id)
)ENGINE=InnoDB;

create table person_answer(
    person_id int(11),
    answer_id int(11),
    CONSTRAINT person_answer_pk PRIMARY KEY (person_id, answer_id),
    CONSTRAINT fk_person_answer_person FOREIGN KEY (person_id) REFERENCES person (id),
    CONSTRAINT fk_person_answer_answer FOREIGN KEY (answer_id) REFERENCES answer (id)
)ENGINE=InnoDB;

create table person_occurrence(
    person_id int(11),
    occurrence_id int(11),
    CONSTRAINT person_occurrence_pk PRIMARY KEY (person_id, occurrence_id),
    CONSTRAINT fk_person_occurrence_person FOREIGN KEY (person_id) REFERENCES person (id),
    CONSTRAINT fk_person_occurrence_occurrence FOREIGN KEY (occurrence_id) REFERENCES occurrence (id)
)ENGINE=InnoDB;
