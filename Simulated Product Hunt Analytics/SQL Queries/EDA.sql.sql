#PRODUCT PERFORMANCE BY CATEGORY
SELECT 
	c.category_name,
    COUNT(p.product_id) AS total_products,
    ROUND(AVG(p.total_upvotes),2) AS avg_upvotes,
    ROUND(AVG(p.total_comments),2) AS avg_comments,
    ROUND(AVG(p.total_followers),2) AS avg_followers,
    ROUND(AVG(p.total_views),2) AS avg_views,
    ROUND(AVG(p.success_score),2) AS avg_success_score
FROM products p
JOIN
categories c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY avg_success_score DESC;

#AI SUBCATEGORY PERFORMANCE
SELECT 
		ais.subcategory_name,
        COUNT(p.product_id) AS total_product,
        ROUND(AVG(p.total_upvotes),2) AS avg_upvotes,
		ROUND(AVG(p.total_comments),2) AS avg_comments,
		ROUND(AVG(p.total_followers),2) AS avg_followers,
		ROUND(AVG(p.total_views),2) AS avg_views,
		ROUND(AVG(p.success_score),2) AS avg_success_score,
        COUNT(CASE WHEN p.success_tier = 'Viral' THEN 1 END) AS viral_count
FROM
products p
JOIN
ai_product_mapping apm
ON p.product_id = apm.product_id
JOIN 
ai_subcategories ais
ON apm.subcategory_id = ais.subcategory_id
GROUP BY ais.subcategory_name
ORDER BY avg_success_score DESC;

#LAUNCH DAY PERFORMANCE
SELECT 
	launch_day,
    COUNT(product_id) AS total_products,
    ROUND(AVG(total_upvotes),2) AS avg_upvotes,
	ROUND(AVG(success_score),2) AS avg_success_score,
	COUNT(CASE WHEN success_tier = 'Viral' THEN 1 END) AS viral_products,
    CONCAT(ROUND(COUNT(CASE WHEN success_tier = 'Viral' THEN 1 END)/COUNT(*) * 100), "%") AS viral_percentage
FROM products p
GROUP BY launch_day
ORDER BY avg_success_score DESC;

#LAUNCH HOUR PERFORMANCE
SELECT 
    launch_hour,
    COUNT(product_id) AS product_count,
    ROUND(AVG(total_upvotes), 2) AS avg_upvotes,
    ROUND(AVG(success_score), 2) AS avg_success_score,
    COUNT(CASE WHEN success_tier = 'Viral' THEN 1 END) AS viral_products_count
FROM 
    products
GROUP BY 
    launch_hour
ORDER BY 
    avg_success_score DESC;

#ENGAGEMENT BY HOUR FROM LAUNCH
SELECT 
	hour_from_launch,
    ROUND(AVG(upvotes),2) AS avg_hourly_upvote,
    ROUND(AVG(comments),2) AS avg_comments,
    ROUND(AVG(new_followers),2) AS avg_new_followers,
    ROUND(AVG(views),2) AS avg_hourly_views
FROM hourly_engagement
GROUP BY hour_from_launch
ORDER BY hour_from_launch; 

#IMPACT OF PRODUCT FEATURE ON SUCCESS
SELECT 
	COUNT(product_id) AS total_products,
    has_video,
    ROUND(AVG(screenshot_count),2) AS avg_screenshot_count,
    ROUND(AVG(total_upvotes),2) AS avg_upvotes,
	ROUND(AVG(success_score),2) AS avg_success_score,
	COUNT(CASE WHEN success_tier = 'Viral' THEN 1 END) AS viral_products_count
FROM products 
GROUP BY has_video
ORDER BY avg_success_score DESC;

#FEATURED STATUS IMPACT
SELECT 
	COUNT(product_id) AS total_products,
    featured,
    ROUND(AVG(total_upvotes),2) AS avg_upvotes,
	ROUND(AVG(success_score),2) AS avg_success_score,
	COUNT(CASE WHEN success_tier = 'Viral' THEN 1 END) AS viral_products_count
FROM products
GROUP BY featured
ORDER BY avg_success_score DESC;

#PRICING MODEL IMPACT
SELECT 
	COUNT(product_id) AS total_products,
    pricing_model,
    ROUND(AVG(total_upvotes),2) AS avg_upvotes,
	ROUND(AVG(success_score),2) AS avg_success_score,
	COUNT(CASE WHEN success_tier = 'Viral' THEN 1 END) AS viral_products_count,
    CONCAT(ROUND(COUNT(CASE WHEN success_tier = 'Viral' THEN 1 END)/COUNT(*) * 100), "%") AS viral_percentage
FROM products
GROUP BY pricing_model
ORDER BY avg_success_score DESC;
