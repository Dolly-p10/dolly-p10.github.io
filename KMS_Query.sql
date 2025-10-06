create database KMS_DB


---CASE STUDY 2: CASE SCENARIO 1

---1. Which product category had the highest sales?

select top 1 product_category, sum([Sales]) as [Total sales]
from [dbo].[KMS Sql Case Study]
group by product_category
order by [Total sales] desc

---Answer: The product category with the highest sales is Technology (Total Sales is 5,984,248.182)


---2. What are the Top 3 and Bottom 3 regions in terms of sales?

---Top 3 Regions 

select top 3 region, sum(Sales) as [Total sales]
        from [dbo].[KMS Sql Case Study]
group by Region
order by [Total sales] desc

---Bottom 3 Regions

select top 3 region, sum(Sales) as [Total sales]
        from [dbo].[KMS Sql Case Study]
group by Region
order by [Total sales] asc

---Answer: The Top 3 Regions in terms of Total sales are: West - 3,597,549.28, Ontario - 3,063,212.48 and Prarie - 2,837,304.60
---While the Bottom 3 Regions in terms of Total sales are: Nunavut - 116,376.48, Northwest Territories - 800,847.33, Yukon - 975,867.37


---3. What were the total sales of appliances in Ontario?

select Region, Product_Sub_Category, sum(Sales) as [Total sales]
      from [dbo].[KMS Sql Case Study]
where Region = 'Ontario'
   and Product_Sub_Category = 'Appliances'
group by Region, Product_Sub_Category

---Answer: The total sales of Appliances in Ontario is 202,346.84


---4. Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers.

---Bottom 10 customers by Total Revenue

select top 10 Customer_Name, sum(Sales) as [Total Revenue]
       from [dbo].[KMS Sql Case Study]
group by Customer_Name
order by [Total Revenue] asc

---Bottom 10 customers by Average Sales and behavioral factors

select Customer_Name, avg(Sales) as [Avg Order Value], Discount, Profit, Order_Quantity, Product_Sub_Category, Ship_Mode, Region, Customer_Segment
       from [dbo].[KMS Sql Case Study]
where Customer_Name in (
     select top 10 Customer_Name
     from [dbo].[KMS Sql Case Study]
     group by Customer_Name
     order by sum(Sales) asc )
group by Customer_Name, Discount, Profit, Order_Quantity, Product_Sub_Category, Ship_Mode, Region, Customer_Segment
order by Customer_Name, [Avg Order Value] asc

-----Answer 
---Insights: The bottom 10 customers in terms of total revenue are: Jeremy Farry (85.72), Natalie DeCherney (125.9), Nicole Fjeld (153), Katrina Edelman (180.76), Dorothy Dickinson (198), Christine Kargatis (293.22), Eric Murdock (343.33), Chris McAfee (350.18), Rick Huthwaite (415.82) and Mark Hamilton (450.99).
-----------Most bottom 10 customers placed 1–2 orders, except Eric Murdock who placed 4 orders, engagement is very low overall, but some customers show return potential.
-----------Average Order Value varies significantly, some customers are making large but rare purchases, others small and infrequent.
-----------Discount usage is generally moderate, not excessive.
-----------Total units ordered ranges from 21 to 82, but Eric Murdock has 82 units across 4 orders (high quantity, frequent, but unprofitable) and Nicole Fjeld has 44 units in just 2 orders (good volume).
-----------5 out of the bottom 10 customers generated losses.
-----------Purchases are spread across narrow ranges (1–3 sub-categories per customer)
-----------Most bottom 10 customers prefer cost-effective Regular Air shipping.

------Advise for KMS Management: The bottom 10 customers show varied behaviors, some buy often but remain unprofitable, while others make one large purchase and disappear. Most are lightly engaged, use moderate discounts, and buy from a small set of categories. To grow their revenue, KMS should:
---*Retain multi-order customers with personalized email offers.
---*Bundle and upsell related products to increase basket size.
---*Target high-quantity customers with volume incentives.
---*Avoid aggressively pursuing loss-making customers unless operational costs can be controlled.
---*Use light-touch incentives like shipping thresholds and loyalty perks, not just discounts.


