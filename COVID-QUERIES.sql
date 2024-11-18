select *
from PortfolioProj.dbo.['owid-covid-data-deaths$']

select *
from PortfolioProj.dbo.['owid-covid-data-deaths$']
order by 3,4
--Selext data ro use
select location, date, total_cases, new_cases, total_deaths, population_density
from PortfolioProj.dbo.['owid-covid-data-deaths$']
order by 1,2


--total deaths vs total cases
select location, population_density, total_cases, total_deaths, (total_deaths/NULLIF(total_cases, 0))*100 as DeathPercent
from PortfolioProj.dbo.['owid-covid-data-deaths$']
where location like '%states%'
order by 1,2

--total death vs population
select location, population_density, total_cases, total_deaths, (population_density/NULLIF(total_cases, 0))*100 as PopulationDeathPercent
from PortfolioProj.dbo.['owid-covid-data-deaths$']
where location like '%states%'
order by 1,2


--total death percentage
select continent,total_cases,population_density, MAX(total_cases) as HighestInfection, (population_density/NULLIF(total_cases, 0))*100
as PopulationDeathPercent
from PortfolioProj.dbo.['owid-covid-data-deaths$']
where continent is not null
Group by continent,total_cases,population_density
order by 1,2


---coutry with the higest deaths
select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProj.dbo.['owid-covid-data-deaths$']
where continent is not null
Group by location
order by TotalDeathCount

--Global numbers DO VIEW
select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,  SUM(new_cases)/NULLIF(SUM(cast(new_deaths as int)),0) *100 as DeathPercent
from PortfolioProj.dbo.['owid-covid-data-deaths$']
--where location like '%states%'
where continent is not null
Group by date
order by 1,2

--pepole geteing vaccinated
select dea.population_density, dea.location, dea.date, dea.continent,vac.new_vaccinations,
SUM(CONVERT(bigint,NULLIF(vac.new_vaccinations,0))) OVER (Partition by dea.location order by dea.date,
dea.location) AS PeopleGettingVaccinated
from PortfolioProj.dbo.['owid-covid-data-deaths$'] dea
Join PortfolioProj..['covid-data-vacc$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



----people getting vaccinated vs population density DO VIEW
--using cte
With Provsp (Population_Density, Location, Date, Continent,New_Vaccinations,PeopleGettingVaccinated)
as(
select dea.population_density, dea.location, dea.date, dea.continent,vac.new_vaccinations,
SUM(CONVERT(bigint,NULLIF(vac.new_vaccinations,0))) OVER (Partition by dea.location order by dea.date,
dea.location) AS PeopleGettingVaccinated
from PortfolioProj.dbo.['owid-covid-data-deaths$'] dea
Join PortfolioProj..['covid-data-vacc$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *,(PeopleGettingVaccinated/Population_Density)*100 as PercentagePeopleGettingVaccinated
from Provsp

--using temp table
DROP TABLE if exists #PercentagePeopleGettingVaccinated
Create Table #PercentagePeopleGettingVaccinated(
Population_Density numeric, 
Location varchar(225), 
Date datetime, 
Continent varchar(225),
New_Vaccinations  numeric,
PeopleGettingVaccinated numeric
)

insert into #PercentagePeopleGettingVaccinated
select dea.population_density, dea.location, dea.date, dea.continent,vac.new_vaccinations,
SUM(CONVERT(bigint,NULLIF(vac.new_vaccinations,0))) OVER (Partition by dea.location order by dea.date,
dea.location) AS PeopleGettingVaccinated
from PortfolioProj.dbo.['owid-covid-data-deaths$'] dea
Join PortfolioProj..['covid-data-vacc$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *,(PeopleGettingVaccinated/NULLIF((Population_Density),0))*100 as PercentagePeopleGettingVaccinated
from #PercentagePeopleGettingVaccinated



--Creating view for visualization
Create View PercentagePeopleGettingVaccinatedview as
select dea.population_density, dea.location, dea.date, dea.continent,vac.new_vaccinations,
SUM(CONVERT(bigint,NULLIF(vac.new_vaccinations,0))) OVER (Partition by dea.location order by dea.date,
dea.location) as PeopleGettingVaccinated
from PortfolioProj.dbo.['owid-covid-data-deaths$'] dea
Join PortfolioProj..['covid-data-vacc$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentagePeopleGettingVaccinatedview

CREATE VIEW DeathPercent as
select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,  SUM(new_cases)/NULLIF(SUM(cast(new_deaths as int)),0) *100 as DeathPercent
from PortfolioProj.dbo.['owid-covid-data-deaths$']
where continent is not nul
Group by date
--order by 1,2

select * from DeathPercent