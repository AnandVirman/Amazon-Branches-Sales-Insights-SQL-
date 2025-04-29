SELECT * FROM capstoneproject.amazon;

# PRODUCT ANALYSIS
CREATE VIEW ProductLinesTypes AS 
SELECT distinct `Product line` FROM amazon;
#Insights: There are 6 types of product lines which inculdes the products that we use in our daily life and are essential to us 


# Best Productline and the productline need to improve 
SELECT `Product line`, sum(Total)  AS Total_revenue FROM amazon
GROUP BY `Product line` ORDER BY Total_revenue DESC;
#Insights: AS we can see from the data that Food and Beverages are the Best product line as it is giving the highest revenue 
# and Health and beauty is the product line that need to improve as it is giving the lowest revenue as compared to other product lines



# New Columns Defined
ALTER TABLE amazon
ADD COLUMN timeofday VARCHAR(50);

SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET timeofday = CASE 
WHEN extract(hour FROM Time) BETWEEN 5 AND 12 THEN "Morning"
WHEN extract(hour FROM Time) BETWEEN 12 AND 17 THEN "Afternoon"
WHEN extract(hour FROM Time) BETWEEN 17 AND 23 THEN "Evening"
ELSE "Night"
END;

ALTER TABLE amazon
ADD COLUMN dayname VARCHAR(50),
ADD COLUMN monthname VARCHAR(50);

UPDATE amazon
SET dayname = DAYNAME(Date),
    monthname = MONTHNAME(Date);
    


#1: What is the count of distinct cities in the dataset?
SELECT COUNT(distinct(City)) AS number_of_cities FROM amazon;
#Solution: 3 cities
#Insights: Amazon have 3 unique cities in the data

#2: For each branch, what is the corresponding city?
SELECT DISTINCT Branch , City FROM amazon;
#Insights: Amazon have 3 branch for 3 city that shows that for every city amazon have only one branch each


#3: What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT(`product line`)) AS Number_of_Productlines FROM amazon;
#Solution: 6 product lines
#Insights: Amazon have 6 unique Product lines in our data

#4: Which payment method occurs most frequently?
SELECT Payment, COUNT(Payment) AS total_count FROM amazon
GROUP BY Payment ORDER BY total_count DESC LIMIT 1;
#Solution: Ewallet is most frequent payment method
#Insights: Ewallet and cash are both frequent method but Ewallet is ahead of cash payment method
# with one extra payment, which shows customers are paying through both Ewallet and Cash  


#5: Which product line has the highest sales?
SELECT `Product line`, max(Total) AS highest_sale FROM amazon
GROUP BY `Product line` ORDER BY highest_sale DESC LIMIT 1;
#Solution: Fashion accessories
#Insights: This shows that customer can spend a bit more when it comes to Fashion accessories trends,
# by which we get to known that amazon should promote more fashion accessories

#6: How much revenue is generated each month?
SELECT monthname , sum(Total) AS total_revenue FROM amazon
GROUP BY monthname;
#Insights: Out the the 3 months it can be seen that customers are spending more in January compared to other months


#7: In which month did the cost of goods sold reach its peak?
Select monthname , SUM(cogs) AS Total_cost_goods FROM amazon
GROUP BY monthname ORDER BY Total_cost_goods DESC LIMIT 1;
#Solution: January
#Insights: January was the month that in which cost of goods reached highest compared to other months


#8: Which product line generated the highest revenue?
SELECT `Product line`, sum(Total) AS Total_revenue FROM amazon
GROUP BY `Product line` ORDER BY Total_revenue DESC LIMIT 1;
#Solution: Food and beverages
#Insights: Food and beverages is doing goood in term of revenue and 
# customer are spending more in products of this department

#9: In which city was the highest revenue recorded?
SELECT city, sum(Total) AS Total_revenue FROM amazon
GROUP BY city ORDER BY Total_revenue DESC LIMIT 1 ;
#Solution: Naypyitaw
#Insights: Naypyitaw is the leading revenue generator for Amazon, and
# same strategy need to be applied in other city

ALTER TABLE amazon
RENAME COLUMN `Tax 5%` to VAT;

#10: Which product line incurred the highest Value Added Tax?
SELECT `product line`, max(VAT) AS highest_vat_price FROM amazon
GROUP BY `product line` ORDER BY highest_vat_price DESC LIMIT 1; 
#Solution: Fashin accessories
#Insights: Fashin accessories has the highest tax product

#11: For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT `Product line`, sum(Total) AS total_revenue,
CASE
WHEN sum(Total) > (SELECT AVG(total_sale) FROM (SELECT sum(total) as total_sale FROM amazon
                                                 GROUP BY `Product line`) AS Avg_sales)
THEN "Good"
ELSE "Bad"
END AS "Sales_Category"
FROM amazon
GROUP BY `Product line`;   
#Insights: Other than Health and Beauty all other product line has Above average sales
#amazon need to improve its strategy towards Health and Beauty department

#12: Identify the branch that exceeded the average number of products sold.
SELECT Branch, sum(Quantity) AS total_product_sold FROM amazon
GROUP BY Branch
HAVING total_product_sold > (SELECT AVG(Sum_of_products_sold) FROM (SELECT sum(Quantity) AS Sum_of_products_sold FROM amazon
                                                         GROUP BY Branch) AS Avg_product_sold);
#Solution: Branch A with 1859 Total Product Sold has more sold product than Average Product Sold that is 1836.67
#Insights: Branch B and C has to change the strategy as that of Branch A to increase product selling and revenue


