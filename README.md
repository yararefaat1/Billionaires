# Billionaires
Database Overview **Name**: BillionairesDB **Size**: 500MB
tables:
  **pesonal_info**
    Columns:
     person_id as Primary key
     personName
     gender
     birthDate
     selfMade
     finalWorth
     location_id as foreign key 
**Country_from**
  columns:
  location_id as primary key
  country
  city
  cpi_country
  gdp_country
  life_expectancy
  tax_revenue
  total_tax_rate
  population
**industry_city**
  columns:
  source
  industries
  location_id

**  Excel File**
- `Original Billionaires Statistics Dataset.xlsx` - Contains the raw sales data.



