USE master;
GO
DROP DATABASE IF EXISTS StudentDemo;
CREATE DATABASE StudentDemo;
GO
USE StudentDemo;
GO
DROP TABLE IF EXISTS Class;
CREATE TABLE Class
(
    ClassID   INT IDENTITY(100, 10) NOT NULL,
    StudentID INT          NOT NULL,
    CourseID  INT          NOT NULL,
    PRIMARY KEY (ClassID)
);
DROP TABLE IF EXISTS Course;
CREATE TABLE Course
(
    CourseID INT IDENTITY NOT NULL,
    Code     NCHAR(8)     NOT NULL UNIQUE DEFAULT ('ABCD1234')
        CHECK  (Code LIKE '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]'),
    Name     NVARCHAR(32) NOT NULL,
    PRIMARY KEY (CourseID)
);
ALTER TABLE Course
ADD CONSTRAINT DF__Course__Name DEFAULT ('') FOR Name;

DROP TABLE IF EXISTS Student;
CREATE TABLE Student
(
    StudentID INT NOT NULL,
    FirstName NVARCHAR(32) NOT NULL,
    LastName  NVARCHAR(32) NOT NULL,
    Email     NVARCHAR(32) NOT NULL,
    Child     BIT NOT NULL DEFAULT (0),
    Age       SMALLINT     NULL,
    Photo     IMAGE        NULL,
    PRIMARY KEY (StudentID),
    CONSTRAINT CK__Student__Age CHECK (Age > 0 AND Age < 200 AND Child = 1)
);
ALTER TABLE Student
ADD CONSTRAINT AK__Student__Email UNIQUE (Email);

ALTER TABLE Class
    ADD CONSTRAINT FK__Student__StudentID
    FOREIGN KEY (StudentID)
    REFERENCES Student (StudentID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Class
    ADD CONSTRAINT FK__Course__CourseID
    FOREIGN KEY (CourseID) REFERENCES Course (CourseID);
GO

INSERT INTO Student (StudentID, FirstName, LastName, Email, Child, Age, Photo)
VALUES (1, 'Jack', 'Sprat', 'jack.sprat@company.com', 1, 18, NULL);

INSERT INTO Course (Code, Name) VALUES ('PROG1400', 'Intro to OOP');

INSERT INTO Class (StudentID, CourseID) VALUES (1, 1);

GO

UPDATE Student
SET StudentID = 2
WHERE StudentID = 1;
GO

USE AdventureWorks2017;
GO