#13: Which product line is most frequently associated with each gender?
SELECT Gender , `product line`, total_count FROM 
(SELECT Gender , `Product line`, count(*) AS total_count,
RANK() OVER (PARTITION BY GENDER ORDER BY count(*) DESC ) AS Ranking 
FROM amazon
GROUP BY Gender, `Product line`) AS Ranked_total
WHERE Ranking = 1;
#Solution: For Female it is Fashion accessories, and For Male it is Health and beauty
#Insights: For Female they are more into Fashion items when it comes to purchase and
# Male are more lean towards Health and beauty


#14: Calculate the average rating for each product line.
SELECT `product line`, ROUND(AVG(rating),3) as Avg_Rating FROM amazon
GROUP BY `product line`;
#Insight: On an Average Food and beverages with	7.113 rating is the highest among all rating
# which means customers mostly like our Food and beverages items


#15: Count the sales occurrences for each time of day on every weekday.
SELECT dayname, timeofday, count(*) AS total_count FROM amazon
GROUP BY dayname, timeofday 
ORDER BY FIELD(dayname,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'),
FIELD(timeofday,'Morning','Afternoon','Evening');
#Insight: By looking into this analysis we get to know that a big part of the sales
# done by customer is in Afternoon and 
# that too it is the highest on Wednesday Afternoon with 67 count

#16: Identify the customer type contributing the highest revenue.
SELECT `Customer type`, sum(total) AS Total_revenue FROM amazon
GROUP BY `Customer type` ORDER BY Total_revenue DESC LIMIT 1;
#Solution: Member is contributing high in revenue
#Insights: This show that if amazon convert its Normal customers into Members, they tend to spend more on products


#17: Determine the city with the highest VAT percentage.
SELECT city, (sum(VAT)/sum(`unit price`*quantity))*100 AS total_VAT_percentage FROM amazon
GROUP BY city ORDER BY total_VAT_percentage DESC LIMIT 1;
#Solution: Mandalay has highest VAT Percentage
#Insights: Mandalay is just slight ahead of Naypyitaw with very small margin , its almost negligible

#18: Identify the customer type with the highest VAT payments.
SELECT `Customer type` , Round(sum(VAT),3) AS Total_Vat_Payments FROM amazon
GROUP BY `Customer type`;
#Solution: Member
#Insights: This show that Amazon Member customers are Contributing high VAT compared to Normal customers;

#19: What is the count of distinct customer types in the dataset?
SELECT COUNT(distinct(`Customer type`)) AS distinct_customertype FROM amazon;
#Solution: 2 type
#Insights: Amazon have Member and Normal type of Customers


#20: What is the count of distinct payment methods in the dataset?
SELECT COUNT(distinct(payment)) AS distinct_payment_method FROM amazon;
#Solution: 3 type 
#Insights: Amazon have 3 different payment methods which gives choice to customers for payment

#21: Which customer type occurs most frequently?
SELECT `Customer type` , count(*) AS frequent_customer_type FROM amazon
GROUP BY `Customer type` ORDER BY frequent_customer_type DESC LIMIT 1;
#Solution: Member
#Insights: This shows that Amazon Member customers check in more Frequently as compared to Normal customers;

#22: Identify the customer type with the highest purchase frequency.
SELECT `Customer type`, sum(Quantity) AS Purchase_frequency FROM amazon
GROUP BY `Customer type`;
#Solution: Member
#Insight: This shows that Amazon Member customers are more Frequent in purchasing as compared to Normal customers;


#23: Determine the predominant gender among customers.
SELECT Gender , Count(*) AS total_Count FROM amazon
GROUP BY Gender ORDER  BY total_count DESC LIMIT 1;
#Solution: Female
#Insights: By this analysis we get to know that Female customer are more frequent in amazon compared to Male customers

#24: Examine the distribution of genders within each branch.
SELECT Branch , Gender, count(*) AS Total_count FROM amazon
GROUP BY Branch, Gender ORDER BY Branch, Gender;
#Insights: This analysis shows that Branch A and B has higher Male Customers and  Branch C has higher Female Customers for Amazon

#25: Identify the time of day when customers provide the most ratings.
SELECT timeofday, count(rating) AS Total_Rating_Count FROM amazon 
GROUP BY timeofday ORDER BY Total_Rating_Count DESC LIMIT 1;
#Solution: Afternoon
#Insights: By this analysis it shows that Amazon Afternoon services are liked the most by customers


#26: Determine the time of day with the highest customer ratings for each branch.
SELECT Branch , timeofday , Total_rating_count, Ranking FROM 
(SELECT Branch, timeofday, Count(rating) AS Total_rating_count,
RANK() OVER (PARTITION BY Branch ORDER BY Count(rating) DESC) AS Ranking
FROM amazon
GROUP BY Branch, timeofday) AS Ranked_Rating
WHERE Ranking = 1;
#Insights: Analyzing all over the Branchs it is seen thay Amazon customer tend to give more rating in Afternoon

#27: Identify the day of the week with the highest average ratings.
SELECT dayname , AVG(rating) AS Avg_Rating FROM amazon
GROUP BY dayname ORDER BY Avg_Rating DESC LIMIT 1;
#Solution: Monday
#Insights: According to data the Day on which the amazon customers like their service most is on Monday

#28: Determine the day of the week with the highest average ratings for each branch
SELECT Branch , dayname, Average_Rating, Ranking FROM
(SELECT Branch , dayname, AVG(Rating) AS Average_Rating,
RANK() OVER (PARTITION BY Branch ORDER BY AVG(Rating) DESC) AS Ranking
FROM amazon
GROUP BY Branch, dayname) AS Ranked_Average
WHERE Ranking = 1;
#Insights: According to this analysis it is visible that Friday is best service day for Branch A and C and therefor it is Monday for Branch B customers 


 






                                                         











