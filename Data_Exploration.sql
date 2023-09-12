select * 
from covid_death
order by 3,4

-- Select Data needed
Select location, date, total_cases, total_deaths, population
from covid_death
order by 1,2;

-- Looking at total cases vs total deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_death
where location like '%VietNam%'
order by 1,2;


-- Looking at total cases vs population
Select location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
from covid_death
where location like '%VietNam%'
order by 1,2;


-- Looking at country with highest infection rate compare to population
Select location, population ,MAX(total_cases) as Maxcases, Max((total_cases/population)*100) as MaxInfectedPercentage
from covid_death
Group by location , population
order by 1,2;

-- Showing countries with highest death count per population
Select location, Max(total_deaths) as MaxDeathCount
From covid_death
where continent is not null
group by location 
order by totalDeathCount desc


-- Showing continents with highest death count
Select continent, Max(total_deaths) as MaxDeathCount
From covid_death
where continent is not null
group by continent 
order by MaxDeathCount desc

-- Global numbers
Select date, Sum(new_cases) as TotalCases, Sum(new_deaths) as TotalDeaths , Sum(new_deaths)/Sum(new_cases) * 100 as DeathPercentage
from covid_death
where continent is not null
Group by date
order by 1,2;


-- Join Covid_death and Covid_vaccination
Select dea.continent , dea.location , dea.date, dea.population, vac.new_vaccinations ,SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location, dea.date ) as Total_Vaccination
From covid_death as dea
join covid_vaccinations as vac
	on dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null 
order by  2, 3

-- USE CTE
With PopvsVac (continent, Location , date, population , new_vaccinations, rollingpeoplevaccinated)
as (
Select dea.continent , dea.location , dea.date, dea.population, vac.new_vaccinations ,SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location, dea.date ) as rollingpeoplevaccinated
From covid_death as dea
join covid_vaccinations as vac
	on dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null 
order by  2, 3
)
Select * , (rollingpeoplevaccinated / population) * 100 as VaccinatedPercentage
from PopvsVac


-- Temp table
Create temporary table PercentagePopulationVaccinated (
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population double,
New_vaccination double,
RollingPeopleVaccinated double )

Insert into PercentagePopulationVaccinated
Select dea.continent , dea.location , dea.date, dea.population, vac.new_vaccinations ,SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location, dea.date ) as rollingpeoplevaccinated
From covid_death as dea
join covid_vaccinations as vac
	on dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null 
-- order by  2, 3


Select * , (rollingpeoplevaccinated / population) * 100 as VaccinatedPercentage
from PercentagePopulationVaccinated


-- Create view for visuallization 
Create view PercentagePopulationVaccinated as 
Select dea.continent , dea.location , dea.date, dea.population, vac.new_vaccinations ,SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location, dea.date ) as rollingpeoplevaccinated
From covid_death as dea
join covid_vaccinations as vac
	on dea.location = vac.location 
    and dea.date = vac.date
where dea.continent is not null 
order by  2, 3
