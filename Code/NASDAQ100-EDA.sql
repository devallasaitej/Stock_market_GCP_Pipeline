-- Basic Descriptive statistics
SELECT
  AVG(close) AS average_close,
  MIN(close) AS min_close,
  MAX(close) AS max_close,
  STDDEV(close) AS stddev_close
FROM `yahoo.nasdaq100`;

-- Days with high volatility
SELECT
  DATE,
  MAX(high - low) AS daily_volatility
FROM `yahoo.nasdaq100`
GROUP BY DATE
ORDER BY daily_volatility DESC
LIMIT 5;

-- Rolling average trend
SELECT
DATE,
AVG(close) OVER (ORDER BY DATE ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS rolling_avg_close
FROM `yahoo.nasdaq100`
ORDER BY DATE;

-- Daily return trend
SELECT
DATE,
close,
(close - LAG(close) OVER (ORDER BY DATE)) / LAG(close) OVER (ORDER BY DATE) AS daily_return
FROM `yahoo.nasdaq100`
ORDER BY DATE;

-- Weekly range
SELECT
EXTRACT(YEAR FROM DATE) AS year,
EXTRACT(WEEK FROM DATE) AS week,
MAX(high) - MIN(low) AS weekly_range
FROM `yahoo.nasdaq100`
GROUP BY year,week
ORDER BY year,week;

-- Unusual volume trade days
SELECT
DATE,
volume
FROM `yahoo.nasdaq100`
WHERE volume > (SELECT AVG(volume) * 2 FROM `yahoo.nasdaq100`)
ORDER BY volume DESC
LIMIT 5;

-- Streak Lengths
WITH streaks AS (
  SELECT
    DATE,
    close,
    LAG(close) OVER (ORDER BY DATE) AS prev_close,
    CASE WHEN close > LAG(close) OVER (ORDER BY DATE) THEN 'bull' ELSE 'bear' END AS streak_type
  FROM `yahoo.nasdaq100`
)
SELECT
  streak_type,
  COUNT(*) AS streak_length
FROM streaks
GROUP BY streak_type
ORDER BY streak_length DESC;

-- Days with high price gaps
SELECT
  DATE,
  open,
  close,
  ABS(open - close) AS price_gap
FROM `yahoo.nasdaq100`
ORDER BY price_gap DESC
LIMIT 5;