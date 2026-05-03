Create Database Government_Services
drop database Government_Services
use Government_Services
drop table GovernmentServicesFact
select  count(*) from GovernmentServicesFact
select  * from GovernmentServicesFact
truncate table GovernmentServicesFact

create table DepartmentsDim
(
DeptID int primary key identity ,
Department NVARCHAR(300)
)

create table submissionchannelDim
(
submissionchannel_ID int primary key identity,
submission_channel  NVARCHAR(300)
)

create table LocationDim
(
LocID  int primary key identity,
city NVARCHAR(300),
district NVARCHAR(300)
)

create table PriporityDim
(
PriporityID int primary key identity,
pripority NVARCHAR(300),
max_resolution_days int 
)

create table IssuesDim
(
IssueId int primary key identity,
issue_type NVARCHAR(300),
subcategory NVARCHAR(300)
)



create table GovernmentServicesFact
(
Complaint_id int primary key identity,
TextDescription NVARCHAR(300),
IssueID int ,
DeptID int ,
LocID int,
PriorityID int ,
submissionChannelID int ,
created_time NVARCHAR(300),
CreatedDateKey INT,
closedDateKey INT ,
satisfaction_score int,
status NVARCHAR(300),
constraint fk_issue 
    foreign key (IssueID) references IssuesDim(IssueId),

constraint fk_department 
    foreign key (DeptID) references DepartmentsDim(DeptID),

constraint fk_location 
    foreign key (LocID) references LocationDim(LocID),

constraint fk_priority 
    foreign key (PriorityID) references PriporityDim(PriporityID),

constraint fk_submissionchannel 
    foreign key (submissionChannelID) references submissionchannelDim(submissionchannel_ID),

constraint fk_CreatedDate
    foreign key (CreatedDateKey) references DimDate(DateKey),

constraint fk_closedDate
    foreign key (closedDateKey) references DimDate(DateKey)
)
select * from DimDate
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,   
    FullDate DATE,             
    Day INT,
    Month INT,
    Year INT,
    Quarter INT
);


DECLARE @StartDate DATE = '2023-01-01';
DECLARE @EndDate   DATE = '2025-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (
        DateKey,
        FullDate,
        Day,
        Month,
        Year,
        Quarter
    )
    VALUES (
        CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
        @StartDate,  
        DAY(@StartDate),
        MONTH(@StartDate),
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate)
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;

BULK INSERT DepartmentsDim
FROM 'D:\DSS\DataSets\Dims\Departments.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',  
    CODEPAGE = '65001',    
    TABLOCK
);

BULK INSERT submissionchannelDim
FROM 'D:\DSS\DataSets\Dims\submissionchannel.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',  
    CODEPAGE = '65001',    
    TABLOCK
);

BULK INSERT LocationDim
FROM 'D:\DSS\DataSets\Dims\Location.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',  
    CODEPAGE = '65001',    
    TABLOCK
);

BULK INSERT PriporityDim
FROM 'D:\DSS\DataSets\Dims\Pripority.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',  
    CODEPAGE = '65001',    
    TABLOCK
);

BULK INSERT IssuesDim
FROM 'D:\DSS\DataSets\Dims\Issues.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',  
    CODEPAGE = '65001',    
    TABLOCK
);

