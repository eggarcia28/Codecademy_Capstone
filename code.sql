{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf830
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;\red56\green56\blue56;\red255\green255\blue255;\red0\green0\blue0;
}
{\*\expandedcolortbl;;\cssrgb\c28235\c28235\c28235;\cssrgb\c100000\c100000\c100000;\csgenericrgb\c0\c0\c0;
}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- Quiz funnel table\
SELECT question, COUNT(DISTINCT user_id)\
FROM survey\
GROUP BY 1;\
\
-- # of people that answered that "Not Sure."\
SELECT COUNT(*) \
FROM survey\
WHERE question = '5. When was your last eye exam?'\
AND response = "Not Sure. Let's Skip It";\
\pard\pardeftab720\partightenfactor0

\fs35\fsmilli17600 \cf2 \cb3 \expnd0\expndtw0\kerning0
\

\fs24 \cf4 -- calculate conversion rates by aggregating across all rows 
\fs35\fsmilli17600 \cf2 \
\pard\pardeftab720\partightenfactor0

\fs24 \cf0 \cb1 \kerning1\expnd0\expndtw0 WITH funnels AS (\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardeftab720\pardirnatural\partightenfactor0
\cf0   SELECT DISTINCT q.user_id,\
	h.user_id IS NOT NULL AS 'home_try_on',\
  h.number_of_pairs,\
  p.user_id IS NOT NULL AS 'is_purchase'\
FROM quiz q\
LEFT JOIN home_try_on h\
ON q.user_id = h.user_id\
LEFT JOIN purchase p \
ON q.user_id = p.user_id)\
SELECT COUNT(*) AS 'num_quiz',\
  SUM(home_try_on) AS 'num_try_on',\
	SUM(is_purchase) AS 'num_purchased',\
  1.0 * SUM(home_try_on) / COUNT(user_id) AS 'quiz_to_try',\
  1.0 * SUM(is_purchase) / SUM(home_try_on) AS 'try_to_buy'\
FROM funnels;\
\
\pard\pardeftab720\partightenfactor0
\cf0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardeftab720\pardirnatural\partightenfactor0
\cf0 \'97 A/B test (3 pairs v 5 pairs)\
\pard\pardeftab720\partightenfactor0
\cf0 WITH funnels AS (\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardeftab720\pardirnatural\partightenfactor0
\cf0   SELECT DISTINCT q.user_id,\
	h.user_id IS NOT NULL AS 'home_try_on',\
  h.number_of_pairs,\
  p.user_id IS NOT NULL AS 'is_purchase'\
FROM quiz q\
LEFT JOIN home_try_on h\
ON q.user_id = h.user_id\
LEFT JOIN purchase p \
ON q.user_id = p.user_id)\
SELECT number_of_pairs,\
  COUNT(*) AS 'num_quiz',\
  SUM(home_try_on) AS 'num_try_on',\
	SUM(is_purchase) AS 'num_purchased',\
  1.0 * SUM(is_purchase) / SUM(home_try_on) AS 'try_to_buy'\
FROM funnels\
WHERE number_of_pairs IS NOT NULL\
GROUP BY 1;
\b\fs28 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardeftab720\pardirnatural\partightenfactor0

\b0\fs24 \cf4 \
-- Most popular color\
SELECT color, COUNT(color)\
FROM purchase\
GROUP BY 1\
ORDER BY 2 DESC;\cf0 \
\cf4 \
-- Most purchased model\
SELECT model_name, COUNT(model_name)\
FROM purchase\
GROUP BY 1\
ORDER BY 2 DESC;\
\
-- Product sold, sales\
SELECT COUNT(*), SUM(price)\
FROM purchase;\
}