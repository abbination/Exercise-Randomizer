CREATE DATABASE `exercise` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE exercise;

/*Create lookup tables first*/
/*Holds the exercise types: calisthenics, weights, cardio, etc*/
CREATE TABLE `type` (
	type_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    date_created DATETIME NOT NULL DEFAULT NOW(),
    date_updated DATETIME NOT NULL DEFAULT NOW(),
    `name` VARCHAR(25) NOT NULL,
    CONSTRAINT UC_Type UNIQUE (`name`),
    CONSTRAINT PK_Type PRIMARY KEY (type_id)
);

CREATE TRIGGER Type_DateUpdated BEFORE UPDATE ON `type`
FOR EACH ROW SET new.date_updated = NOW();

/*Holds general body targets: upper body, lower body, core. Maybe in the future consider breaking that down further.*/
CREATE TABLE body_target (
	body_target_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    date_created DATETIME NOT NULL DEFAULT NOW(),
    date_updated DATETIME NOT NULL DEFAULT NOW(),
    `name` VARCHAR(25) NOT NULL, 
    CONSTRAINT UC_BodyTarget UNIQUE (`name`),
    CONSTRAINT PK_BodyTarget PRIMARY KEY (body_target_id)
);

CREATE TRIGGER BodyTarget_DateUpdated BEFORE UPDATE ON body_target
FOR EACH ROW SET new.date_updated = NOW();

/*The actual exercise movement*/
CREATE TABLE movement (
	movement_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    date_created DATETIME NOT NULL DEFAULT NOW(),
    date_updated DATETIME NOT NULL DEFAULT NOW(),
    `name` VARCHAR(50) NOT NULL,
    needs_mat BIT,
    type_id TINYINT UNSIGNED NOT NULL,
    body_target_id TINYINT UNSIGNED NOT NULL,
    CONSTRAINT UC_Movement UNIQUE (`name`),
    CONSTRAINT PK_Movement PRIMARY KEY (movement_id),
    CONSTRAINT FK_Type FOREIGN KEY (type_id) REFERENCES `type`(type_id),
    CONSTRAINT FK_BodyTarget FOREIGN KEY (body_target_id) REFERENCES body_target(body_target_id)
);

CREATE TRIGGER Movement_DateUpdated BEFORE UPDATE ON movement
FOR EACH ROW SET new.date_updated = NOW();

/*Logs the assignment and the actual*/
/*Start with json for working with python and the variety of configurations*/
CREATE TABLE log (
	log_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    date_created DATETIME NOT NULL DEFAULT NOW(),
    date_updated DATETIME NOT NULL DEFAULT NOW(),
    assignment_details JSON NOT NULL,
    actual_details JSON NULL,
    CONSTRAINT PK_Log PRIMARY KEY (log_id)
);

CREATE TRIGGER Log_DateUpdated BEFORE UPDATE ON log
FOR EACH ROW SET new.date_updated = NOW();

/*Create staging table for initial loads of exercise data*/
CREATE TABLE staging (
	movement VARCHAR(50),
    body_target VARCHAR(25),
    needs_mat TINYINT,
    `type` VARCHAR(25)
);
