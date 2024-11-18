select *
from PortfolioProj.dbo.Sheet1$

----standerdizing Date Format
select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProj.dbo.Sheet1$

Update Sheet1$
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE Sheet1$
Add SalesDateConverted Date;

Update Sheet1$
SET SalesDateConverted = CONVERT(Date, SaleDate)

select SalesDateConverted
from PortfolioProj.dbo.Sheet1$

--Property Addressdata
select *
from PortfolioProj.dbo.Sheet1$
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) as PropertyEstablished
from PortfolioProj.dbo.Sheet1$ a
join PortfolioProj.dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	and convert(float, a.[UniqueID ])<> convert(float, b.[UniqueID ])
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
from PortfolioProj.dbo.Sheet1$ a
join PortfolioProj.dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	and convert(float, a.[UniqueID ])<> convert(float, b.[UniqueID ])
where a.PropertyAddress is null



--Breaking address into address, city, state
select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as PropertyMainAddress,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as PropertyMainCity
from PortfolioProj.dbo.Sheet1$

--IF OBJECT_ID('Sheet1$') IS NOT NULL
ALTER TABLE PortfolioProj.dbo.Sheet1$
Add PropertyMainAdress Nvarchar(255);

--IF OBJECT_ID('Sheet1$') IS NOT NULL
Update  PortfolioProj.dbo.Sheet1$
SET PropertyMainAdress =  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

--IF OBJECT_ID('Sheet1$') IS NOT NULL
ALTER TABLE  PortfolioProj.dbo.Sheet1$
Add  PropertyMainCity nvarchar(255);

--IF OBJECT_ID('Sheet1$') IS NOT NULL
Update  PortfolioProj.dbo.Sheet1$
SET  PropertyMainCity = SUBSTRING(PropertyAddress ,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select *
from PortfolioProj.dbo.Sheet1$



---change y & n to yes and no

select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProj.dbo.Sheet1$
Group by SoldAsVacant
Order by 2

select SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 END
from PortfolioProj.dbo.Sheet1$

Update PortfolioProj.dbo.Sheet1$
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 END

--- removing duplicates
WITH RowNumCTE AS
(
select *, ROW_NUMBER()
OVER(PARTITION BY
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID) row_num
from PortfolioProj.dbo.Sheet1$
)

DELETE
from RowNumCTE
where row_num>1
--Order by PropertyAddress



--delete unused column
select *
from PortfolioProj.dbo.Sheet1$


ALTER TABLE PortfolioProj.dbo.Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

