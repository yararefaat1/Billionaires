---- RANK TOP 5 INDIVIDUALS AND THIER RELATED INDUSTRY
select top(5) personName,industries,
row_number() over(partition by finalworth order by finalworth desc) as ranking
from personal_info p join industry_city i on p.location_id = i.location_id;

---- Rank individuals by net worth within each country:
select personName, country,
rank()over(partition by country order by finalworth desc) as rankedwealth
from personal_info p join country_from1 c on p.location_id = c.location_id;


---- number of selfmade wealth persons using scalar Function:

CREATE FUNCTION selfmadewealth
    (@selfmade bit)
RETURNS int
AS
BEGIN
    DECLARE @countresult int;
    SELECT @countresult= COUNT(personName) from personal_info
	where  @selfmade= selfMade
    RETURN @countresult;
END;

SELECT dbo.selfmadewealth(1) AS SelfMadeCount;
SELECT dbo.selfmadewealth(0) AS SelfMadeCount;


----- the total money earnt per each source of industry
 
create function trendyindustry( @sourcename nvarchar(50))
returns table
as 
return
(
select industries,sum(finalworth)as money_earnt FRom industry_city c inner join personal_info p
on c.location_id = p.location_id
where @sourcename= source
group by industries
)

Select * From dbo.trendyindustry('Zara')
Select * From dbo.trendyindustry('AMAZON')
Select * From dbo.trendyindustry('Microsoft')


select source from industry_city

---- VIEW FOR THE FINALWORTH CORRESPONDING TO THE TAX REVENUE
 alter VIEW netmoney as 
select personname , cast(tax_revenue as decimal(10,2)) as tax_revenue, finalworth
from personal_info p inner join country_from1 c on p.location_id = c.location_id;

select * from netmoney

---- USING CASE TO CATEGORIZE BILLIONAIRES
SELECT 
    personName,
    finalWorth,
    CASE 
        WHEN finalWorth >= 1000000 THEN 'Millionaire'
        WHEN finalWorth >= 100000 AND finalWorth < 1000000 THEN 'Wealthy'
        ELSE 'Average'
    END AS WealthStatus
FROM 
    personal_info;

---- wealth rankning in correspond to the economic impact on countries

WITH WealthRanking AS (
    SELECT
        p.personName, 
        p.finalWorth, 
        p.location_id,
        c.industries,
        row_number() OVER (PARTITION BY c.industries ORDER BY p.finalWorth DESC) AS WealthRank
    FROM 
        personal_info p 
    INNER JOIN 
        industry_city c ON p.location_id = c.location_id
),
EconomicImpact AS (
    SELECT
        c.location_id,
        c.country,
        AVG(c.gdp_country) AS AvgGDP,
        SUM(c.tax_revenue) AS TotalTaxRevenue
    FROM 
        country_from1 c
    GROUP BY 
        c.location_id, c.country
)
SELECT
    ei.country,
    ei.AvgGDP,
    ei.TotalTaxRevenue,
    wr.personName,
    wr.industries,
    wr.WealthRank
FROM
    EconomicImpact ei
LEFT JOIN
    WealthRanking wr ON ei.location_id = wr.location_id
WHERE
    wr.WealthRank <= 5
ORDER BY
    ei.AvgGDP DESC, 
    wr.WealthRank;


