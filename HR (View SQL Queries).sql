-- Member 1 --  frawla youssef ahmed
--************--
--1-1-1-- TotalTrainingOpportunitiesTaken by gender

create view TotalTrainingOpportunitiesTaken_By_Gender
as 
SELECT Gender,sum(TrainingOpportunitiesTaken)as TotalTrainingOpportunitiesTaken, format(AVG([ManagerRating]),'n2') as AVGManagerRating
FROM Employee$ join PerformanceRating$
on Employee$.EmployeeID=PerformanceRating$.EmployeeID
group by Gender

--*********************************************************************--
--1-1-2 TotalTrainingOpportunitiesTaken by Age_Group  

alter view TotalTrainingOpportunitiesTaken_By_Age_Group
as
SELECT 
    CASE 
        WHEN Employee$.Age < 25 THEN '<25'
        WHEN Employee$.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN Employee$.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN Employee$.Age > 45 THEN '>45'
    END AS AgeGroup,
    SUM(TrainingOpportunitiesTaken) AS TotalTrainingOpportunitiesTaken,
	format(AVG([ManagerRating]),'n2') as AVGManagerRating
FROM Employee$ 
JOIN PerformanceRating$
ON Employee$.EmployeeID = PerformanceRating$.EmployeeID
WHERE Employee$.Age BETWEEN 18 AND 51
GROUP BY 
    CASE 
        WHEN Employee$.Age < 25 THEN '<25'
        WHEN Employee$.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN Employee$.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN Employee$.Age > 45 THEN '>45'
    END


--select * from TotalTrainingOpportunitiesTaken_By_Age_Group order by AgeGroup asc
--*********************************************************************--
--1-1-3 employees PerformanceRating by training opportunities taken
create view Employee_Rating_By_Traning_Opportunities_Taken
as
SELECT 
    E.Department, 
    E.JobRole, 
    sum(P.TrainingOpportunitiesTaken) AS TotalTrainingTaken,
    AVG(P.SelfRating) AS AvgSelfRating,
    AVG(P.ManagerRating) AS AvgManagerRating
FROM Employee$ E
JOIN PerformanceRating$ P
ON E.EmployeeID = P.EmployeeID
GROUP BY E.Department, E.JobRole


--*********************************************************************--

--1-1-4 Distance to Work: How does the distance between an employee’s home and workplace affect the impact of training on performance?

create view Employee_Rating_By_DistanceRange
as
SELECT 
    CASE 
        WHEN E.[DistanceFromHome (KM)] BETWEEN 0 AND 10 THEN '0-10 KM'
        WHEN E.[DistanceFromHome (KM)] BETWEEN 11 AND 20 THEN '11-20 KM'
        WHEN E.[DistanceFromHome (KM)] BETWEEN 21 AND 30 THEN '21-30 KM'
		WHEN E.[DistanceFromHome (KM)] BETWEEN 31 AND 40 THEN '31-40 KM'
        WHEN E.[DistanceFromHome (KM)] > 40 THEN '40+ KM'
    END AS DistanceRange,
    sum(P.TrainingOpportunitiesTaken) AS ATotalTrainingTaken,
    format(AVG(P.ManagerRating), 'N2') AS AvgManagerRating
FROM Employee$ E
JOIN PerformanceRating$ P
ON E.EmployeeID = P.EmployeeID
GROUP BY 
    CASE 
        WHEN E.[DistanceFromHome (KM)] BETWEEN 0 AND 10 THEN '0-10 KM'
        WHEN E.[DistanceFromHome (KM)] BETWEEN 11 AND 20 THEN '11-20 KM'
        WHEN E.[DistanceFromHome (KM)] BETWEEN 21 AND 30 THEN '21-30 KM'
		WHEN E.[DistanceFromHome (KM)] BETWEEN 31 AND 40 THEN '31-40 KM'
        WHEN E.[DistanceFromHome (KM)] > 40 THEN '40+ KM'
    END


--*********************************************************************--
--1-1-5 Are highly educated employees concentrated in certain roles or departments with better performance outcomes?
create view Employee_Rating_By_Education_Level
as
SELECT L.EducationLevel,E.Department,E.JobRole, 
sum(P.TrainingOpportunitiesTaken) as Total_TrainingOpportunitiesTaken,
format(AVG(P.ManagerRating), 'n2') AS AvgManagerRating
from Employee$ as E join PerformanceRating$ as P
on E.EmployeeID=P.EmployeeID
join EducationLevel$ as L
on L.EducationLevelID = e.Education
group by  L.EducationLevel,Department,JobRole


