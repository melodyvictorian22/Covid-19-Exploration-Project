select *
from CovidDeaths


select *
from CovidVaccinations

-- Select data that we are going to using
select location, date,  total_cases, new_cases, total_deaths, population
from CovidDeaths
where continent != ''

-- change datatypes
Alter Table CovidDeaths
Alter column total_cases float 


Alter Table CovidDeaths
Alter column total_deaths float

Alter Table CovidDeaths
Alter column population float

Alter Table CovidDeaths
Alter column new_cases float

Alter Table CovidDeaths
Alter column new_deaths float

-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (NULLIF(total_deaths,0)/NULLIF(total_cases,0))*100 as percent_deaths
from CovidDeaths
where location like '%indonesia%' and continent != ''

-- Looking at total cases vs population
-- shows what percentage of population got covid
Select location, date, population, total_cases, (NULLIF(total_cases,0)/NULLIF(population,0))*100 as percent_populations_infected
from CovidDeaths
where location like '%indonesia%' and continent != ''

-- looking at countries with highest infection rate compared to population
Select location, population, max(total_cases) as HighestInfectionCount, max((NULLIF(total_cases,0)/NULLIF(population,0)))*100 as percent_populations_infected
from CovidDeaths
where continent !=''
group by location, population
order by percent_populations_infected desc

Select location, date, population, max(total_cases) as HighestInfectionCount, max((NULLIF(total_cases,0)/NULLIF(population,0)))*100 as percent_populations_infected
from CovidDeaths
where continent !=''
group by location, population, date
order by percent_populations_infected desc

-- showing countries with highest death count per population
Select location, MAX(total_deaths) as TotalDeathCount
from CovidDeaths
where continent != ''
group by location
order by TotalDeathCount desc

-- lets break things down by continent
Select continent, SUM(new_deaths) as TotalDeathCount
from CovidDeaths
where continent != ''
group by continent
order by TotalDeathCount desc

-- showing continent with highest death count per population
Select continent, MAX(total_deaths) as TotalDeathCount
from CovidDeaths
where continent != ''
group by continent
order by TotalDeathCount desc

-- global numbers
Select sum(new_cases) as total_cases, sum(new_deaths)as total_deaths, (nullif(sum(new_deaths),0)/nullif(sum(new_cases),0))*100 as percent_deaths
from CovidDeaths
where continent != ''
--group by date

-- global numbers by date
Select date, sum(new_cases) as total_cases, sum(new_deaths)as total_deaths, (nullif(sum(new_deaths),0)/nullif(sum(new_cases),0))*100 as percent_deaths
from CovidDeaths
where continent != ''
group by date


-- join two tables
select *
from CovidDeaths dea
	join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

-- looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
	join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent != ''

-- use CTE
with PopvsVac (continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
as
(
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
		dea.date) as RollingPeopleVaccinated
	from CovidDeaths dea
		join CovidVaccinations vac
		on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent != ''
)
select *, (nullif(RollingPeopleVaccinated,0)/nullif(population,0))*100
from PopvsVac

--temp table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
		dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
	join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent != ''

select *, (nullif(RollingPeopleVaccinated,0)/nullif(population,0))*100
from #PercentPopulationVaccinated

-- creating view to store data for later visualizations
create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
		dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
	join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent != ''

select *
from PercentPopulationVaccinated