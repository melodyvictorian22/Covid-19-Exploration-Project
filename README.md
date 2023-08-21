# Covid-19 Exploration Project
This is a project to exploration data with SQL and make a dashboard with Tableau using dataset Covid 19 in 2020-2021 
that I took from Alex Freberg on Youtube to complete Data Analyst Bootcamp.

Dataset Covid Deaths : https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidDeaths.xlsx

Dataset Covid Vaccinations : https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidVaccinations.xlsx

### Covid 19 Dashboard
![Covid 19 Dashboard](https://github.com/melodyvictorian22/Covid-19-Exploration-Project/assets/50192955/dba6b8a0-0b30-4765-9927-542cc512c5ae)

### Data Exploration
1. Calculate deaths percentage
   ```
   Select sum(new_cases) as total_cases, sum(new_deaths)as total_deaths, (nullif(sum(new_deaths),0)/nullif(sum(new_cases),0))*100 as percent_deaths
   from CovidDeaths
   where continent != ''
   ```

2. Looking at countries with highest infection rate compared to population
   ```
   Select location, population, max(total_cases) as HighestInfectionCount, max((NULLIF(total_cases,0)/NULLIF(population,0)))*100 as percent_populations_infected
   from CovidDeaths
   where continent !=''
   group by location, population
   order by percent_populations_infected desc
   ```

3. Looking at countries with highest infection rate compared to population based on date
   ```
   Select location, date, population, max(total_cases) as HighestInfectionCount, max((NULLIF(total_cases,0)/NULLIF(population,0)))*100 as percent_populations_infected
   from CovidDeaths
   where continent !=''
   group by location, population, date
   order by percent_populations_infected desc
   ```

4. Showing continent with highest death count per population
   ```
   Select continent, MAX(total_deaths) as TotalDeathCount
   from CovidDeaths
   where continent != ''
   group by continent
   order by TotalDeathCount desc
   ```

### Insights
- The worldwide death rate is 2.11%. Europe has the highest death count followed by North America, South America, Asia, Africa and Oceania. 
- On the infection rate map, we could see how severe the outbreak. Darker color means higher infection rate,
  Europe seems a darker red and the death data confirms that Europe has the highest death count.

See full interactive Tableau dashboard : https://public.tableau.com/app/profile/melody.victorian/viz/Covid19Project_16923526886160/Dashboard1
