# Sales and Budget Management Project
[Power BI Dashboard](https://app.powerbi.com/view?r=eyJrIjoiYjY3ZmU4YmItMTgyNi00MjFmLWE3ODAtYWFhMTk1NGRjMWIwIiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9&pageName=ReportSection5d5ab9e44106cc8b7400)\
### 1, Identify The Business Request:

As a Data Analyst, my client/sales managers requested an executive sales report for his company. When receiving a task from customer, my first step is highlighting all the key points my customer want to be include in the project outcome.\
![request](https://user-images.githubusercontent.com/107152014/224838568-38b42840-8da9-441c-a495-b102e1113b04.png)


Next, I followed the user stories to identify main criterias to ensure fully deliver the business request.\
<img width="904" alt="sale_budget" src="https://user-images.githubusercontent.com/107152014/224837558-4ecfbbd8-4f9f-453b-b98d-48923f4014e2.png">

### 2, Data Cleaning and Transformation (SQL):

Step 1: Update the latest data on SSMS using [this](https://github.com/techtalkcorner/SampleDemoFiles/blob/master/Database/AdventureWorks/Update_AdventureWorksDW_Data.sql).\
Step 2: Identify the importance columns and any unusual records.\
Step 3: Perform necessary data cleaning using SQL.\
Step 4: Save the SQL code and export to csv/Excel file.

[DIM_Customer.sql](https://github.com/nguyendmnhu/Kat-s-Projects/blob/main/Sales%20and%20Budget%20Management/SQL%20Code/DIM_Customer.sql)\
[DIM_Date.sql](https://github.com/nguyendmnhu/Kat-s-Projects/blob/main/Sales%20and%20Budget%20Management/SQL%20Code/DIM_Date.sql)\
[DIM_Product.sql](https://github.com/nguyendmnhu/Kat-s-Projects/blob/main/Sales%20and%20Budget%20Management/SQL%20Code/DIM_Product.sql)\
[DIM_Sales.sql](https://github.com/nguyendmnhu/Kat-s-Projects/blob/main/Sales%20and%20Budget%20Management/SQL%20Code/DIM_Sales.sql)

### 3, Data validation and model (Power Query):

Step 1: Load the data and transform using Power Query.\
Step 2: Apply all changes and build data model.\
![model](https://user-images.githubusercontent.com/107152014/224838107-eeea97b8-d65b-4dc3-a7b7-d1d4a48e9980.jpeg)


### 4, Create interactive Sales Management Dashboard (Power BI):

Step 1: Create Sales Overview dashboard capture all important informations along with Slicers such as KPI, Top 10 Customers, Top 10 Products,\
Sales Trend Overtime, Sales by Customer Location.\
![sales_overview](https://user-images.githubusercontent.com/107152014/224838671-c2dc45b9-e748-4230-8640-d63228eb7bc1.jpg)

Step 2: Create Customer Details with Top N Slicer helps the sale manager/ business stakeholder easy to filter the data based on their needs.\
![customer_details](https://user-images.githubusercontent.com/107152014/224838713-2e13e7cf-33ff-4dfd-a6dd-103e8c535704.jpg)

Step 3: Create Product Details with What if parameter to filter the top products impact the company's total sales.\
![product_details](https://user-images.githubusercontent.com/107152014/224838756-a3552556-48b2-4f71-9a62-bb0b646aeefc.jpg)




