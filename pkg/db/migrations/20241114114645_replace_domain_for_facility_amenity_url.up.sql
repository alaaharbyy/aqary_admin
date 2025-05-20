UPDATE facilities_amenities
SET icon_url = REPLACE(icon_url, 'api.aqaryservices.com', 'aqarydashboard.blob.core.windows.net')
WHERE icon_url LIKE '%api.aqaryservices.com/upload/facilities%';


UPDATE facilities_amenities
SET icon_url = REPLACE(icon_url, 'api.aqaryservices.com', 'aqarydashboard.blob.core.windows.net')
WHERE icon_url LIKE '%api.aqaryservices.com/upload/amenities%';