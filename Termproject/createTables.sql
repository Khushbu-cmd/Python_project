GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO Postgres;

DROP TABLE Division CASCADE;
DROP TABLE Department CASCADE;
DROP TABLE Employee CASCADE;
DROP TABLE Project CASCADE;
DROP TABLE Project_Hist CASCADE;
DROP TABLE Rooms CASCADE;
DROP TABLE Building CASCADE;
DROP TABLE Office CASCADE;
DROP TABLE Phone CASCADE;
DROP TABLE Records CASCADE;
DROP TABLE Credentials CASCADE;

CREATE TABLE Division(
	divisionId int NOT NULL,
	dName varchar(255),
	PRIMARY KEY(divisionId)
);
CREATE TABLE Department(
	depName varchar(255) NOT NULL,
	depBudget int,
	divisionId int,
	PRIMARY KEY(depName),
	CONSTRAINT fk_divisionId FOREIGN KEY(divisionId) REFERENCES Division(divisionId)
);

CREATE TABLE Employee(
	employeeNum int NOT NULL,
	eName varchar(255),
	projectNum int,
	title varchar(255),
	officeNum int,
	phoneNum int, 
	worksForDiv int,
	headOfDiv int, 
	worksForDep varchar(255), 
	headOfDep varchar(255),
	workingOnProj int,
	PRIMARY KEY (employeeNum),
	CONSTRAINT fk_worksForDiv FOREIGN KEY(worksForDiv) REFERENCES Division(divisionId),
	CONSTRAINT fk_headOfDiv FOREIGN KEY(headOfDiv) REFERENCES Division(divisionId),
	CONSTRAINT fk_worksForDep FOREIGN KEY(worksForDep) REFERENCES Department(depName),
	CONSTRAINT fk_headOfDep FOREIGN KEY(headOfDep) REFERENCES Department(depName)
);

CREATE TABLE Project(
	projectNum int NOT NULL,
	projBudget int,
	startDate date,
	endDate date,
	depName varchar(255),
	manager int,
	PRIMARY KEY(projectNum),
	CONSTRAINT fk_depName FOREIGN KEY(depName) REFERENCES Department(depName),
	CONSTRAINT fk_manager FOREIGN KEY(manager) REFERENCES Employee(employeeNum)
);

ALTER TABLE Employee
    ADD CONSTRAINT fk_working_on_Proj FOREIGN KEY (workingOnProj) REFERENCES Project(projectNum);

CREATE TABLE Project_Hist(
	historyId int NOT NULL, 
	timespent int, 
	role varchar(255),
	employeeId int,
	projectId int,
	PRIMARY KEY(historyId),
	CONSTRAINT fk_employeeId FOREIGN KEY(employeeId) REFERENCES Employee(employeeNum),
	CONSTRAINT fk_project_id FOREIGN KEY(projectId) REFERENCES Project(ProjectNum)
);


CREATE TABLE Rooms(
	roomNumber int NOT NULL,
	roomType int,
	depName varchar(255),
	buildingCode int,
	officeNum int,
	PRIMARY KEY (roomNumber),
	CONSTRAINT fk_department_belongTo FOREIGN KEY (depName) REFERENCES Department(depName)
);

CREATE TABLE Building(
	code int NOT NULL,
	bName varchar(255),
	yearOfPurchase int,
	costOfPurchase int,
	PRIMARY KEY (code)
);

ALTER TABLE Rooms
    ADD CONSTRAINT fk_builing_belongsTo FOREIGN KEY (buildingCode) REFERENCES Building(code);

CREATE TABLE Office(
	officeNum int NOT NULL,
	areaSqaFt int,
	PRIMARY KEY (officeNum)
);

ALTER TABLE Rooms
    ADD CONSTRAINT fk_office_belongsTo FOREIGN KEY (officeNum) REFERENCES Office(officeNum);

ALTER TABLE Employee
    ADD CONSTRAINT fk_goesTo_office FOREIGN KEY (officeNum) REFERENCES Office(officeNum);

