WITH daily_weather as (

SELECT 

date(time) as daily_weather,
weather,
temp,
pressure,
humidity,
clouds

FROM {{ source('demo','weather')}}

limit 10
),

daily_weather_agg as (
SELECT
    daily_weather,
    weather,
    ROUND(AVG(temp),2) AS avg_temp,
    ROUND(AVG(pressure),2) AS avg_pressure,
    ROUND(AVG(humidity),2) AS avg_humidity,
    ROUND(AVG(clouds),2) AS avg_clouds
FROM daily_weather
GROUP BY 1,2

qualify ROW_NUMBER() OVER (PARTITION BY daily_weather ORDER BY count(weather) DESC) =1
)

SELECT 
*
FROM daily_weather_agg