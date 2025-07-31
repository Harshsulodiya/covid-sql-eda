
-- Create the COVID data table
DROP TABLE IF EXISTS covid_data;

CREATE TABLE covid_data (
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date DATE,
    total_cases INTEGER,
    new_cases INTEGER,
    total_deaths INTEGER,
    new_deaths INTEGER,
    total_vaccinations INTEGER,
    people_vaccinated INTEGER,
    people_fully_vaccinated INTEGER,
    population INTEGER
);

-- Sample Queries

-- 1. Total Cases vs Total Deaths per Country
SELECT 
  location,
  MAX(total_cases) AS total_cases,
  MAX(total_deaths) AS total_deaths,
  ROUND((MAX(total_deaths)*100.0)/MAX(total_cases), 2) AS death_rate_percent
FROM 
  covid_data
WHERE 
  continent IS NOT NULL
GROUP BY 
  location
ORDER BY 
  death_rate_percent DESC;

-- 2. Top 10 Countries by Total Vaccinations
SELECT 
  location,
  MAX(people_vaccinated) AS total_vaccinated
FROM 
  covid_data
WHERE 
  continent IS NOT NULL
GROUP BY 
  location
ORDER BY 
  total_vaccinated DESC
LIMIT 10;

-- 3. Daily New Cases Trend (India)
SELECT 
  date,
  new_cases
FROM 
  covid_data
WHERE 
  location = 'India'
ORDER BY 
  date;

-- 4. Rolling 7-Day Average of New Cases (USA)
SELECT 
  date,
  new_cases,
  ROUND(AVG(new_cases) OVER (
    ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ), 2) AS rolling_avg_7d
FROM 
  covid_data
WHERE 
  location = 'United States'
ORDER BY 
  date;

-- 5. Percentage of Population Fully Vaccinated by Country
SELECT 
  location,
  MAX(people_fully_vaccinated) AS fully_vaccinated,
  MAX(population) AS population,
  ROUND((MAX(people_fully_vaccinated)*100.0)/MAX(population), 2) AS percent_fully_vaccinated
FROM 
  covid_data
WHERE 
  continent IS NOT NULL
GROUP BY 
  location
ORDER BY 
  percent_fully_vaccinated DESC;
