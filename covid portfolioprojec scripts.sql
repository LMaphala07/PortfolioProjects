SELECT*
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
order by 3,4

SELECT*
FROM PortfolioProject..CovidVaccinations
order by 3,4

--Select the Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths
--shows the likelihood of dying if you contract covid in my country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%South Africa%'
order by 1,2

--Looking at the total cases vs population
--shows what percenatge of population got covid

SELECT Location, date, total_cases, population, (total_deaths/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location like '%South Africa%'
order by 1,2

--Looking at the countries with highest infection rate compared to populations

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%South Africa%'
Group by location,population
order by PercentPopulationInfected desc

--showing countries with the highest death count per population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%South Africa%'
WHERE continent is null
Group by location
order by TotalDeathsCount desc

--Breaking things down by continent

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%South Africa%'
WHERE continent is not null
Group by continent
order by TotalDeathsCount desc

--GLOBAL NUMBERS

SELECT date, sum(new_cases)as total_cases, sum(cast(new_deaths as int)), sum(cast(new_deaths as int)) as total_deaths, sum(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%South Africa%'
WHERE continent is not null
Group by date
order by 1,2


--Population death percenatge of the entire world

SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%South Africa%'
WHERE continent is not null
--Group by date
order by 1,2


--loooking at total population vs vaccination

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2,3