--*********************************************************************--
--1-2-1 Are more highly educated employees more satisfied with the training programs they take?
create view Job_Satsifaction_By_Education_Level
as
SELECT L.EducationLevel,
sum(P.TrainingOpportunitiesTaken) as Total_TrainingOpportunitiesTaken,
format(avg(P.JobSatisfaction),'n2') as AVG_Job_Satsifaction
from Employee$ as E join PerformanceRating$ as P
on E.EmployeeID=P.EmployeeID
join EducationLevel$ as L
on L.EducationLevelID = e.Education
group by  L.EducationLevel


--*********************************************************************--
--1-2-2 Which job roles or departments show the highest satisfaction and performance gains after completing more training programs?
create view Job_Satsifaction_By_Job_Roles
as
SELECT E.Department,E.JobRole, 
sum(P.TrainingOpportunitiesTaken) as Total_TrainingOpportunitiesTaken,
format(avg(P.JobSatisfaction),'n2') as AVG_Job_Satsifaction,
format(AVG(P.ManagerRating), 'n2') AS AvgManagerRating
from Employee$ as E join PerformanceRating$ as P
on E.EmployeeID=P.EmployeeID
join EducationLevel$ as L
on L.EducationLevelID = e.Education
group by  L.EducationLevel,Department,JobRole

--*********************************************************************--
--1-3-1 Does the physical or cultural environment (e.g., teamwork, resources, office setup) 
-- influence performance in the same way across departments or job roles?
create view _Employees_Rating_By_Environment_Satsifaction
as
SELECT E.Department,E.JobRole, 
format(avg(P.EnvironmentSatisfaction),'n2') as AVG_EnvironmentSatisfaction,
format(AVG(P.ManagerRating), 'n2') AS AvgManagerRating
from Employee$ as E join PerformanceRating$ as P
on E.EmployeeID=P.EmployeeID
join EducationLevel$ as L
on L.EducationLevelID = e.Education
group by  Department,JobRole

--*********************************************************************--
--1-3-2 	How does work environment satisfaction vary across gender, age, and other demographic factors?
create view Employee_Rate_By_Environment_Age_Gender
as
SELECT 
    CASE 
        WHEN Employee$.Age < 25 THEN '<25'
        WHEN Employee$.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN Employee$.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN Employee$.Age > 45 THEN '>45'
    END AS AgeGroup,
	gender,
    format(AVG(JobSatisfaction),'n2') as AVGJobSatsifaction,
	format(AVG([ManagerRating]),'n2') as AVGManagerRating
FROM Employee$ 
JOIN PerformanceRating$
ON Employee$.EmployeeID = PerformanceRating$.EmployeeID
WHERE Employee$.Age BETWEEN 18 AND 51
GROUP BY 
    CASE 
        WHEN Employee$.Age < 25 THEN '<25'
        WHEN Employee$.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN Employee$.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN Employee$.Age > 45 THEN '>45'
    END
	,Gender

--***************************************************************************************************************************************--
--***************************************************************************************************************************************--
-- Member 2 --  Ahmed Mohamed elsayed
--************--
--1)1_Education Level: Are more highly educated employees more satisfied with training opportunities
--and how does this reflect in their performance?
go
CREATE VIEW EmployeePerformanceEducationView AS
SELECT TOP 100 PERCENT 
    el.EducationLevel,
    AVG(pr.TrainingOpportunitiesTaken) AS AvgTrainingTaken,
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction,
    AVG(pr.SelfRating) AS AvgSelfRating,
    AVG(pr.ManagerRating) AS AvgManagerRating
FROM Employee$ e
JOIN PerformanceRating$ pr 
    ON e.EmployeeID = pr.EmployeeID
JOIN EducationLevel$ el 
    ON e.Education = el.EducationLevelID
GROUP BY el.EducationLevel
ORDER BY AvgTrainingTaken DESC;
go

CREATE VIEW EmployeePerformanceEducationViewwithSTDEV AS
SELECT TOP 100 PERCENT 
    el.EducationLevel, 
    COUNT(e.EmployeeID) AS EmployeeCount, 
    AVG(pr.TrainingOpportunitiesTaken) AS AvgTrainingTaken, 
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction, 
    STDEV(pr.JobSatisfaction) AS JobSatisfactionStdDev, 
    AVG(pr.SelfRating) AS AvgSelfRating, 
    STDEV(pr.SelfRating) AS SelfRatingStdDev, 
    AVG(pr.ManagerRating) AS AvgManagerRating, 
    STDEV(pr.ManagerRating) AS ManagerRatingStdDev
FROM Employee$ e
JOIN PerformanceRating$ pr ON e.EmployeeID = pr.EmployeeID
JOIN EducationLevel$ el ON e.Education = el.EducationLevelID
GROUP BY el.EducationLevel
ORDER BY AvgTrainingTaken DESC;
go


------------------------------------------------------------------------------
--1)2_2.Job Role: Which job roles or departments are linked to higher satisfaction post-training?

