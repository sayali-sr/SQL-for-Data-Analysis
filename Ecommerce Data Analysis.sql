-- Create table name ecommerce_data
CREATE TABLE ecommerce_data (
    item_fat_content TEXT,
    item_identifier TEXT,
    item_type TEXT,
    outlet_establishment_year INTEGER,
    outlet_identifier TEXT,
    outlet_location_type TEXT,
    outlet_size TEXT,
    outlet_type TEXT,
    item_visibility NUMERIC(10,4),
    item_weight NUMERIC(10,2),
    sales NUMERIC(12,2),
    rating NUMERIC(3,1)
);


-- Check table
select * from ecommerce_data


-- Treat Null values by updating them with average values 
UPDATE ecommerce_data ed
SET item_weight = sub.avg_weight
FROM (
    SELECT item_type, AVG(item_weight) AS avg_weight
    FROM ecommerce_data
    WHERE item_weight IS NOT NULL
    GROUP BY item_type
) sub
WHERE ed.item_weight IS NULL
  AND ed.item_type = sub.item_type;


-- Check table
select * from ecommerce_data


--1. Find top 10 selling item types by total sales 
SELECT item_type, SUM(sales) AS total_sales
FROM ecommerce_data
GROUP BY item_type
ORDER BY total_sales DESC
LIMIT 10;


--2. Check Average of total sales
SELECT AVG(sales) AS average_sales
FROM ecommerce_data;


--2. Show outlet types with average sales above 140.
SELECT outlet_type, AVG(sales) AS avg_sales
FROM ecommerce_data
GROUP BY outlet_type 
HAVING AVG(sales) > 140;


--3. Create table name customer_feedback
CREATE TABLE customer_feedback (
    item_identifier TEXT,
    customer_id TEXT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback TEXT
);

-- Insert data in it
INSERT INTO customer_feedback VALUES
('FDX32', 'CUST101', 5, 'Excellent product!'),
('FDN33', 'CUST102', 4, 'Very fresh and useful.'),
('NCN55', 'CUST103', 2, 'Not satisfied with the packaging.'),
('FDX32', 'CUST104', 3, 'Decent quality but pricey.'),
('DRY12', 'CUST105', 5, 'Loved the taste!'),
('XYZ00', 'CUST106', 1, 'Never received the item.');


-- 3. Show feedback for items that exist in the dataset only
SELECT e.item_identifier, 
       e.item_type,
	   e.sales,
	   f.rating,
	   f.feedback
FROM ecommerce_data as e
INNER JOIN customer_feedback as f
ON e.item_identifier=f.item_identifier


--4. Show all items along with any available customer feedback
SELECT e.item_identifier, 
       e.item_type,
	   e.sales,
	   f.rating,
	   f.feedback
FROM ecommerce_data as e
LEFT JOIN customer_feedback as f
ON e.item_identifier=f.item_identifier


--5. Show all customer feedback, including those for items not in the dataset
SELECT 
    f.item_identifier,
    e.item_type,
    f.customer_id,
    f.rating,
    f.feedback
FROM ecommerce_data as e
RIGHT JOIN customer_feedback as f
ON e.item_identifier = f.item_identifier;


--6. Find items with sales higher than average
SELECT item_identifier, item_type, sales
FROM ecommerce_data
WHERE sales > (SELECT 
			   AVG(sales)
			   FROM ecommerce_data)
			   
			   
--7. Show total sales, average weight, and total items sold
SELECT 
    SUM(sales) AS total_sales,
    AVG(item_weight) AS average_weight,
    COUNT(*) AS total_transactions
FROM ecommerce_data;


--8. Create a view of top-selling categories
CREATE VIEW top_categoriess AS
SELECT item_type, SUM(sales) AS total_sales
FROM ecommerce_data
GROUP BY item_type
ORDER BY total_sales DESC
LIMIT 10;

SELECT * FROM top_categoriess;


--9. Create Index on frequently filtered columns
CREATE INDEX idx_item_identifier ON ecommerce_data(item_identifier);
CREATE INDEX idx_outlet_identifier ON ecommerce_data(outlet_identifier);

SELECT item_identifier, sales FROM ecommerce_data;


--10. Show items whose sales are above the average sales of their own outlet type
SELECT item_identifier, outlet_type, sales
FROM ecommerce_data AS e
WHERE sales > (
    SELECT AVG(sales)
    FROM ecommerce_data
    WHERE outlet_type = e.outlet_type
);





