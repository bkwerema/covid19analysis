
--Analysing Total Cases Vs Deaths
SELECT location , date, total_cases , new_cases , total_deaths,
round((CAST(total_deaths AS float) / CAST(total_cases AS float) ) * 100, 2) as death_percentage
FROM DBO.CovidDeaths
WHERE continent is not null
ORDER BY 1,  2 ;

--Total Deaths and Cases
SELECT location , date, total_cases , new_cases , total_deaths,
round((CAST(total_deaths AS float) / CAST(total_cases AS float) ) * 100, 2) as death_percentage
FROM DBO.CovidDeaths
WHERE continent is not null
ORDER BY 1,  2 ;


--Analysing Total Cases Vs Deaths
SELECT SUM(CAST(total_cases AS FLOAT)) as Total_Cases, SUM(CAST(total_deaths AS float)) AS Total_Deaths,
round((SUM(CAST(total_deaths AS float)) / SUM(CAST(total_cases AS float) )) * 100, 2) as death_percentage
FROM DBO.CovidDeaths
ORDER BY 1,  2 ;

--Total Cases Vs Population
SELECT location , date , total_cases , population,
round((CAST(total_cases AS float) / CAST(population AS float) ) * 100, 2) as infected_percentage
FROM DBO.CovidDeaths
WHERE continent is not null
--WHERE location like '%Canada%'
ORDER BY 1 ,  2 ; 

--Countries With Highest Infection Rate
SELECT location ,  max(total_cases) as Highest_Infection_Count,
round((CAST(max(total_cases) AS float) / CAST(population AS float) ) * 100, 2) as highest_infected_percentage
FROM DBO.CovidDeaths
WHERE continent is not null
GROUP BY location , population
ORDER BY highest_infected_percentage DESC;

--Total_Death_Count
SELECT location , MAX(total_deaths) as Total_Death_Count
FROM DBO.CovidDeaths
WHERE continent is not null
GROUP BY location , population
ORDER BY Total_Death_Count DESC;

--Total Death Count By Continent
SELECT continent , MAX(total_deaths) as Total_Death_Count
FROM DBO.CovidDeaths
--WHERE continent is null
GROUP BY continent
ORDER BY Total_Death_Count DESC;

-- Total New Cases in the world per day
SELECT  sum(new_cases) as Total_New_Case_Count,
sum(new_deaths) as Total_Death_Count,
 (sum(new_deaths) / sum(new_cases) ) * 100 as Death_Percentage
FROM DBO.CovidDeaths
--GROUP BY date
ORDER BY Death_Percentage DESC;

-- Vaccinations vs Total Population
SELECT cv.location as Location , cv.date ,
CAST(sum(cv.new_vaccinations) AS decimal )  as Total_Vaccinations ,
cd.population as Population
FROM dbo.CovidVaccinations as cv
JOIN dbo.CovidDeaths as cd
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent is not null
GROUP BY cv.location , cv.date , cd.population
ORDER BY Total_Vaccinations DESC 

-- Vaccination_Percentage vs Total Population By Month
SELECT cv.location as Location , year(cv.date) as Year , month(cv.date) as Month ,
CAST(sum(cv.new_vaccinations) AS float )  as Total_Vaccinations ,
cd.population as Population,
ROUND((CAST(sum(cv.new_vaccinations) AS float ) / cd.population) * 100, 2) as Vaccination_Percentage
FROM dbo.CovidVaccinations as cv
JOIN dbo.CovidDeaths as cd
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent is not null
GROUP BY cv.location , year(cv.date) , month(cv.date) , cd.population
ORDER BY Vaccination_Percentage DESC 

--Partition_By
-- Vaccination_Percentage vs Total Population
SELECT 
cv.continent as Continent , 
cv.location as Location , 
SUM(CAST(cv.new_vaccinations AS FLOAT)) over (partition by cv.location ORDER BY cv.location) as Total_Vaccinations ,
cd.population
FROM dbo.CovidVaccinations as cv
JOIN dbo.CovidDeaths as cd
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent is not null
ORDER BY Total_Vaccinations DESC 

-- Overall_Vaccination_Percentage vs Total Population 
SELECT cv.location as Location , 
CAST(sum(cv.new_vaccinations) AS float )  as Total_Vaccinations ,
cd.population as Population,
ROUND((CAST(sum(cv.new_vaccinations) AS float ) / cd.population) * 100, 2) as Vaccination_Percentage
FROM dbo.CovidVaccinations as cv
JOIN dbo.CovidDeaths as cd
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent is not null
GROUP BY cv.location , cd.population
ORDER BY Vaccination_Percentage DESC 

-- CREATE VIEW 
CREATE VIEW Percentage_Of_People_Vaccinated as 
SELECT cv.location as Location , 
CAST(sum(cv.new_vaccinations) AS float )  as Total_Vaccinations ,
cd.population as Population,
ROUND((CAST(sum(cv.new_vaccinations) AS float ) / cd.population) * 100, 2) as Vaccination_Percentage
FROM dbo.CovidVaccinations as cv
JOIN dbo.CovidDeaths as cd
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent is not null
GROUP BY cv.location , cd.population

select * from dbo.Percentage_Of_People_Vaccinated
where Vaccination_Percentage <= 100
order by Vaccination_Percentage desc