CREATE VIEW DepartmentJobRolePerformanceView AS
SELECT TOP 100 PERCENT
    e.Department, 
    e.JobRole, 
    AVG(pr.TrainingOpportunitiesTaken) AS AvgTrainingTaken, 
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction, 
    AVG(pr.SelfRating) AS AvgSelfRating, 
    AVG(pr.ManagerRating) AS AvgManagerRating
FROM Employee$ e
JOIN PerformanceRating$ pr ON e.EmployeeID = pr.EmployeeID
GROUP BY e.Department, e.JobRole
ORDER BY AvgTrainingTaken DESC;
go
-------------------------------------------------------------------------------
--1)3_Performance: How do employees who undergo more training programs compare in terms of both
--JobSatisfaction and Performance?

CREATE VIEW EducationTrainingPerformanceView AS
SELECT TOP 100 PERCENT
    el.EducationLevel,
    pr.TrainingOpportunitiesTaken,
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction,
    AVG(pr.SelfRating) AS AvgSelfRating,
    AVG(pr.ManagerRating) AS AvgManagerRating
FROM PerformanceRating$ pr
JOIN Employee$ e ON pr.EmployeeID = e.EmployeeID
JOIN EducationLevel$ el ON e.Education = el.EducationLevelID
GROUP BY pr.TrainingOpportunitiesTaken, el.EducationLevel
ORDER BY pr.TrainingOpportunitiesTaken;
go

----------------------------------------------------------------------------
--2)1_Gender: Do male or female employees show stronger correlations between satisfaction and performance? python
CREATE VIEW GenderPerformanceView AS
SELECT TOP 100 PERCENT
    e.Gender,
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction,
    STDEV(pr.JobSatisfaction) AS JobSatisfactionStDev,
    AVG(pr.SelfRating) AS AvgSelfRating,
    STDEV(pr.SelfRating) AS SelfRatingStDev,
    AVG(pr.ManagerRating) AS AvgManagerRating,
    STDEV(pr.ManagerRating) AS ManagerRatingStDev
FROM PerformanceRating$ pr
JOIN Employee$ e ON pr.EmployeeID = e.EmployeeID
GROUP BY e.Gender
ORDER BY e.Gender;
go
-----------------------------------------------------------------------------
--2)2_Job Role & Department: Are some departments better at maintaining both
--high satisfaction and high performance?
CREATE VIEW JobRoleDepartmentPerformanceView AS
SELECT TOP 100 PERCENT
    e.JobRole,
    e.Department,
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction,
    AVG(pr.SelfRating) AS AvgSelfRating,
    AVG(pr.ManagerRating) AS AvgManagerRating
FROM PerformanceRating$ pr
JOIN Employee$ e ON pr.EmployeeID = e.EmployeeID
GROUP BY e.JobRole, e.Department
ORDER BY e.Department, e.JobRole;
go
------------------------------------------------------------------------------
--2)3_Age Group: Does the relationship between satisfaction and performance vary by age group?
CREATE VIEW AgeGroupPerformanceView AS
SELECT TOP 100 PERCENT
    CASE 
        WHEN e.Age < 30 THEN 'Under 30'
        WHEN e.Age BETWEEN 30 AND 40 THEN '30-40'
        WHEN e.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE 'Above 50'
    END AS AgeGroup,
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction,
    AVG(pr.SelfRating) AS AvgSelfRating,
    AVG(pr.ManagerRating) AS AvgManagerRating
FROM PerformanceRating$ pr
JOIN Employee$ e ON pr.EmployeeID = e.EmployeeID
GROUP BY 
    CASE 
        WHEN e.Age < 30 THEN 'Under 30'
        WHEN e.Age BETWEEN 30 AND 40 THEN '30-40'
        WHEN e.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE 'Above 50'
    END
ORDER BY AgeGroup;
go
-------------------------------------------------------------------------------
--3)1_Education Level: Are more highly educated employees more satisfied with training opportunities?
CREATE VIEW EducationTrainingPerformanceandtrainingView AS
SELECT TOP 100 PERCENT
    el.EducationLevel, 
    pr.TrainingOpportunitiesTaken, 
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction, 
    AVG(pr.SelfRating) AS AvgSelfRating, 
    AVG(pr.ManagerRating) AS AvgManagerRating
FROM Employee$ e
JOIN PerformanceRating$ pr ON e.EmployeeID = pr.EmployeeID
JOIN EducationLevel$ el ON e.Education = el.EducationLevelID
GROUP BY el.EducationLevel, pr.TrainingOpportunitiesTaken
ORDER BY el.EducationLevel, pr.TrainingOpportunitiesTaken DESC;
go
-------------------------------------------------------------------------------
--3)2_Job Role: Which job roles or departments are linked to higher satisfaction post-training?
CREATE VIEW DepartmentJobRoleTrainingView AS
SELECT TOP 100 PERCENT
    e.Department, 
    e.JobRole, 
    AVG(pr.TrainingOpportunitiesTaken) AS AvgTrainingTaken, 
    AVG(pr.JobSatisfaction) AS AvgJobSatisfaction, 
    AVG(pr.SelfRating) AS AvgSelfRating, 
    AVG(pr.ManagerRating) AS AvgManagerRating