CREATE TABLE Phone(
	phoneNum int NOT NULL,
	officeNum int,
	PRIMARY KEY (phoneNum),
	CONSTRAINT fk_isin_office FOREIGN KEY (officeNum) REFERENCES Office(officeNum)
);

ALTER TABLE Employee
    ADD CONSTRAINT fk_has_phoneNum FOREIGN KEY (phoneNum) REFERENCES Phone(phoneNum);

CREATE TABLE Records(
	eID int NOT NULL, 
	title varchar(255),
	start_Date date,
	salaryReceived int,
	PRIMARY KEY (eID),
	CONSTRAINT fk_records_of_emloyee FOREIGN KEY (eID) REFERENCES Employee(employeeNum)
);

CREATE TABLE Salary(
	empId int NOT NULL,
	Hourly varchar(255),
	Salary varchar(255),
	PRIMARY KEY(empId),
	CONSTRAINT fk_records_of_emloyee FOREIGN KEY (empId) REFERENCES Employee(employeeNum)
);

CREATE TABLE Credentials(
	employee int NOT NULL,
	password varchar(255),
	CONSTRAINT fk_records_of_emloyee FOREIGN KEY (employee) REFERENCES Employee(employeeNum)

);

INSERT INTO  Building VALUES (01, 'A' , 2017, 1020000);
INSERT INTO  Building VALUES (02, 'B' , 2015, 500000);
INSERT INTO  Building VALUES (03, 'C' , 2000, 150000);
INSERT INTO  Building VALUES (04, 'D' , 2010, 300000);
INSERT INTO  Building VALUES (05, 'E' , 2005, 200000);

INSERT INTO  Division VALUES (001, 'A');
INSERT INTO  Division VALUES (002, 'B');
INSERT INTO  Division VALUES (003, 'C' );
INSERT INTO  Division VALUES (004, 'D');
INSERT INTO  Division VALUES (005, 'E' );

INSERT INTO  Department VALUES ('Administration', 5000000,  001);
INSERT INTO  Department VALUES ('Human Resources', 4000000, 002);
INSERT INTO  Department VALUES ('Training', 2000000, 003);
INSERT INTO  Department VALUES ('Onboarding', 1000000, 004);
INSERT INTO  Department VALUES ('Disciplinary', 7000000, 005);

INSERT INTO  Office VALUES (01, 1200);
INSERT INTO  Office VALUES (02, 1500);
INSERT INTO  Office VALUES (03, 1000);
INSERT INTO  Office VALUES (04, 1300);
INSERT INTO  Office VALUES (05, 1400);

INSERT INTO  Phone VALUES (7584693, 01);
INSERT INTO  Phone VALUES (5897451, 02);
INSERT INTO  Phone VALUES (9687553, 03);
INSERT INTO  Phone VALUES (8975641, 04);
INSERT INTO  Phone VALUES (4568792, 05);
INSERT INTO  Phone VALUES (6895476, 01);
INSERT INTO  Phone VALUES (2568974, 02);
INSERT INTO  Phone VALUES (3568975, 04);
INSERT INTO  Phone VALUES (1387423, 03);
INSERT INTO  Phone VALUES (0309278, 05);
INSERT INTO  Phone VALUES (2389421, 01);
INSERT INTO  Phone VALUES (4743231, 02);
INSERT INTO  Phone VALUES (5637431, 03);
INSERT INTO  Phone VALUES (6894121, 04);
INSERT INTO  Phone VALUES (7432156, 05);

INSERT INTO  Rooms VALUES (1, 12,  'Administration', 01, 01);
INSERT INTO  Rooms VALUES (2, 23, 'Human Resources', 02, 02);
INSERT INTO  Rooms VALUES (3, 32, 'Training', 03, 03);
INSERT INTO  Rooms VALUES (4, 24 , 'Onboarding', 04, 04);
INSERT INTO  Rooms VALUES (5, 56 , 'Disciplinary', 05, 05);

INSERT INTO  Project VALUES (123, 100000, '2022-04-27' , '2023-04-28', 'Administration', null);
INSERT INTO  Project VALUES (124, 200000, '2022-04-17' , '2023-04-18', 'Human Resources', null);
INSERT INTO  Project VALUES (125, 300000, '2022-04-07' , '2023-04-08', 'Training', null);
INSERT INTO  Project VALUES (126, 400000, '2022-03-27' , '2023-03-28', 'Onboarding', null);
INSERT INTO  Project VALUES (127, 90000, '2022-03-17' , '2023-03-18', 'Disciplinary', null);

