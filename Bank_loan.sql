select *
from Bank_loan..bank_loan_data

--Loan amount december
select sum(loan_amount) as MTD_Total_funded
from Bank_loan..bank_loan_data
where MONTH(issue_date)=12 and YEAR(issue_date)= 2021

--loan amount november
select sum(loan_amount) as PMTD_Total_funded
from Bank_loan..bank_loan_data
where MONTH(issue_date)=11 and YEAR(issue_date)= 2021

--total payment recieved december
select SUM(total_payment) as Total_Amount_Recieved
from Bank_loan..bank_loan_data
where MONTH(issue_date)=12 and YEAR(issue_date)= 2021

--total payment recievied november
select SUM(total_payment) as Total_Amount_Recieved
from Bank_loan..bank_loan_data
where MONTH(issue_date)=11 and YEAR(issue_date)= 2021

--Average interest rate on December and November
select ROUND(AVG(int_rate),4)*100 as Average_Int_rate
from Bank_loan..bank_loan_data
where MONTH(issue_date)=12 and YEAR(issue_date)= 2021

select ROUND(AVG(dti),4)*100 as PMND_Average_dti
from Bank_loan..bank_loan_data
where MONTH(issue_date)=12 and YEAR(issue_date)= 2021


--on Good loans
select
(COUNT(case when loan_status='Fully Paid' OR loan_status='Current' then id end)*100.0)
/
COUNT(id) as Good_loan_percentage
from Bank_loan..bank_loan_data

select COUNT(id) as Good_loan_application
from Bank_loan..bank_loan_data
where loan_status='Fully Paid' OR loan_status='Current'

select SUM(loan_amount) as Good_loan_funded
from Bank_loan..bank_loan_data
where loan_status='Fully Paid' OR loan_status='Current'

select SUM(total_payment) as Good_loan_Recieved_amount
from Bank_loan..bank_loan_data
where loan_status='Fully Paid' OR loan_status='Current'

--on Bad loans
select
(COUNT(case when loan_status='Charged off' then id end)*100.0)
/
COUNT(id) as Bad_loan_percentage
from Bank_loan..bank_loan_data

select COUNT(id) as Bad_loan_application
from Bank_loan..bank_loan_data
where loan_status='Charged off'

select SUM(loan_amount) as Bad_loan_funded
from Bank_loan..bank_loan_data
where loan_status='Charged off'

select SUM(total_payment) as Bad_loan_Recieved_amount
from Bank_loan..bank_loan_data
where loan_status='Charged off'
--SUMMARY
select loan_status,
		COUNT(id) as Total_loan_application,
		SUM(total_payment) as Total_amount_Recieved,
		SUM(loan_amount) as Total_Funded_Amount,
		AVG(int_rate *100) as Interest_rate,
		AVG(dti *100) as DTI
from Bank_loan..bank_loan_data
Group by loan_status

select loan_status,
		SUM(total_payment) as MTD_Total_amount_Recieved,
		SUM(loan_amount) as MTD_Total_Funded_Amount
from Bank_loan..bank_loan_data
where MONTH(issue_date)=12
Group by loan_status

select 
		MONTH(issue_date) Month_No,
		DATENAME(MONTH, issue_date) as Month_Name,
		COUNT(id) as Total_loan_application,
		SUM(total_payment) as Total_amount_Recieved,
		SUM(loan_amount) as Total_Funded_Amount
from Bank_loan..bank_loan_data
Group by MONTH(issue_date), DATENAME(MONTH, issue_date)
order by MONTH(issue_date)

select 
		address_state as Address_state,
		COUNT(id) as Total_loan_application,
		SUM(total_payment) as Total_amount_Recieved,
		SUM(loan_amount) as Total_Funded_Amount
from Bank_loan..bank_loan_data
Group by address_state
order by SUM(loan_amount) desc

select 
		term as Term,
		COUNT(id) as Total_loan_application,
		SUM(total_payment) as Total_amount_Recieved,
		SUM(loan_amount) as Total_Funded_Amount
from Bank_loan..bank_loan_data
Group by term
order by term

select 
		emp_length,
		COUNT(id) as Total_loan_application,
		SUM(total_payment) as Total_amount_Recieved,
		SUM(loan_amount) as Total_Funded_Amount
from Bank_loan..bank_loan_data
Group by emp_length
order by COUNT(id) desc

select 
		purpose,
		COUNT(id) as Total_loan_application,
		SUM(total_payment) as Total_amount_Recieved,
		SUM(loan_amount) as Total_Funded_Amount
from Bank_loan..bank_loan_data
Group by purpose
order by COUNT(id) desc

select 
		home_ownership,
		COUNT(id) as Total_loan_application,
		SUM(total_payment) as Total_amount_Recieved,
		SUM(loan_amount) as Total_Funded_Amount
from Bank_loan..bank_loan_data
where grade='A' and address_state= 'CA'
Group by home_ownership
order by COUNT(id) desc

