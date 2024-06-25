CREATE DATABASE olist_store;

SELECT * FROM order_reviews;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM sellers;
SELECT * FROM product_category_name_translation;
SELECT * FROM order_items;
SELECT * FROM order_payments;
SELECT * FROM customers;
SELECT * FROM geolocation;



#Total customers, total orders, total products, total payments
SELECT count(*) FROM customers;
SELECT count(*) FROM orders;
SELECT count(*) FROM products;
SELECT count(*) FROM order_payments;



#KPI1
SELECT * FROM orders;
SELECT * FROM order_payments; 

SELECT Day_type, total_payments, 
sum(total_payments) Over() as total, 
concat(round((total_payments*100/sum(total_payments) OVER())),"%") as payment_percentage 
FROM
	(SELECT IF(dayname(o.order_purchase_timestamp) IN("Saturday", "Sunday"), "Weekend", "Weekday") as Day_type, 
    round(sum(payment_value)) as total_payments
	FROM orders o LEFT JOIN order_payments od ON o.order_id = od.order_id
	GROUP BY Day_type) as a;
    
    

#KPI2
SELECT * FROM orders; #no. of orders #order_id
SELECT * FROM order_reviews; #score 5 #order_id
SELECT * FROM order_payments; #payment_type #order_id

SELECT r.review_score, p.payment_type, count(o.order_id) as number_of_orders
FROM orders o LEFT JOIN order_reviews r ON o.order_id = r.order_id
LEFT JOIN order_payments p ON o.order_id = p.order_id
WHERE r.review_score = 5 AND p.payment_type = "credit_card"
GROUP BY r.review_score, p.payment_type;



#KPI3
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM order_items;

SELECT p.product_category_name, round(avg(o.order_delivered_customer_date)) as Avg_days
FROM orders o LEFT JOIN order_items i ON o.order_id = i.order_id LEFT JOIN 
products p ON p.product_id = i.product_id
WHERE product_category_name = "pet_shop"
GROUP BY p.product_category_name;



#KPI4
SELECT * FROM customers; 
SELECT * FROM order_payments; 
SELECT * FROM order_items;
SELECT * FROM orders; 

SELECT c.customer_city, round(avg(i.price)) as avg_price, round(avg(p.payment_value)) as avg_payement_value
FROM order_payments p LEFT JOIN order_items i ON p.order_id = i.order_id
LEFT JOIN orders o ON o.order_id = i.order_id 
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_city = "sao paulo"
GROUP BY c.customer_city;



#KPI5
SELECT * FROM orders;
SELECT * FROM order_reviews;

SELECT r.review_score, 
round(avg(datediff(o.order_delivered_customer_date,o.order_purchase_timestamp)),0) as avg_shipping_days
FROM orders o LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE r.review_score IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;