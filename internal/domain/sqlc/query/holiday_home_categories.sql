

-- name: HolidayHomeCategoryWithCount :many
SELECT 
    hhc.title,
    COUNT(hh.id) AS total_holiday_homes
FROM 
    holiday_home_categories hhc
JOIN 
    holiday_home hh
ON 
    hhc.id = ANY (hh.holiday_home_categories)
GROUP BY 
    hhc.title
HAVING 
    COUNT(hh.id) > 0
ORDER BY 
    total_holiday_homes DESC;

