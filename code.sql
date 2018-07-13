-- Quiz funnel table
SELECT question, COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;

-- # of people that answered that "Not Sure."
SELECT COUNT(*) 
FROM survey
WHERE question = '5. When was your last eye exam?'
AND response = "Not Sure. Let's Skip It";

-- calculate conversion rates by aggregating across all rows 
WITH funnels AS (
  SELECT DISTINCT q.user_id,
	h.user_id IS NOT NULL AS 'home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
ON q.user_id = h.user_id
LEFT JOIN purchase p
ON q.user_id = p.user_id)
SELECT COUNT(*) AS 'num_quiz',
  SUM(home_try_on) AS 'num_try_on',
	SUM(is_purchase) AS 'num_purchased',
  1.0 * SUM(home_try_on) / COUNT(user_id) AS 'quiz_to_try',
  1.0 * SUM(is_purchase) / SUM(home_try_on) AS 'try_to_buy'
FROM funnels;

-- A/B test (3 pairs v 5 pairs)
WITH funnels AS (
  SELECT DISTINCT q.user_id,
	h.user_id IS NOT NULL AS 'home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
ON q.user_id = h.user_id
LEFT JOIN purchase p
ON q.user_id = p.user_id)
SELECT number_of_pairs,
  COUNT(*) AS 'num_quiz',
  SUM(home_try_on) AS 'num_try_on',
	SUM(is_purchase) AS 'num_purchased',
  1.0 * SUM(is_purchase) / SUM(home_try_on) AS 'try_to_buy'
FROM funnels
WHERE number_of_pairs IS NOT NULL
GROUP BY 1;

-- Most popular color
SELECT color, COUNT(color)
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

-- Most purchased model
SELECT model_name, COUNT(model_name)
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

-- Product sold, sales
SELECT COUNT(*), SUM(price)
FROM purchase;