FROM Employee$ e
JOIN PerformanceRating$ pr ON e.EmployeeID = pr.EmployeeID
GROUP BY e.Department, e.JobRole
ORDER BY AvgTrainingTaken DESC;

go
--***************************************************************************************************************************************--
--***************************************************************************************************************************************--
-- Member 4 --  Toka Ezz Eldeen
--************--

 Work-Life Balance and Performance
--How does work-life balance influence employee performance?

--1-Gender and Age Group for WorkLifeBalance and all PerformanceRating

SELECT  
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS AgeGroup,
    CAST(ROUND(sum((EnvironmentSatisfaction + JobSatisfaction + WorkLifeBalance + SelfRating + ManagerRating) / 5.0), 2) AS DECIMAL(10,2)) AS PerformanceScore,
    sum(WorkLifeBalance) AS TotalWorkLifeBalance
FROM 
    PerformanceRating$ 
JOIN 
    Employee$
ON  
    PerformanceRating$.EmployeeID = Employee$.EmployeeID
GROUP BY  
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END
ORDER BY 
    Gender;

	                                     --Note--
--Total Work-Life Balance Ratings and Overall Performance Ratings The older the employee,
--the lower the employee's performance and work-life balance.

                                      -------------------------------------
--2- OverTime for WorkLifeBalance and all PerformanceRating

select OverTime,count(PerformanceRating$.EmployeeID)as count_Employees,
    CAST(ROUND(sum((EnvironmentSatisfaction + JobSatisfaction + WorkLifeBalance + SelfRating + ManagerRating) / 5.0), 2) AS DECIMAL(10,2)) AS PerformanceScore,
    sum(WorkLifeBalance) AS WorkLifeBalance
from     PerformanceRating$ 
JOIN 
    Employee$
ON  
    PerformanceRating$.EmployeeID = Employee$.EmployeeID
GROUP BY OverTime

                                          --Note--
--Employees who do not work overtime have better performance and greater balance in their lives, at a low rate.

	                             --------------------------------------

--Is there a correlation between WorkLifeBalance and higher/lower
--performance ratings (SelfRating, ManagerRating) based on gender, age group, and overtime?

--1-Gender and Age Group for WorkLifeBalance and PerformanceRating (SelfRating, ManagerRating)

SELECT  
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS AgeGroup,
    CAST(ROUND(sum((SelfRating + ManagerRating) / 5.0), 2) AS DECIMAL(10,2)) AS PerformanceScore,
    sum(WorkLifeBalance) AS TotalWorkLifeBalance
FROM 
    PerformanceRating$ 
JOIN 
    Employee$
ON  
    PerformanceRating$.EmployeeID = Employee$.EmployeeID
GROUP BY  
    Gender,
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END
ORDER BY 
    Gender;
	                                     --Note--
--Total Work-Life Balance Ratings and Performance Ratings (SelfRating, ManagerRating) The older the employee,
--the lower the employee's performance and work-life balance.

	                    -------------------------------------

--2- OverTime for WorkLifeBalance and PerformanceRating (SelfRating, ManagerRating)
select OverTime,count(PerformanceRating$.EmployeeID)as count_Employees,
    CAST(ROUND(sum((SelfRating + ManagerRating) / 5.0), 2) AS DECIMAL(10,2)) AS PerformanceScore,
    sum(WorkLifeBalance) AS WorkLifeBalance
from     PerformanceRating$ 
JOIN 
    Employee$
ON  
    PerformanceRating$.EmployeeID = Employee$.EmployeeID
GROUP BY OverTime

                                          --Note--
--Employees who do not work overtime have better performance and greater balance in their lives, at a low rate.






--***************************************************************************************************************************************--
--***************************************************************************************************************************************--
-- Member 5 --  Suhayla Sherif
--************--
--5-1-1
create view WorkLifeBalance_and_Performance 
as
SELECT
    gender,
  CASE 
        WHEN E.Age < 25 THEN '<25'
        WHEN E.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN E.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN E.Age > 45 THEN '>45'
    END AS AgeGroup,
    AVG(p.WorkLifeBalance) AS avg_work_life_balance,
    AVG(p.SelfRating) AS avg_self_rating,
    AVG(p.ManagerRating) AS avg_manager_rating
FROM
    Employee$ as e join PerformanceRating$ as p
	on e.EmployeeID = p.EmployeeID