INSERT INTO  Employee VALUES (11, 'John Smith', 123, 'IT Analyst 2', 01 , 8975641, 001, 001, null ,null ,123);
INSERT INTO  Employee VALUES (12, 'Stew Williams', 124, 'Devloper 2', 02, 5897451, 002, null, null,null ,124);
INSERT INTO  Employee VALUES (13, 'Ivan P', 125, 'Head Operations 2', 03, 9687553, 003, null, null,null ,125);
INSERT INTO  Employee VALUES (14, 'Noah Taylor', 126, 'Associate 2', 04, 3568975, 004, null, null, null,126);
INSERT INTO  Employee VALUES (15, 'Aiden Lee', 127, 'Senior Engineer 2', 05, 6895476,null ,null ,'Administration','Disciplinary',127);
INSERT INTO  Employee VALUES (16, 'Evan Scott', 126, 'Associate 2', 01, 7584693,null , null, 'Human Resources', null, 123);
INSERT INTO  Employee VALUES (17, 'Josh Phill', 125, 'IT Analyst 2', 02, 2568974,null ,null, 'Training', null, 124);
INSERT INTO  Employee VALUES (18, 'John Diaz', 127, 'Developer 2', 04, 3568975,null ,null, 'Onboarding', null, 125);
INSERT INTO  Employee VALUES (19, 'Josh Diaz', 126, 'IT Analyst 2', 03, 1387423,null ,null, 'Administration', null, 125);
INSERT INTO  Employee VALUES (20, 'Kim P', 124, 'IT Analyst 2', 05, 0309278,null ,null, 'Administration', null, 123);
INSERT INTO  Employee VALUES (21, 'Herry James', 123, 'Associate 2', 01, 2389421,001 ,null, null, null, 124);
INSERT INTO  Employee VALUES (22, 'Josh Ross', 125, 'Developer 2', 02, 4743231,null ,null, 'Onboarding', null, 126);
INSERT INTO  Employee VALUES (23, 'Rachel H', 126, 'Senior Engineer 2', 03, 5637431,null ,null, 'Administration', null, 125);
INSERT INTO  Employee VALUES (24, 'Bell Ford', 127, 'Head Operations 2', 04, 6894121,002 ,null, null, null, 127);
INSERT INTO  Employee VALUES (25, 'Berry Math', 124, 'Developer 2', 05, 7432156,null ,null, 'Training', null, 124);


UPDATE Project SET manager = 11 WHERE projectnum = 123;
UPDATE Project SET manager = 12 WHERE projectnum = 124;
UPDATE Project SET manager = 13 WHERE projectnum = 125;
UPDATE Project SET manager = 14 WHERE projectnum = 126;
UPDATE Project SET manager = 15 WHERE projectnum = 127;

INSERT INTO  Project_Hist VALUES (11, 15 , 'Evalution' , 11, 123);
INSERT INTO  Project_Hist VALUES (12, 20 , 'Trainer' , 12, 124);
INSERT INTO  Project_Hist VALUES (13, 45, 'Senior' , 16, 124);
INSERT INTO  Project_Hist VALUES (14, 25, 'Trainer' , 13, 125);
INSERT INTO  Project_Hist VALUES (15, 90, 'Human Resources' , 14, 126);


