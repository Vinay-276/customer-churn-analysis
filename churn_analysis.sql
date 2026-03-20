create database project;
use project;
select * from churn;
DESCRIBE churn;


SELECT *
FROM churn
LIMIT 20;

SELECT *
FROM churn
WHERE TotalCharges IS NULL;

SELECT 
SUM(customerID IS NULL) AS customerID_nulls,
SUM(gender IS NULL) AS gender_nulls,
SUM(SeniorCitizen IS NULL) AS SeniorCitizen_nulls,
SUM(Partner IS NULL) AS Partner_nulls,
SUM(Dependents IS NULL) AS Dependents_nulls,
SUM(tenure IS NULL) AS tenure_nulls,
SUM(PhoneService IS NULL) AS PhoneService_nulls,
SUM(MultipleLines IS NULL) AS MultipleLines_nulls,
SUM(InternetService IS NULL) AS InternetService_nulls,
SUM(OnlineSecurity IS NULL) AS OnlineSecurity_nulls,
SUM(OnlineBackup IS NULL) AS OnlineBackup_nulls,
SUM(DeviceProtection IS NULL) AS DeviceProtection_nulls,
SUM(TechSupport IS NULL) AS TechSupport_nulls,
SUM(StreamingTV IS NULL) AS StreamingTV_nulls,
SUM(StreamingMovies IS NULL) AS StreamingMovies_nulls,
SUM(Contract IS NULL) AS Contract_nulls,
SUM(PaperlessBilling IS NULL) AS PaperlessBilling_nulls,
SUM(PaymentMethod IS NULL) AS PaymentMethod_nulls,
SUM(MonthlyCharges IS NULL) AS MonthlyCharges_nulls,
SUM(TotalCharges IS NULL) AS TotalCharges_nulls,
SUM(Churn IS NULL) AS Churn_nulls
FROM churn;


SELECT COUNT(*)
FROM churn
WHERE customerID = '';

select * from churn;
SELECT customerID, COUNT(*) AS duplicate_count
FROM churn
GROUP BY customerID
HAVING COUNT(*) > 1;


SELECT DISTINCT Contract
FROM churn;

select * from churn;

select distinct InternetService from churn;

select distinct PaymentMethod from churn;

select distinct Churn from churn;

select * from churn;



SELECT 'gender' AS column_name, gender AS value
FROM churn
GROUP BY gender

UNION

SELECT 'Partner', Partner
FROM churn
GROUP BY Partner

UNION

SELECT 'Dependents', Dependents
FROM churn
GROUP BY Dependents

UNION

SELECT 'PhoneService', PhoneService
FROM churn
GROUP BY PhoneService

UNION

SELECT 'MultipleLines', MultipleLines
FROM churn
GROUP BY MultipleLines

UNION

SELECT 'InternetService', InternetService
FROM churn
GROUP BY InternetService

UNION

SELECT 'OnlineSecurity', OnlineSecurity
FROM churn
GROUP BY OnlineSecurity

UNION

SELECT 'OnlineBackup', OnlineBackup
FROM churn
GROUP BY OnlineBackup

UNION

SELECT 'DeviceProtection', DeviceProtection
FROM churn
GROUP BY DeviceProtection

UNION

SELECT 'TechSupport', TechSupport
FROM churn
GROUP BY TechSupport

UNION

SELECT 'StreamingTV', StreamingTV
FROM churn
GROUP BY StreamingTV

UNION

SELECT 'StreamingMovies', StreamingMovies
FROM churn
GROUP BY StreamingMovies

UNION

SELECT 'Contract', Contract
FROM churn
GROUP BY Contract

UNION

SELECT 'PaperlessBilling', PaperlessBilling
FROM churn
GROUP BY PaperlessBilling

UNION

SELECT 'PaymentMethod', PaymentMethod
FROM churn
GROUP BY PaymentMethod

UNION

SELECT 'Churn', Churn
FROM churn
GROUP BY Churn;


SELECT *
FROM churn
WHERE tenure < 0
   OR MonthlyCharges < 0
   OR TotalCharges < 0;
   
   
   SELECT 
MIN(tenure) AS min_tenure,
MAX(tenure) AS max_tenure,
MIN(MonthlyCharges) AS min_monthly,
MAX(MonthlyCharges) AS max_monthly,
MIN(TotalCharges) AS min_total,
MAX(TotalCharges) AS max_total
FROM churn;

SELECT *
FROM churn
WHERE tenure = 0 AND TotalCharges > 0;

SELECT COUNT(*) 
FROM churn;


SELECT 
customerID,
tenure,
CASE
WHEN tenure <= 12 THEN '0-12 Months'
WHEN tenure <= 24 THEN '13-24 Months'
WHEN tenure <= 48 THEN '25-48 Months'
ELSE '48+ Months'
END AS TenureGroup
FROM churn;


SELECT
customerID,
MonthlyCharges,
Churn,
CASE
WHEN Churn = 'Yes' THEN MonthlyCharges
ELSE 0
END AS RevenueLost
FROM churn;



