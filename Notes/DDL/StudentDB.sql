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
    Code     NCHAR(8)     NOT NULL UNIQUE DEFAULT ('ABCD1234'),
    Name     NVARCHAR(32) NOT NULL,
    PRIMARY KEY (CourseID)
);
ALTER TABLE Course
ADD CONSTRAINT DF__Course__Name DEFAULT ('') FOR Name;

DROP TABLE IF EXISTS Student;
CREATE TABLE Student
(
    StudentID INT IDENTITY NOT NULL,
    FirstName NVARCHAR(32) NOT NULL,
    LastName  NVARCHAR(32) NOT NULL,
    Email     NVARCHAR(32) NOT NULL,
    Age       SMALLINT     NULL,
    Photo     IMAGE        NULL,
    PRIMARY KEY (StudentID)
);
ALTER TABLE Student
ADD CONSTRAINT AK__Student__Email UNIQUE (Email);

ALTER TABLE Class
    ADD CONSTRAINT FK__Student__StudentID
    FOREIGN KEY (StudentID) REFERENCES Student (StudentID);
ALTER TABLE Class
    ADD CONSTRAINT FK__Course__CourseID
    FOREIGN KEY (CourseID) REFERENCES Course (CourseID);
GO