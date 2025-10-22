#OPTIMAL LAUNCH TIME ANALYSIS (DAY+HOUR)
SELECT 
	launch_day,
    launch_hour,
    COUNT(product_id) AS total_products,
    ROUND(AVG(total_upvotes),2) AS avg_upvotes,
	ROUND(AVG(success_score),2) AS avg_success_score,
	COUNT(CASE WHEN success_tier = 'Viral' OR success_tier = 'High' THEN 1 END) AS viral_products_count
FROM products
GROUP BY launch_day, launch_hour
ORDER BY avg_success_score DESC;

#MAKER EXPERIENCE IMPACT ON SUCCESS
SELECT 
	m.experience_level,
    ROUND(AVG(m.previous_launches),2) AS avg_prev_launches,
	COUNT(p.product_id) AS total_products,
    ROUND(AVG(p.total_upvotes),2) AS avg_upvotes,
	ROUND(AVG(p.success_score),2) AS avg_success_score,
	COUNT(CASE WHEN p.success_tier = 'Viral' OR p.success_tier = 'High' THEN 1 END) AS viral_products_count,
    ROUND(COUNT(CASE WHEN p.success_tier = 'Viral' OR p.success_tier = 'High' THEN 1 END)/COUNT(*) * 100, 2) AS viral_percentage
FROM
products p 
JOIN
product_makers pm
ON p.product_id = pm.product_id
JOIN
makers m
ON pm.maker_id = m.maker_id
WHERE pm.is_lead_maker = 'True'
GROUP BY experience_level
ORDER BY avg_success_score DESC;

#AI TREND ANALYSIS OVERTIME
SELECT 
	COUNT(p.product_id) AS total_products,
    CONCAT(p.launch_year, '-Q', p.launch_quarter) AS time_period,
    ais.subcategory_name,
    ROUND(AVG(p.total_upvotes),2) AS avg_upvotes,
	ROUND(AVG(p.success_score),2) AS avg_success_score
FROM 
products p
JOIN
ai_product_mapping apm
ON p.product_id = apm.product_id
JOIN ai_subcategories ais
ON apm.subcategory_id = ais.subcategory_id
GROUP BY time_period, ais.subcategory_name
ORDER BY avg_success_score DESC;

# BEST DAY-HOUR FOR AI CATEGORY
SELECT 
	p.launch_day,
	p.launch_hour,
    COUNT(p.product_id) AS product_count,
    c.category_name,
    ROUND(AVG(p.total_upvotes),2) AS avg_upvote,
    ROUND(AVG(p.success_score),2) AS avg_success_score
FROM products p
JOIN categories c
ON p.category_id = p.category_id
WHERE category_name LIKE 'AI%'
GROUP BY launch_hour,launch_day, category_name
ORDER BY avg_success_score DESC; 

#ENGAGEMENT CONVERSION RATIO
SELECT 
	COUNT(p.product_id) AS product_count,
    c.category_name,
    ROUND(AVG(p.total_comments)/NULLIF(AVG(p.total_upvotes), 0),4) AS comments_per_upvote,
    ROUND(AVG(p.total_followers)/NULLIF(AVG(p.total_views), 0)*100,4) AS followers_conversion_rate,
    ROUND(AVG(p.total_upvotes)/NULLIF(AVG(p.total_views),0)*100,4) AS upvotes_conversion_rate
FROM products p
JOIN 
categories c
ON p.category_id = c.category_id
GROUP BY category_name
ORDER BY upvotes_conversion_rate DESC;

#FIRST HOUR IMPACT ON OVERALL SUCCESS
SELECT 
	COUNT(p.product_id) AS product_count,
    p.success_tier,
	ROUND(AVG(e.upvotes),2) AS avg_first_hour_upvotes,
    ROUND(AVG(p.total_upvotes), 2) AS avg_total_upvotes,
    ROUND(AVG(e.upvotes) / NULLIF(AVG(p.total_upvotes), 0) * 100, 2) AS first_hour_percentage
FROM 
    products p
JOIN 
    hourly_engagement e ON p.product_id = e.product_id AND e.hour_from_launch = 0
GROUP BY 
    success_tier
ORDER BY 
    first_hour_percentage DESC;
 
#PRODUCT FEATURE COMBINATION OF SUCCESS
SELECT 
    has_video,
    featured,
    pricing_model,
    COUNT(*) AS product_count,
    ROUND(AVG(success_score), 2) AS avg_success_score,
    COUNT(CASE WHEN success_tier = 'Viral' OR success_tier = 'High' THEN 1 END) AS high_success_count,
    ROUND(COUNT(CASE WHEN success_tier = 'Viral' OR success_tier = 'High' THEN 1 END) / COUNT(*) * 100, 2) AS high_success_percentage
FROM 
    products
GROUP BY 
    has_video, featured, pricing_model
ORDER BY 
    avg_success_score DESC;


#SUCCESS FACTOR CORRELATION ANALYSIS
