select * 
from Project..['food-waste-pilot_excel$']
---CHANGING THE NAME
select [stop_name;date_collection_datetime;lbs_collected;compost_created] as MainColumn
from Project..['food-waste-pilot_excel$']

ALTER TABLE  Project..['food-waste-pilot_excel$']
Add MainColumn Nvarchar(255);

Update  Project..['food-waste-pilot_excel$']
SET MainColumn =  [stop_name;date_collection_datetime;lbs_collected;compost_created]


ALTER TABLE  Project..['food-waste-pilot_excel$']
DROP COLUMN  [stop_name;date_collection_datetime;lbs_collected;compost_created]

select * 
from Project..['food-waste-pilot_excel$']

---SEPERATING THE NEW COLUMN

Select SUBSTRING(MainColumn,1, CHARINDEX(';', MainColumn) -1) as Stop_Name,
 SUBSTRING(MainColumn,CHARINDEX(';', MainColumn)+1, LEN(MainColumn)) as DateTime_Collection
 from Project..['food-waste-pilot_excel$']

 ALTER TABLE  Project..['food-waste-pilot_excel$']
Add Stop_Name Nvarchar(255);

Update  Project..['food-waste-pilot_excel$']
SET Stop_Name =   SUBSTRING(MainColumn,1, CHARINDEX(';', MainColumn) -1)



ALTER TABLE  Project..['food-waste-pilot_excel$']
Add DateTime_Collections Nvarchar(255);

Update  Project..['food-waste-pilot_excel$']
SET DateTime_Collections =   SUBSTRING(MainColumn,CHARINDEX(';', MainColumn)+1, LEN(MainColumn))

--SPLITTING THE DATE_COLLECTION

select * 
from Project..['food-waste-pilot_excel$']


Select SUBSTRING(DateTime_Collections,1, CHARINDEX(';',DateTime_Collections) -1) as Date_collection,
 SUBSTRING(DateTime_Collections,CHARINDEX(';', DateTime_Collections)+1, LEN(DateTime_Collections)) as Weight_lb
 from Project..['food-waste-pilot_excel$']

 ALTER TABLE  Project..['food-waste-pilot_excel$']
Add DateTime_Collection Nvarchar(255);

Update  Project..['food-waste-pilot_excel$']
SET DateTime_Collection =  SUBSTRING(DateTime_Collections,1, CHARINDEX(';',DateTime_Collections) -1)


ALTER TABLE  Project..['food-waste-pilot_excel$']
Add Weight_lb Nvarchar(255);

Update  Project..['food-waste-pilot_excel$']
SET Weight_lb =  SUBSTRING(DateTime_Collections,CHARINDEX(';', DateTime_Collections)+1, LEN(DateTime_Collections))


ALTER TABLE  Project..['food-waste-pilot_excel$']
DROP COLUMN  DateTime_Collections

--SPLITTING THE WEIGHT_LB
select * 
from Project..['food-waste-pilot_excel$']


Select SUBSTRING(Weight_lb,1, CHARINDEX(';',Weight_lb) -1) as lbs_collected,
 SUBSTRING(Weight_lb,CHARINDEX(';', Weight_lb)+1, LEN(Weight_lb)) as compost_created_lb
 from Project..['food-waste-pilot_excel$']

 ALTER TABLE  Project..['food-waste-pilot_excel$']
Add lbs_collected Nvarchar(255);

Update  Project..['food-waste-pilot_excel$']
SET lbs_collected =  SUBSTRING(Weight_lb,1, CHARINDEX(';',Weight_lb) -1)


ALTER TABLE  Project..['food-waste-pilot_excel$']
Add compost_created_lb Nvarchar(255);

Update  Project..['food-waste-pilot_excel$']
SET compost_created_lb =   SUBSTRING(Weight_lb,CHARINDEX(';', Weight_lb)+1, LEN(Weight_lb))


ALTER TABLE  Project..['food-waste-pilot_excel$']
DROP COLUMN  MainColumn, Weight_lb

--WORKING ON DATE
select DateTime_Collection, CONVERT(Date, DateTime_Collection)
from Project..['food-waste-pilot_excel$']

ALTER TABLE  Project..['food-waste-pilot_excel$']
Add Date_Time Nvarchar(255);

Update  Project..['food-waste-pilot_excel$']
SET Date_Time =   CONVERT(Date, DateTime_Collection)


ALTER TABLE  Project..['food-waste-pilot_excel$']
DROP COLUMN  DateTime_Collection

--CHECKING FOR DULICATES
With RowNumCTE AS(
select *, ROW_NUMBER()
		OVER(PARTITION BY
			Date_Time
			ORDER BY
			Stop_Name
		) rownum
from Project..['food-waste-pilot_excel$']
)
DELETE
from RowNumCTE
where rownum>1

--54 duplicates
--Select rownum
--from RowNumCTE
--where rownum > 1