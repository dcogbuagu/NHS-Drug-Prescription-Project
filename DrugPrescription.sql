-- Creating a database 

CREATE DATABASE PrescriptionsDB;

-- Switching to the newly created PrescriptionsDB database environment for use

USE PrescriptionsDB
GO

-- Importing the three flat files provided for the task using , after unzipping the folder 

--2) To returns details of all drugs which are in form of tables or capsules

SELECT *
FROM Drugs
WHERE BNF_DESCRIPTION LIKE '%tablet%' OR BNF_DESCRIPTION LIKE '%capsule%';

-- 3)  To return the  Total Quantity of Prescriptions

SELECT PRESCRIPTION_CODE, ROUND(items * quantity, 0) AS total_quantity
FROM Prescriptions;

select * from prescriptions

-- 4) Write a query that returns a list of the distinct chemical substances which appear in 
-- the Drugs table

SELECT DISTINCT CHEMICAL_SUBSTANCE_BNF_DESCR
FROM Drugs;

-- 5) Write a query that returns the number of prescriptions for each 
-- BNF_CHAPTER_PLUS_CODE, along with the average cost for that chapter code, and the 
-- minimum and maximum prescription costs for that chapter code.

SELECT d.BNF_CHAPTER_PLUS_CODE, 
COUNT(p.PRESCRIPTION_CODE) AS Number_of_Prescriptions,
ROUND(AVG(p.ACTUAL_COST),2) AS Average_Cost,
MIN(p.ACTUAL_COST) AS Minimum_Cost, 
MAX(p.ACTUAL_COST) AS Maximum_Cost
FROM Prescriptions p
JOIN Drugs d ON p.BNF_CODE = d.BNF_CODE
GROUP BY d.BNF_CHAPTER_PLUS_CODE
ORDER BY d.BNF_CHAPTER_PLUS_CODE;

-- 6) Write a query that returns the most expensive prescription prescribed by each 
--practice, sorted in descending order by prescription cost (the ACTUAL_COST column in 
--the prescription table.) Return only those rows where the most expensive prescription 
--is more than £4000. You should include the practice name in your result.




SELECT mp.PRACTICE_NAME, MAX(pr.ACTUAL_COST) AS MAX_ACTUAL_COST
FROM Medical_Practice mp
INNER JOIN Prescriptions pr ON mp.PRACTICE_CODE = pr.PRACTICE_CODE
WHERE pr.ACTUAL_COST > 4000
GROUP BY mp.PRACTICE_NAME
ORDER BY MAX_ACTUAL_COST DESC

--7.	Five queries of with a brief explanation of the 
--results which each query returns, making use of all of the following at least once:
--Nested query including use of EXISTS or IN,
--Joins, 
--System functions,
--Use of GROUP BY,
--HAVING and ORDER BY clauses

-- Query 1
--	To returns the total number of prescriptions made by each practice in descending order 

SELECT Medical_Practice.Practice_Name, COUNT(*) as Num_Prescriptions
FROM Medical_Practice
INNER JOIN Prescriptions ON Medical_Practice.Practice_Code = Prescriptions.PRACTICE_CODE
GROUP BY Medical_Practice.Practice_Name
ORDER BY Num_Prescriptions DESC;


--Query 2
-- To return drugs with number of prescription above 100

SELECT Drugs.BNF_DESCRIPTION, COUNT(Prescriptions.BNF_CODE) AS Total_Prescriptions
FROM Drugs
LEFT JOIN Prescriptions ON Drugs.BNF_CODE = Prescriptions.BNF_CODE
GROUP BY Drugs.BNF_DESCRIPTION
HAVING COUNT (*) > 100
ORDER BY Total_Prescriptions DESC 


-- Query 3.
-- Using the LEN function to return the name of each practice along with the number of 
-- characters in the PRACTICE_NAME column:

SELECT PRACTICE_NAME, LEN(PRACTICE_NAME) AS NameLength
FROM Medical_Practice;

--The query 3 above returns a result set with two columns: the first column contains the name of 
-- each practice, and the second column contains the length of the name in characters.

-- Query 4.
-- a query to return details of medical practices with top 10 prescriptions using exists nested querry
SELECT M.Practice_Code, M.Practice_Name, COUNT(*) AS Num_Prescriptions
FROM Medical_Practice M
WHERE EXISTS (
  SELECT 1
  FROM Prescriptions P
  WHERE P.Practice_Code = M.Practice_Code
)
GROUP BY M.Practice_Code, M.Practice_Name

-- Query 5 
-- A query to return the drugs with the highest average cost per prescription
SELECT Drugs.BNF_DESCRIPTION, AVG(Prescriptions.ACTUAL_COST) AS Average_Cost
FROM Drugs
JOIN Prescriptions ON Drugs.BNF_CODE = Prescriptions.BNF_CODE
GROUP BY Drugs.BNF_DESCRIPTION
HAVING AVG(Prescriptions.ACTUAL_COST) > 100
ORDER BY Average_Cost DESC;





