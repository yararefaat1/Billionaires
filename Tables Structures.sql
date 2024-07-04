USE [billionaires]
GO

/****** Object:  Table [dbo].[personal_info]    Script Date: 6/19/2024 12:05:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[personal_info](
	[person_id] [smallint] NOT NULL,
	[personName] [nvarchar](50) NOT NULL,
	[gender] [nvarchar](50) NOT NULL,
	[birthDate] [datetime2](7) NOT NULL,
	[selfMade] [bit] NOT NULL,
	[country] [nvarchar](50) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[finalWorth] [int] NOT NULL,
	[source] [nvarchar](50) NOT NULL,
	[industries] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_personal_info] PRIMARY KEY CLUSTERED 
(
	[person_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


alter table personal_info
add location_id tinyint

update p
set p.location_id= c.location_id
from personal_info p join country_from1 c
on p.country = c.country AND
P.city = c.city

alter table personal_info
drop column city, country

select * from personal_info where location_id is null

ALTER TABLE personal_info
ADD CONSTRAINT FK_personal_info_location_id
FOREIGN KEY (location_id) REFERENCES country_from1(location_id);

alter table industry_city
add location_id tinyint

update ic
set ic.location_id = c.location_id
from industry_city ic join country_from1 c
on ic.country = c.country AND
ic.city = c.city

select * from industry_city where location_id is null

ALTER TABLE industry_city
ADD CONSTRAINT FK_industry_city_location_id
FOREIGN KEY (location_id) REFERENCES country_from1(location_id);

alter table industry_city
drop column city,country;

select * from industry_city

alter table personal_info
drop column industries,source 