CREATE TABLE churn_clean AS
SELECT
*,
CASE
WHEN tenure <= 12 THEN '0-12 Months'
WHEN tenure <= 24 THEN '13-24 Months'
WHEN tenure <= 48 THEN '25-48 Months'
ELSE '48+ Months'
END AS TenureGroup,

CASE
WHEN Churn = 'Yes' THEN MonthlyCharges
ELSE 0
END AS RevenueLost

FROM churn;


select * from churn;

SELECT TenureGroup, COUNT(*)
FROM churn_clean
GROUP BY TenureGroup;


SELECT SUM(RevenueLost)
FROM churn_clean;

select * from churn_clean;

CREATE TABLE churn_clean AS
SELECT
*,

CASE
WHEN tenure <= 12 THEN '0-12 Months'
WHEN tenure <= 24 THEN '13-24 Months'
WHEN tenure <= 48 THEN '25-48 Months'
ELSE '48+ Months'
END AS TenureGroup,

CASE
WHEN Churn = 'Yes' THEN MonthlyCharges
ELSE 0
END AS RevenueLost

FROM churn;



--- kpis
--- Percentage of customers who leave during a given period.
SELECT 
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churn_count,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS churn_rate
FROM churn_clean;


--- Monthly Recurring Revenue (MRR)


SELECT 
    Contract,
    COUNT(*) AS total_customers,
    
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS churn_rate,
    
    SUM(MonthlyCharges) AS total_revenue,
    
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) AS revenue_lost,
    
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) * 1.0 / SUM(MonthlyCharges) AS revenue_loss_rate

FROM churn_clean
GROUP BY Contract
ORDER BY revenue_loss_rate DESC;


SELECT COUNT(*) AS total_customers
FROM churn_clean;

-- KPI 2: Churned Customers
select count(*) as churned_customers from churn_clean where churn = "Yes";


--- Churn Rate (%)
select count(case when churn = "Yes" then 1 end),
 count(case when churn = "Yes" then 1 END) * 100 / count(*) AS churn_rate from churn_clean;
 
 -- Monthly Recurring Revenue (MRR)
 
 
 SELECT 
    SUM(MonthlyCharges) AS total_mrr
FROM churn_clean;


-- Revenue Leakage
SELECT 
    SUM(MonthlyCharges) AS revenue_leakage
FROM churn_clean
WHERE Churn = 'Yes';

--- Revenue Churn Rate (%)
SELECT 
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) * 100.0 
    / SUM(MonthlyCharges) AS revenue_churn_rate
FROM churn_clean;

-- ARPU (Average Revenue Per User)
SELECT 
    SUM(MonthlyCharges) * 1.0 / COUNT(*) AS arpu
FROM churn_clean;

-- Average Tenure
SELECT 
    AVG(Tenure) AS avg_tenure
FROM churn_clean;


select * from churn_clean;


-- Churn by Tenure Group

SELECT 
    CASE 
        WHEN Tenure <= 6 THEN '0-6 Months'
        WHEN Tenure <= 12 THEN '6-12 Months'
        WHEN Tenure <= 24 THEN '1-2 Years'
        ELSE '2+ Years'
    END AS tenure_group,
    
    COUNT(*) AS total_customers,
    
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS churn_rate

FROM churn_clean
GROUP BY tenure_group
ORDER BY churn_rate DESC;

--- Which contract type contributes most to revenue loss?

SELECT 
    Contract,
    COUNT(*) AS churned_customers,
    SUM(MonthlyCharges) AS revenue_loss
FROM churn_clean
WHERE Churn = 'Yes'
GROUP BY Contract
ORDER BY revenue_loss DESC;

-- Revenue Loss by Tenure

SELECT 
    CASE 
        WHEN Tenure <= 6 THEN '0-6 Months'
        WHEN Tenure <= 12 THEN '6-12 Months'
        WHEN Tenure <= 24 THEN '1-2 Years'
        ELSE '2+ Years'
    END AS tenure_group,
    
    COUNT(*) AS churned_customers,
    SUM(MonthlyCharges) AS revenue_loss

FROM churn_clean
WHERE Churn = 'Yes'
GROUP BY tenure_group
ORDER BY revenue_loss DESC;

-- 
SELECT 
    CASE 
        WHEN MonthlyCharges < 50 THEN 'Low Value'
        WHEN MonthlyCharges < 80 THEN 'Medium Value'
        ELSE 'High Value'
    END AS customer_segment,

    COUNT(*) AS total_customers,
    
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS churn_rate

FROM churn_clean
GROUP BY customer_segment
ORDER BY churn_rate DESC;


--- Do add-on services reduce churn?

SELECT 
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS churn_rate
FROM churn_clean
GROUP BY TechSupport
ORDER BY churn_rate DESC;

SELECT 
    OnlineSecurity,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS churn_rate
FROM churn_clean
GROUP BY OnlineSecurity
ORDER BY churn_rate DESC;

SELECT 
    SeniorCitizen,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS churn_rate
FROM churn_clean
GROUP BY SeniorCitizen;