INSERT INTO  Records VALUES (11, 'IT Analyst', '2018-06-11', 60000);
INSERT INTO  Records VALUES (12, 'Devloper', '2019-04-15', 65000);
INSERT INTO  Records VALUES (13, 'Head Operations', '2015-04-19', 80000);
INSERT INTO  Records VALUES (14, 'Associate', '2021-04-15', 40000);
INSERT INTO  Records VALUES (15, 'Senior Engineer', '2019-06-11', 50000);
INSERT INTO  Records VALUES (16, 'Associate', '2020-04-15', 45000);
INSERT INTO  Records VALUES (17, 'IT Analyst', '2015-04-19', 70000);
INSERT INTO  Records VALUES (18, 'Developer', '2015-04-15', 75000);
INSERT INTO  Records VALUES (19, 'IT Analyst', '2015-04-15', 75000);
INSERT INTO  Records VALUES (20, 'IT Analyst', '2015-07-15', 85000);
INSERT INTO  Records VALUES (21, 'Associate', '2012-04-09', 95000);
INSERT INTO  Records VALUES (22, 'Developer', '2017-04-15', 55000);
INSERT INTO  Records VALUES (23, 'Senior Engineer', '2015-04-15', 75000);
INSERT INTO  Records VALUES (24, 'Head Operations', '2015-07-30', 60000);
INSERT INTO  Records VALUES (25, 'Developer', '2015-04-15', 75000);


INSERT INTO  Salary VALUES (11, 25, null);
INSERT INTO  Salary VALUES (12, null, 35000);
INSERT INTO  Salary VALUES (13, null, 45000);
INSERT INTO  Salary VALUES (14, null, 39000);
INSERT INTO  Salary VALUES (15, null, 35000);
INSERT INTO  Salary VALUES (16, null, 33000);
INSERT INTO  Salary VALUES (17, 30, null);
INSERT INTO  Salary VALUES (18, null, 60000);
INSERT INTO  Salary VALUES (19, 23, null);
INSERT INTO  Salary VALUES (20, 24, null);
INSERT INTO  Salary VALUES (21, null, 33000);
INSERT INTO  Salary VALUES (22, null, 48000);
INSERT INTO  Salary VALUES (23, null, 48000);
INSERT INTO  Salary VALUES (24, null, 42000);
INSERT INTO  Salary VALUES (25, null, 39000);

INSERT INTO Credentials VALUES(16, 'password');
CREATE TABLE transactions(
	employee int NOT NULL, 
	transDate date, 
	paycheck int,
	CONSTRAINT fk_records_of_emloyee FOREIGN KEY (employee) REFERENCES Employee(employeeNum)
);

INSERT INTO transactions VALUES (11, '2022-05-01', 2000);
INSERT INTO transactions VALUES (12, '2022-05-01', 1458);
INSERT INTO transactions VALUES (13, '2022-05-01', 1875);
INSERT INTO transactions VALUES (14, '2022-05-01', 1625);
INSERT INTO transactions VALUES (15, '2022-05-01', 1458);
INSERT INTO transactions VALUES (16, '2022-05-01', 1375);
INSERT INTO transactions VALUES (17, '2022-05-01', 2400);
INSERT INTO transactions VALUES (18, '2022-05-01', 2500);
INSERT INTO transactions VALUES (19, '2022-05-01', 1840);
INSERT INTO transactions VALUES (20, '2022-05-01', 1920);
INSERT INTO transactions VALUES (21, '2022-05-01', 1375);
INSERT INTO transactions VALUES (22, '2022-05-01', 2000);
INSERT INTO transactions VALUES (23, '2022-05-01', 2000);
INSERT INTO transactions VALUES (24, '2022-05-01', 1750);
INSERT INTO transactions VALUES (25, '2022-05-01', 1625);

CREATE TABLE milestones(
	mileID int NOT NULL, 
	projectnum int,
	milestonetext varchar(1000),
	mileStatus varchar(255),
	CONSTRAINT fk_records_of_emloyee FOREIGN KEY (projectnum) REFERENCES project(projectnum)
);

INSERT INTO milestones VALUES(1, 123, 'Working on setting up', 'In progress');
INSERT INTO milestones VALUES(2, 124, 'Working on setting up', 'Not started');
INSERT INTO milestones VALUES(3, 124, 'Code Analysis', 'Not started');
INSERT INTO milestones VALUES(4, 126, 'Critical thinking features', 'Completed');
INSERT INTO milestones VALUES(5, 125, 'Implementating features', 'In progress');
INSERT INTO milestones VALUES(6, 125, 'Bug fix', 'In progress');
INSERT INTO milestones VALUES(7, 125, 'Implementating features', 'In progress'); 