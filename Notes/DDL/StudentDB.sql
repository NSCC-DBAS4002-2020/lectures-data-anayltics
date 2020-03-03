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
VALUES (2, 'Jack', 'Sprat', 'jack.sprat@company.com', 1, 18, NULL);

INSERT INTO Course (Code, Name) VALUES ('PROG1400', 'Intro to OOP');

INSERT INTO Class (StudentID, CourseID) VALUES (1, 1);
SET IDENTITY_INSERT Class ON;
INSERT INTO Class (ClassID, StudentID, CourseID)
VALUES (110, 2, 1);
SET IDENTITY_INSERT Class OFF;

INSERT INTO Course (Code, Name)
VALUES ('DBAS4002', 'Transactional SQL Programming');
PRINT '@@IDENTITY = ' + STR(@@IDENTITY);
PRINT 'SCOPE_IDENTITY() = ' + STR(SCOPE_IDENTITY());
DECLARE @CourseID INT;
SET @CourseID = SCOPE_IDENTITY(); -- @@IDENTITY;
DECLARE @CourseID2 INT;
SELECT @CourseID2 = CourseID FROM Course WHERE Code = 'DBAS4002';
PRINT '@CourseID2 = ' + STR(@CourseID2);
INSERT INTO Class (StudentID, CourseID)
VALUES (2, @CourseID2);
GO

DELETE FROM Class
WHERE ClassID = SCOPE_IDENTITY();
GO
-- only works if ON DELETE CASCADE is enabled
DELETE FROM Student
WHERE StudentID = 2;
GO

UPDATE Course
SET Name = 'New Course Name'
WHERE Code = 'DBAS4002';
GO

-- UPDATE Student
-- SET StudentID = 2
-- WHERE StudentID = 1;
GO

USE AdventureWorks2017;
GO
SELECT OrderQty FROM Production.WorkOrder
WHERE StockedQty > 0;
GO
-- CREATE INDEX IX__Production__WorkOrder ON
-- Production.WorkOrder (StockedQty) INCLUDE (OrderQty);
GO