GROUP BY
    gender, 
	case        
	    WHEN E.Age < 25 THEN '<25'
        WHEN E.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN E.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN E.Age > 45 THEN '>45'
		end


--******************************************************************************************
-- 5-1-2
create view Gender_JobRole_Performance
as
SELECT
    e.Gender,
    e.JobRole,
    AVG(p.WorkLifeBalance) AS avg_work_life_balance,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attrition,
    COUNT(e.EmployeeID) AS total_employees,
    format((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.EmployeeID)),'n2') AS attrition_rate
FROM 
   Employee$ as e join PerformanceRating$ as p
   on e.EmployeeID = p.EmployeeID
GROUP BY
    e.Gender, e.JobRole
select * from Gender_JobRole_Performance ORDER BY avg_work_life_balance DESC;
--*********************************************************************************************************
--5-1-3
create view work_life_balance_vs_Attrition
as
SELECT
    OverTime,
    AVG(p.WorkLifeBalance) AS avg_work_life_balance,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attrition,
    COUNT(e.EmployeeID) AS total_employees,
    format((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.EmployeeID)),'n2') AS attrition_rate
FROM
    Employee$ as e join PerformanceRating$ as p
	on e.EmployeeID = p.EmployeeID
GROUP BY
    e.OverTime


--**********************************************************************************************************
--5-2-1 Get average job satisfaction and work-life balance scores by age group, gender, and overtime status

create view Age_Gender_overTime_Performance
as
SELECT 
  CASE 
        WHEN E.Age < 25 THEN '<25'
        WHEN E.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN E.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN E.Age > 45 THEN '>45'
    END AS AgeGroup,
    E.gender,
    E.overtime,
    AVG(p.JobSatisfaction) AS avg_job_satisfaction,
    AVG(p.WorkLifeBalance) AS avg_work_life_balance
FROM 
   Employee$ as e join PerformanceRating$ as p
   on e.EmployeeID = p.EmployeeID
WHERE 
    e.OverTime = 'Yes' 
 GROUP BY 
    case        
	    WHEN E.Age < 25 THEN '<25'
        WHEN E.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN E.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN E.Age > 45 THEN '>45'
		end, e.Gender, e.OverTime

--select * from Age_Gender_overTime_Performance ORDER BY AgeGroup asc, Gender

--************************************************************************************************************************
-- 5-2-2 -- -- Get average job satisfaction and work-life balance scores by department, job title, and overtime status

create view Job_Satisfaction_By_Department_Job_Title_OverTime
as
SELECT 
    e.Department,
    e.JobRole,
	e.overtime,
    AVG(p.JobSatisfaction) AS avg_job_satisfaction,
    AVG(p.WorkLifeBalance) AS avg_work_life_balance
FROM 
   Employee$ as e join PerformanceRating$ as p
   on e.EmployeeID = p.EmployeeID
WHERE 
    overtime = 'Yes'
GROUP BY 
    e.Department, e.JobRole, e.OverTime

--select * from Job_Satisfaction_By_Department_Job_Title_OverTime ORDER BY Department , JobRole

--************************************************************************************************--

-- 5-2-3 -- Compare job satisfaction and work-life balance by age group for those who work overtime

create view Job_Satisfaction_Age_OverTime
as
SELECT 
  CASE 
        WHEN E.Age < 25 THEN '<25'
        WHEN E.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN E.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN E.Age > 45 THEN '>45'
    END AS AgeGroup,
    AVG(p.JobSatisfaction) AS avg_job_satisfaction,
    AVG(p.WorkLifeBalance) AS avg_work_life_balance
FROM 
   Employee$ as e join PerformanceRating$ as p
   on e.EmployeeID = p.EmployeeID
WHERE
    overtime = 'Yes'
GROUP BY 
    case        
	    WHEN E.Age < 25 THEN '<25'
        WHEN E.Age BETWEEN 25 AND 35 THEN '25-35'
		WHEN E.Age BETWEEN 36 AND 45 THEN '36-45'
		WHEN E.Age > 45 THEN '>45'
		end

--select * from Job_Satisfaction_Age_OverTime ORDER BY AgeGroup asc

--*************************************************************************************************
-- 5-2-4 Compare job satisfaction and work-life balance by gender for employees working overtime

create view Job_Satisfaction_Gender_OverTime
as
SELECT 
    e.Gender,
    AVG(p.JobSatisfaction) AS avg_job_satisfaction,
    AVG(p.WorkLifeBalance) AS avg_work_life_balance
FROM 
   Employee$ as e join PerformanceRating$ as p
   on e.EmployeeID = p.EmployeeID
WHERE 
    overtime = 'Yes'
GROUP BY 
    gender

-- select * from Job_Satisfaction_Gender_OverTime ORDER BY  gender;

--*********************************************************************************************************************
-- 5-2-5 Identify departments or job titles with the lowest satisfaction and work-life balance for employees working overtime