---5. KMS incurred the most shipping cost using which shipping method?

select Ship_Mode, 
       sum([Shipping_Cost]) as [Total shipping_cost]
from [dbo].[KMS Sql Case Study]
group by Ship_Mode
order by [Total shipping_cost] desc

---Answer: KMS incurred the most shipping cost using the Delivery Truck method, with a total cost of 51,971.94


---CASE STUDY 2: CASE SCENARIO 2

---6. Who are the most valuable customers, and what products or services do they typically purchase?

---Most valuable customers by Revenue

select top 10 Customer_Name, sum(Sales) as [Total Revenue]
       from [dbo].[KMS Sql Case Study]
group by Customer_Name
order by [Total Revenue] desc

---Product Category preferences of most valuable customers

select Customer_Name, Customer_Segment, Product_Category, count(*) as [Purchase Count]
     from [dbo].[KMS Sql Case Study]
where Customer_Name in (
     select top 10 Customer_Name
     from [dbo].[KMS Sql Case Study]
     group by Customer_Name
     order by sum(Sales) desc )
group by Customer_Name, Customer_Segment, Product_Category
order by Customer_Name, [Purchase Count] desc

---Answer: The most valuable customers in terms of total revenue are: Emily Phan, Deborah Brumfield, Roy Skaria, Sylvia Foulston, Grant Carroll, Alejandro Grove, Darren Budd, Julia Barnett, John Lucas and Liz MacKendrick    
---------: Products or services typically purchased by the most valuable customers are Office Supplies and Technology. Some (like Darren Budd) show strong interest in Furniture.


---7. Which small business customer had the highest sales?

select top 1 Customer_Name, Customer_Segment, sum(Sales) as [Total Sales]
from [dbo].[KMS Sql Case Study]
where Customer_Segment = 'Small Business'
group by Customer_Name, Customer_Segment
order by [Total Sales] desc

---Answer: The Small Business customer with the highest total sales is Dennis Kane (Total Sales of 75,967.59)


---8. Which Corporate Customer placed the most number of orders in 2009 – 2012?

select top 1 Customer_Name, Customer_Segment, count(distinct Order_ID) as [Order Count]
     from [dbo].[KMS Sql Case Study]
where Customer_Segment = 'Corporate'
  and Order_Date between '2009-01-01' and '2012-12-31'
group by Customer_Name, Customer_Segment
order by [Order Count] desc

---Answer: The Corporate customer who placed the most number of orders in 2009 – 2012 is Adam Hart (Order Count is 18).


---9. Which consumer customer was the most profitable one?

select top 1 Customer_Name, Customer_Segment, sum(Profit) as [Total Profit]
     from [dbo].[KMS Sql Case Study]
where Customer_Segment = 'Consumer'
group by Customer_Name, Customer_Segment
order by [Total Profit] desc

---Answer: The most profitable Consumer customer is Emily Phan (Total Profit is 34,005.44)


---10. Which customer returned items, and what segment do they belong to?

select distinct k.Customer_Name, k.Customer_Segment
from [dbo].[KMS Sql Case Study] as k
join [dbo].[Order_Status] as s
   on k.Order_ID = s.Order_ID
where s.Status = 'Returned'

---Answer: A total of 419 unique customers returned items across multiple segments, Corporate customers accounted for the largest share of returns (167), Followed by Home Office (90), Small Business (86) and Consumer (76).


---11. If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but the most expensive one, do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer

select Order_Priority, Ship_Mode, count(distinct Order_ID) as [Total Orders], sum(Shipping_Cost) as [Total Shipping Cost]
from [dbo].[KMS Sql Case Study]
group by Order_Priority, Ship_Mode
order by Order_Priority, Ship_Mode

---Answer: Only 13% of Critical orders (190 out of 1,288) used Express Air, majority went via Regular Air and Delivery Truck.
---Still 180 Low-priority orders used Express Air, that’s nearly the same as Critical (190)
---Shipping cost differences between priorities are not significant, despite different urgency levels (Critical total Express Air cost is 1,742.10 while Low total Express Air cost is 1,551.63)
---The company is not consistently using Express Air for high-priority orders, they're also wasting money using Express Air for low and unspecified priority orders
