# Sales and Budget Management Project
### 1, Identify The Business Request:

As a Data Analyst, my client/sales managers requested an executive sales report for his company. When receiving a task from customer, my first step is highlighting all the key points my customer want to be include in the project outcome.\
![request](/images/request.png)

Next, I followed the user stories to identify main criterias to ensure fully deliver the business request.\
![sale_budget](/images/sale_budget.png)

### 2, Data Cleaning and Transformation (SQL):

Step 1: Update the latest data on SSMS using [this](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa2VaOGZrVUlEcFRwY2ZaMWJ1OG1XUGVMNkZ0QXxBQ3Jtc0tuQmNlbHZHNmEwUVpxN3RaZXlqbzl0WXRKT0liTllRM3BVQkdYbjBOdll1cXFrc3BHRk9GaHQ3c1BFaUdsb2lwcTl1ZW5uM1NWR1JXYlczVkdzalRIcHVXY200cHQ2T3ZzOWRaQ2ZYS0FuNkpyOTlQMA&q=https%3A%2F%2Fgithub.com%2Ftechtalkcorner%2FSampleDemoFiles%2Fblob%2Fmaster%2FDatabase%2FAdventureWorks%2FUpdate_AdventureWorksDW_Data.sql&v=z7o5Wju-PZg).\
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
![model](/images/model.jpeg)

### 4, Create interactive Sales Management Dashboard (Power BI):

Step 1: Create Sales Overview dashboard capture all important informations along with Slicers such as KPI, Top 10 Customers, Top 10 Products, Sales Trend Overtime, Sales by Customer Location.\
Step 2: Create Customer Details with Top N Slicer helps the sale manager/ business stakeholder easy to filter the data based on their needs.\
Step 3: Create Product Details with What if parameter to filter the top products impact the company's total sales.

[Power BI Dashboard](https://github.com/nguyendmnhu/Kat-s-Projects/blob/main/Sales%20and%20Budget%20Management/Sale%20Report.pbix)\
NOTE: I am currently using my school email so only SJSU students can publishly interact with my dashboard on Power BI online. Please make a download to your computer to have a deeper look at my dashboard.