alter view Departments_with_Lowest_Satisfaction
as
WITH RankedData AS
(
    SELECT
    e.Department,
    e.JobRole,
    AVG(p.JobSatisfaction) AS avg_job_satisfaction,
    AVG(p.WorkLifeBalance) AS avg_work_life_balance,
	ROW_NUMBER() OVER (ORDER BY AVG(p.WorkLifeBalance) ASC, AVG(p.JobSatisfaction) ASC) AS row_num
    FROM 
   Employee$ as e join PerformanceRating$ as p
   on e.EmployeeID = p.EmployeeID
WHERE 
    overtime = 'Yes'
GROUP BY 
    e.Department, e.JobRole 
)
SELECT 
    Department,
    JobRole,
    avg_job_satisfaction,
    avg_work_life_balance
FROM 
    RankedData
WHERE 
    row_num <= 5;




--***************************************************************************************************************************************--
--***************************************************************************************************************************************--
-- Member 6 --  Manal Abu Shama
--************--
USE [HR]
GO
/****** Object:  View [dbo].[View_AttritionRateByJobSatisfaction]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_AttritionRateByJobSatisfaction]
AS
SELECT       dbo.Employee$.Department, dbo.Employee$.JobRole, JS.JobSatisfaction, COUNT(dbo.Employee$.EmployeeID) AS total_employees, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count, 
                         CAST(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS attrition_rate
FROM            dbo.Employee$ INNER JOIN
                             (SELECT       dbo.PerformanceRating$.EmployeeID, dbo.SatisfiedLevel$.SatisfactionLevel AS JobSatisfaction
                               FROM             dbo.SatisfiedLevel$ INNER JOIN
                                                         dbo.PerformanceRating$ ON dbo.SatisfiedLevel$.SatisfactionID = dbo.PerformanceRating$.EnvironmentSatisfaction) AS JS ON dbo.Employee$.EmployeeID = JS.EmployeeID
GROUP BY dbo.Employee$.Department, dbo.Employee$.JobRole, JS.JobSatisfaction
GO
/****** Object:  View [dbo].[View_AttritionRateByWorkLifeBalance]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_AttritionRateByWorkLifeBalance]
AS
SELECT       dbo.Employee$.Department, dbo.Employee$.JobRole, WLB.WorkLifeBalance, COUNT(dbo.Employee$.EmployeeID) AS total_employees, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count, 
                         CAST(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS attrition_rate
FROM            dbo.Employee$ INNER JOIN
                             (SELECT       dbo.PerformanceRating$.EmployeeID, dbo.SatisfiedLevel$.SatisfactionLevel AS WorkLifeBalance
                               FROM             dbo.SatisfiedLevel$ INNER JOIN
                                                         dbo.PerformanceRating$ ON dbo.SatisfiedLevel$.SatisfactionID = dbo.PerformanceRating$.WorkLifeBalance) AS WLB ON dbo.Employee$.EmployeeID = WLB.EmployeeID
GROUP BY dbo.Employee$.Department, dbo.Employee$.JobRole, WLB.WorkLifeBalance
GO
/****** Object:  View [dbo].[View_AVG_Tenure]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_AVG_Tenure]
AS
SELECT       TOP (10000) dbo.Employee$.Department, dbo.Employee$.JobRole, dbo.EducationLevel$.EducationLevel, CONVERT(decimal, AVG(CASE WHEN Attrition = 'No' THEN (DATEDIFF(year, HireDate, GETDATE()) - YearsAtCompany) 
                         ELSE DATEDIFF(year, HireDate, GETDATE()) END)) AS average_tenure_years, COUNT(dbo.Employee$.EmployeeID) AS total_employees
FROM            dbo.Employee$ INNER JOIN
                         dbo.EducationLevel$ ON dbo.EducationLevel$.EducationLevelID = dbo.Employee$.Education
GROUP BY dbo.Employee$.Department, dbo.Employee$.JobRole, dbo.EducationLevel$.EducationLevel
ORDER BY average_tenure_years DESC
GO
/****** Object:  View [dbo].[View_HiringOverTime]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_HiringOverTime]
AS
SELECT       TOP (100) PERCENT hires.hire_year, hires.hires AS total_hires, workforce.cumulative_workforce, managers.cumulative_managers, managers.cumulative_managers * 100.0 / workforce.cumulative_workforce AS manager_percentage
FROM            (SELECT       YEAR(HireDate) AS hire_year, COUNT(*) AS hires
                          FROM            dbo.Employee$
                          GROUP BY YEAR(HireDate)) AS hires INNER JOIN
                             (SELECT       a.hire_year, SUM(b.hires) AS cumulative_workforce
                               FROM             (SELECT       YEAR(HireDate) AS hire_year, COUNT(*) AS hires
                                                          FROM            dbo.Employee$ AS Employee$_4
                                                          WHERE        (Attrition = 'No')
                                                          GROUP BY YEAR(HireDate)) AS a INNER JOIN
                                                             (SELECT       YEAR(HireDate) AS hire_year, COUNT(*) AS hires
                                                               FROM             dbo.Employee$ AS Employee$_3
                                                               WHERE         (Attrition = 'No')
                                                               GROUP BY  YEAR(HireDate)) AS b ON b.hire_year <= a.hire_year
                               GROUP BY  a.hire_year) AS workforce ON hires.hire_year = workforce.hire_year INNER JOIN
                             (SELECT       a.hire_year, SUM(b.managers) AS cumulative_managers
                               FROM             (SELECT       YEAR(HireDate) AS hire_year, COUNT(*) AS managers
                                                          FROM            dbo.Employee$ AS Employee$_2
                                                          WHERE        (JobRole = 'Manager') AND (Attrition = 'No')
                                                          GROUP BY YEAR(HireDate)) AS a INNER JOIN
                                                             (SELECT       YEAR(HireDate) AS hire_year, COUNT(*) AS managers
                                                               FROM             dbo.Employee$ AS Employee$_1
                                                               WHERE         (JobRole = 'Manager') AND (Attrition = 'No')
                                                               GROUP BY  YEAR(HireDate)) AS b ON b.hire_year <= a.hire_year
                               GROUP BY  a.hire_year) AS managers ON hires.hire_year = managers.hire_year
ORDER BY hires.hire_year
GO
/****** Object:  View [dbo].[View_ManageRole_ManagersByGenderPerc]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ManageRole_ManagersByGenderPerc]
AS
SELECT       Gender, COUNT(EmployeeID) * 100.0 /
                             (SELECT       COUNT(EmployeeID) AS Expr1
                               FROM             dbo.Employee$
                               WHERE         (JobRole = 'Manager')) AS manager_percentage
FROM            dbo.Employee$ AS Employee$_1
WHERE        (JobRole = 'Manager')
GROUP BY Gender
GO
/****** Object:  View [dbo].[View_ManagersByAgeGroup]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ManagersByAgeGroup]
AS
SELECT       TOP (10000) age_group, COUNT(CASE WHEN JobRole = 'Manager' THEN 1 END) * 100.0 /
                             (SELECT       COUNT(*) AS Expr1
                               FROM             dbo.Employee$
                               WHERE         (JobRole = 'Manager')) AS manager_age_percentage, COUNT(CASE WHEN JobRole != 'Manager' THEN 1 END) * 100.0 /
                             (SELECT       COUNT(*) AS Expr1
                               FROM             dbo.Employee$ AS Employee$_2
                               WHERE         (JobRole <> 'Manager')) AS non_manager_age_percentage
FROM            (SELECT       CASE WHEN age < 30 THEN '<30' WHEN age BETWEEN 30 AND 39 THEN '30-39' WHEN age BETWEEN 40 AND 49 THEN '40-49' WHEN age BETWEEN 50 AND 59 THEN '50-59' ELSE '60+' END AS age_group, 
                                                   JobRole
                          FROM            dbo.Employee$ AS Employee$_1) AS age_groups
GROUP BY age_group
ORDER BY age_group
GO
/****** Object:  View [dbo].[View_ManagersByEduLevel]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_ManagersByEduLevel]
AS
SELECT       TOP (10000) dbo.EducationLevel$.EducationLevel, COUNT(CASE WHEN JobRole = 'Manager' THEN 1 END) * 100.0 /
                             (SELECT       COUNT(*) AS Expr1
                               FROM             dbo.Employee$
                               WHERE         (JobRole = 'Manager')) AS manager_education_percentage, COUNT(CASE WHEN JobRole != 'Manager' THEN 1 END) * 100.0 /
                             (SELECT       COUNT(*) AS Expr1
                               FROM             dbo.Employee$ AS Employee$_2
                               WHERE         (JobRole <> 'Manager')) AS non_manager_education_percentage
FROM            dbo.Employee$ AS Employee$_1 INNER JOIN
                         dbo.EducationLevel$ ON dbo.EducationLevel$.EducationLevelID = Employee$_1.Education
GROUP BY dbo.EducationLevel$.EducationLevel
ORDER BY dbo.EducationLevel$.EducationLevel
GO
/****** Object:  View [dbo].[View_OverAll_ManagersByGenderPerc]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_OverAll_ManagersByGenderPerc]
AS
SELECT       Gender, COUNT(*) * 100.0 /
                             (SELECT       COUNT(EmployeeID) AS Expr1
                               FROM             dbo.Employee$) AS overall_percentage
FROM            dbo.Employee$ AS Employee$_1
GROUP BY Gender
GO
/****** Object:  View [dbo].[View_PromotionRate]    Script Date: 10/18/2024 12:17:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_PromotionRate]
AS
SELECT       TOP (100) PERCENT dbo.Employee$.Department, dbo.Employee$.JobRole, dbo.PerformanceRating$.TrainingOpportunitiesTaken, COUNT(*) AS total_employees, SUM(CASE WHEN YearsSinceLastPromotion <> 0 THEN 1 ELSE 0 END) 
                         AS promoted_count, CAST(SUM(CASE WHEN Employee$.YearsSinceLastPromotion <> 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS promotion_rate, 
                         AVG(CASE WHEN YearsSinceLastPromotion <> 0 THEN YearsSinceLastPromotion ELSE NULL END) AS avg_years_to_promotion
FROM            dbo.Employee$ INNER JOIN
                         dbo.PerformanceRating$ ON dbo.Employee$.EmployeeID = dbo.PerformanceRating$.EmployeeID
GROUP BY dbo.Employee$.Department, dbo.Employee$.JobRole, dbo.PerformanceRating$.TrainingOpportunitiesTaken
ORDER BY promotion_rate DESC
GO
/****** Object:  View [dbo].[View_RetentionWithJobSatisfy]    Script Date: 10/18/2024 12:17:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_RetentionWithJobSatisfy]
AS
SELECT       TOP (10000) JS.JobSatisfaction, COUNT(*) AS total_employees, AVG(CASE WHEN attrition = 'No' THEN DATEDIFF(year, HireDate, GETDATE()) ELSE NULL END) AS avg_tenure
FROM            dbo.Employee$ INNER JOIN
                             (SELECT       dbo.PerformanceRating$.EmployeeID, dbo.SatisfiedLevel$.SatisfactionLevel AS JobSatisfaction
                               FROM             dbo.SatisfiedLevel$ INNER JOIN
                                                         dbo.PerformanceRating$ ON dbo.SatisfiedLevel$.SatisfactionID = dbo.PerformanceRating$.EnvironmentSatisfaction) AS JS ON dbo.Employee$.EmployeeID = JS.EmployeeID
GROUP BY JS.JobSatisfaction
ORDER BY JS.JobSatisfaction
GO
/****** Object:  View [dbo].[View_RetentionWithTraining]    Script Date: 10/18/2024 12:17:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_RetentionWithTraining]
AS
SELECT       TOP (10000) dbo.PerformanceRating$.TrainingOpportunitiesTaken, COUNT(*) AS total_employees, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count, 
                         CAST(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS attrition_rate
FROM            dbo.Employee$ INNER JOIN
                         dbo.PerformanceRating$ ON dbo.Employee$.EmployeeID = dbo.PerformanceRating$.EmployeeID
GROUP BY dbo.PerformanceRating$.TrainingOpportunitiesTaken
ORDER BY attrition_rate
GO
/****** Object:  View [dbo].[View_RetentioWithLifeBalance]    Script Date: 10/18/2024 12:17:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_RetentioWithLifeBalance]
AS
SELECT       TOP (10000) WLB.WorkLifeBalance, COUNT(*) AS total_employees, AVG(CASE WHEN attrition = 'No' THEN DATEDIFF(year, HireDate, GETDATE()) ELSE NULL END) AS avg_tenure
FROM            dbo.Employee$ INNER JOIN
                             (SELECT       dbo.PerformanceRating$.EmployeeID, dbo.SatisfiedLevel$.SatisfactionLevel AS WorkLifeBalance
                               FROM             dbo.SatisfiedLevel$ INNER JOIN
                                                         dbo.PerformanceRating$ ON dbo.SatisfiedLevel$.SatisfactionID = dbo.PerformanceRating$.WorkLifeBalance) AS WLB ON dbo.Employee$.EmployeeID = WLB.EmployeeID
GROUP BY WLB.WorkLifeBalance
ORDER BY WLB.WorkLifeBalance
GO
/****** Object:  View [dbo].[View_SalaryByEdu_Dept_JobRole]    Script Date: 10/18/2024 12:17:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_SalaryByEdu_Dept_JobRole]
AS
SELECT       TOP (10000) dbo.Employee$.Department, dbo.Employee$.JobRole, dbo.EducationLevel$.EducationLevel, AVG(dbo.Employee$.Salary) AS avg_salary, COUNT(*) AS total_employees
FROM            dbo.Employee$ INNER JOIN
                         dbo.EducationLevel$ ON dbo.EducationLevel$.EducationLevelID = dbo.Employee$.Education
GROUP BY dbo.Employee$.Department, dbo.Employee$.JobRole, dbo.EducationLevel$.EducationLevel
ORDER BY dbo.Employee$.Department, dbo.Employee$.JobRole, dbo.EducationLevel$.EducationLevel
GO








