/****** Script cleaning DIM_Customer from SSMS  ******/
SELECT c.customerkey AS CustomerKey
      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
      ,c.firstname AS [FirstName]
      --,[MiddleName]
      ,c.lastname AS [LastName]
	  , c.firstname + ' ' + lastname as [Full Name] -- Combined Customer first and last name
      --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
      , CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender -- Converted to full values for Gender
      --,[EmailAddress]
      --,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      --,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
      --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
      ,c.datefirstpurchase AS DateFirstPurchase
      --,[CommuteDistance]
	  ,g.city AS [Customer City]
  FROM 
	dbo.DimCustomer AS c
	LEFT JOIN dbo.DimGeography AS g on g.GeographyKey = c.GeographyKey --Joined in Customer City from Geography Table
  ORDER BY
	CustomerKey ASC --Ordered the dataset by CustomerKey