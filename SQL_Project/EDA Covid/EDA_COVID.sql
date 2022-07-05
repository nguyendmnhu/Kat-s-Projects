/* Exploratory Data Analysis of COVID 19 Data over 160,000 attribute
Skills: Converting Data Type, Joins, Aggregate Function, CTE's, Temp Tables, Createing Views
*/

-- Checking all attributes in the Covid Deaths file
select *
from EDA_COVID..CovidDeaths
order by 3,4 

-- Select only attributes that we are interested in whereas the continent is not null. 
-- By filtering all available continent will be easier for visualization later on
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM EDA_COVID..CovidDeaths
WHERE continent is not NULL
ORDER BY 1, 2

-- GLOBAL NUMBERS from COVID Deaths
SELECT date, SUM(new_cases) AS totalCases, SUM(new_deaths) AS totalDeaths, 
    (SUM(new_deaths)*1.0/SUM(new_cases))*100 AS death_percentage
FROM EDA_COVID..CovidDeaths
WHERE continent is not NULL
GROUP BY date
ORDER BY 1, 2

-- VISUAL 1: Calculate total cases, total deaths, and death percentage globally
SELECT SUM(new_cases) AS totalCases, SUM(new_deaths) AS totalDeaths, 
    (SUM(new_deaths)*1.0/SUM(new_cases))*100 AS death_percentage
FROM EDA_COVID..CovidDeaths
WHERE continent is not NULL
ORDER BY 1, 2

-- VISUAL 2: Calculate total death per continent
-- European Union is part of Europe so additional filter is needed
SELECT LOCATION, SUM(new_deaths) AS totalDeaths
FROM EDA_COVID..COVIDDEATHS
WHERE continent IS NULL 
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY totalDeaths DESC

-- VISUAL 3: Calculate average infectious percentage
SELECT location, population,date, 
    MAX(total_cases) AS highest_infection_count,  
    MAX((total_cases*1.0/population))*100 AS infectious_percentage
FROM EDA_COVID..COVIDDEATHS
GROUP BY location, population, date
ORDER BY infectious_percentage DESC

--VISUAL 4: Filtering countries with highest infection rate compared to population
SELECT location,population, 
    MAX(total_cases) AS highest_infection_count,
    MAX(total_cases*1.0/population)*100 AS infectious_percentage
FROM EDA_COVID..CovidDeaths
WHERE continent is not NULL
GROUP BY location,population
ORDER BY infectious_percentage DESC

-- Total Cases vs Total Deaths. Converting total_deaths into float.
-- Calculate the likelihood of dying if a person contract COVID in the country
SELECT location, date, total_cases, total_deaths, population, 
    (total_deaths*1.0/total_cases)*100 AS death_percentage
FROM EDA_COVID..CovidDeaths
WHERE continent is not NULL
ORDER BY 1, 2

-- Total Cases vs Population
-- Calculate what percentage of infectious with COVID among the population 
SELECT location, date, total_cases, population, 
    (total_cases*1.0/population)*100 AS infectious_percentage
FROM EDA_COVID..CovidDeaths
WHERE continent is not NULL
ORDER BY 1, 2

-- Calculate the country with the highest death count per population
SELECT location,
    MAX(total_deaths) AS total_death_count
FROM EDA_COVID..CovidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY total_death_count DESC

-- Break things down by continent
-- Showing continents with the highest death count per population
SELECT continent,
    MAX(total_deaths) AS total_death_count
FROM EDA_COVID..CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY total_death_count DESC


-- Analysis on joining tables
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
FROM EDA_COVID..CovidDeaths AS d
JOIN EDA_COVID..CovidVaccinations AS v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.continent is not NULL
    AND v.new_vaccinations is not NULL
ORDER BY 2,3

-- Automatically update total vaccination that ordered by country and date
-- Skipping the day that has no new vaccination on the record
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location,d.date) AS totalVac
FROM EDA_COVID..CovidDeaths AS d
JOIN EDA_COVID..CovidVaccinations AS v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.continent is not NULL
    AND v.new_vaccinations is not NULL
ORDER BY 2,3

-- Using CTE to perform Calculation on Partition By in previous query 
WITH PopVsVac (continent,location,date,population, new_vaccinations, totalVac)
AS
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location,d.date) AS totalVac
FROM EDA_COVID..CovidDeaths AS d
JOIN EDA_COVID..CovidVaccinations AS v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.continent is not NULL
    AND v.new_vaccinations is not NULL
)
SELECT *, (totalVac/population)*100 AS total_vac_per_population
FROM PopVsVac

-- Creating temp table to perform calculation on Partition By in previous query
DROP TABLE IF EXISTS PercentagePopulationVaccinated
CREATE TABLE PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
totalVac numeric
)

INSERT INTO PercentagePopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location,d.date) AS totalVac
FROM EDA_COVID..CovidDeaths AS d
JOIN EDA_COVID..CovidVaccinations AS v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.continent is not NULL
    AND v.new_vaccinations is not NULL

SELECT *, (totalVac/population)*100 AS total_vac_per_population
FROM PercentagePopulationVaccinated

--Creating view to store the data for later visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location,d.date) AS totalVac
FROM EDA_COVID..CovidDeaths AS d
JOIN EDA_COVID..CovidVaccinations AS v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.continent is not NULL
