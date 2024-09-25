-- 1.RETRIEVE THE TOTAL NUMBER OF ORDERS PLACED 


select count(*) as Total_orders  from orders;


-- 2. CALCULATE THE TOTAL REVENUE GENERATED FROM THE PIZZA SALES



SELECT 
    SUM((order_details.quantity * pizzas.price)) AS total_sales
FROM
    order_details
        INNER JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
-- 3. MENTION THE TYPE OF PIZZA THAT IS HIGHEST PRICE 

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY 1 , 2
ORDER BY 2 DESC
LIMIT 1;

-- 4.LIST THE TOP 5 MOST ORDERED PIZZAS ALONG WITH THEIR TYPES 

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        INNER JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- 5.FIND THE TOTAL QUANTITY OF EACH PIZZA CATEGORY ORDERED 

select pizza_types.category,
sum(order_details.quantity) as quantity 
from 
pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc ;

-- 6.DETERMINE THE DISTRIBUTION OF ORDERS BY THE HOUR OF THE DAY 


SELECT HOUR(orders.time) as time_hour , COUNT(ORDER_ID) as orders 
FROM ORDERS 
GROUP BY HOUR(orders.time);

-- 7.JOIN THE RELEVANT TABLES TO FIND THE CATEGORY WISE DISTRIBUTION OF PIZZAS 

SELECT category, count(name) from pizza_types
group by category; 

--  8.GROUP THE ORDERS BY DATE AND CALCULATE THE AVG NUMBER OF PIZZAS ORDERED PER DAY 

select avg(quantity) from 

(
select orders.date , sum(order_details.quantity) as quantity 
from orders join order_details 
on 
orders.order_id = order_details.order_id
group by orders.date ) as order_quantity ;

-- 9.SHOW THE CUMULATIVE SUM OF PIZZA SALES BY DATE 

SELECT s2.date, 
       SUM(revenue) OVER(ORDER BY s2.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_sum
FROM (
    SELECT orders.date,
           SUM(order_details.quantity * pizzas.price) AS revenue
    FROM order_details
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    JOIN orders ON orders.order_id = order_details.order_id
    GROUP BY orders.date
) AS s2;




