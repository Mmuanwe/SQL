select *
from [Building-Data]..Working$


--Total Permit
select count([Permit Number])
from [Building-Data]..Working$

-- total Permit for 2015
select count([Permit Number])
from [Building-Data]..Working$
where YEAR([Permit Creation Date])= 2015

--total Permit for 2016
select count([Permit Number])
from [Building-Data]..Working$
where YEAR([Permit Creation Date])= 2016

--Permit for 2017
select count([Permit Number])
from [Building-Data]..Working$
where YEAR([Permit Creation Date])= 2017

--total Permit for 2018
select count([Permit Number])
from [Building-Data]..Working$
where YEAR([Permit Creation Date])= 2018


--STATUS UPDATE

select  [Current Status],
		SUM([Estimated Cost]) as TotalEstimatedCost,
		SUM([Revised Cost]) as TotalRevisedCost
from [Building-Data]..Working$
group by [Current Status]

--
select  YEAR([Permit Creation Date]) as permitYear,
		DATENAME(YEAR, [Permit Creation Date]) as YearName,
		AVG([Estimated Cost]) as AverageEstimatedCost,
		SUM([Revised Cost]) as TotalRevisedCost
from [Building-Data]..Working$
group by YEAR([Permit Creation Date]), DATENAME(YEAR, [Permit Creation Date])
Order by YEAR([Permit Creation Date])


--
select (COUNT(case when [Current Status]='complete' OR [Current Status]='issued' OR [Current Status]='approved'
then [Permit Number] end)*100.0)
/
COUNT([Permit Number]) GoodPermitPercentage
from [Building-Data]..Working$

---SUMMARRY

select  YEAR([Permit Creation Date]) as permitYear,
		DATENAME(YEAR, [Permit Creation Date]) as YearName,
		AVG([Estimated Cost]) as AverageEstimatedCost,
		SUM([Revised Cost]) as TotalRevisedCost
from [Building-Data]..Working$
group by YEAR([Permit Creation Date]), DATENAME(YEAR, [Permit Creation Date])
Order by YEAR([Permit Creation Date])
----
select  [Current Status],
		SUM([Estimated Cost]) as TotalEstimatedCost,
		SUM([Revised Cost]) as TotalRevisedCost
from [Building-Data]..Working$
group by [Current Status]
----
select  YEAR([Permit Creation Date]) as permitYear,
		AVG([Estimated Cost]) as AverageEstimatedCost,
		SUM([Revised Cost]) as TotalRevisedCost,
		[Existing Construction Type Desc] as ExistingConstructionType,
		[Proposed Construction Type Desc] as ProposedConstructionType,
		Zipcode as Zipcode,
		[Record ID] as RecordId
from [Building-Data]..Working$
group by YEAR([Permit Creation Date]),
[Existing Construction Type Desc],[Proposed Construction Type Desc],
Zipcode,[Record ID]
Order by YEAR([Permit Creation Date])
----