-- -- name: CreateHolidayHome :one
-- INSERT INTO holiday_home (
-- 	ref_no, 
-- 	company_types_id, 
-- 	is_branch, 
-- 	companies_id, 
-- 	title, 
-- 	title_ar, 
-- 	holiday_home_categories, 
-- 	countries_id, 
-- 	states_id, 
-- 	cities_id, 
-- 	communities_id, 
-- 	subcommunity_id, 
-- 	lat, 
-- 	lng, 
-- 	ranking, 
-- 	price, 
-- 	no_of_hours, 
-- 	no_of_rooms, 
-- 	no_of_bathrooms, 
-- 	views, 
-- 	facilities, 
-- 	holiday_package_inclusions, 
-- 	description, 
-- 	description_ar, 
-- 	posted_by,
--     status,	
-- 	holiday_home_type,
-- 	created_at, 
-- 	updated_at
-- )
-- VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29) RETURNING *;
 
-- -- name: UpdateHolidayHome :one
-- UPDATE holiday_home
-- SET 
--     ref_no = $1,
--     company_types_id = $2,
--     is_branch = $3,
--     companies_id = $4,
--     title = $5,
--     title_ar = $6,
--     holiday_home_categories = $7,
--     countries_id = $8,
--     states_id = $9,
--     cities_id = $10,
--     communities_id = $11,
--     subcommunity_id = $12,
--     lat = $13,
--     lng = $14,
--     ranking = $15,
--     price = $16,
--     no_of_hours = $17,
--     no_of_rooms = $18,
--     no_of_bathrooms = $19,
--     views = $20,
--     facilities = $21,
--     holiday_package_inclusions = $22,
--     description = $23,
--     description_ar = $24,
--     posted_by = $25,
--     updated_at = $26,
-- 	status = $27,
-- 	holiday_home_type = $28
-- WHERE
--     id = $29 RETURNING *;

-- name: GetAllLocalHolidayHome :many
SELECT * FROM holiday_home where countries_id = $3 and status != 6 and holiday_home_type = $4 ORDER BY id DESC LIMIT $1 OFFSET $2;
 
-- -- name: GetAllInternationalHolidayHome :many
-- WITH HolidayHomeCategories AS (
-- 	SELECT id as holiday_home_id, UNNEST(holiday_home_categories) as catg_id
-- 	from holiday_home 
-- 	WHERE status !=6 AND countries_id !=1  AND holiday_home_type = $1
-- ),
-- catgsStruct as(
-- 	SELECT hm.id as holiday_home_id,
-- 	json_agg(
-- 		json_build_object(
--                 'id', hmc.catg_id,
--                 'title', catgs_table.title,
--                 'title_ar', catgs_table.title_ar,
--                 'status', catgs_table.status
--             )
-- 	) as categories
-- 	from holiday_home hm 
-- 	join HolidayHomeCategories hmc on hmc.holiday_home_id= hm.id
-- 	join holiday_home_categories catgs_table on hmc.catg_id= catgs_table.id
-- 	WHERE hm.status !=6 AND hm.countries_id !=1 AND hm.holiday_home_type = $1 
-- 	group by hm.id
-- ),
-- PackageInclusion AS (
-- 	SELECT id as holiday_home_id, UNNEST(holiday_package_inclusions) as pkg_id
-- 	from holiday_home 
-- 	WHERE status !=6 AND countries_id !=1 AND holiday_home_type = $1
-- ),
-- PackgStrcut as(
-- 	SELECT hm.id as holiday_home_id,
-- 	json_agg(
-- 		json_build_object(
--                 'id', pkgInc.pkg_id,
--                 'title', pkg_table.title,
--                 'title_ar', pkg_table.title_ar,
--                 'status', pkg_table.status
--             )
-- 	) as packages
-- 	from holiday_home hm 
-- 	join PackageInclusion pkgInc on pkgInc.holiday_home_id= hm.id
-- 	join holiday_package_inclusions pkg_table on pkgInc.pkg_id= pkg_table.id
-- 	WHERE hm.status !=6 AND hm.countries_id !=1 AND hm.holiday_home_type = $1 
-- 	group by hm.id
-- ),

-- ViewsIds AS (
-- 	SELECT id as holiday_home_id, UNNEST(views) as view_id
-- 	from holiday_home
-- 	WHERE status !=6 AND countries_id !=1  AND holiday_home_type = $1
-- ),
-- ViewsStruct as(
-- 	SELECT hm.id as holiday_home_id,
-- 	json_agg(
-- 		json_build_object(
--                 'id', vss.id,
--                 'title', vss.title
--             )
-- 	) as jsonViews
-- 	from holiday_home hm 
-- 	join ViewsIds vs on vs.holiday_home_id= hm.id
-- 	join views vss on vss.id=vs.view_id
-- 	WHERE hm.status !=6 AND hm.countries_id !=1  AND hm.holiday_home_type = $1
-- 	group by hm.id
-- ),
-- FacilitiesCTE AS (
-- 	select hm.id as holiday_home_id ,UNNEST(facilities) as fac 
-- 	from holiday_home hm
-- 	WHERE status !=6 AND countries_id !=1  AND holiday_home_type = $1
-- ),
-- FacilitiesStruct AS (
-- 	select hm.id as holiday_home_id,
-- 	json_agg(
-- 		json_build_object(
-- 		'id',facilities.id,
-- 		'icon_url',facilities.icon_url, 
-- 		'title',facilities.title
-- 		)
-- 	) as jsonViews
-- 	from holiday_home hm 
-- 	join FacilitiesCTE ON hm.id = FacilitiesCTE.holiday_home_id
-- 	join facilities ON FacilitiesCTE.fac = facilities.id
-- 	WHERE hm.status !=6 AND hm.countries_id !=1  AND hm.holiday_home_type = $1
-- 	group by hm.id
-- ),
-- AmenitiesCTE AS (
-- 	select hm.id as holiday_home_id , UNNEST(amenities) as am 
-- 	from holiday_home hm 
-- 	WHERE status !=6 AND countries_id !=1 AND holiday_home_type = $1
-- ), 
-- AmenitiesStruct AS (
-- 	select hm.id as holiday_home_id, 
-- 	json_agg(
-- 		json_build_object(
-- 		'id',amenities.id, 
-- 		'icon_url',amenities.icon_url, 
-- 		'title',amenities.title
-- 		)
-- ) as jsonAmenities
-- 	from holiday_home hm 
-- 	join AmenitiesCTE on hm.id = AmenitiesCTE.holiday_home_id
-- 	join amenities on amenities.id = AmenitiesCTE.am
-- 	WHERE hm.status !=6 AND countries_id !=1 AND holiday_home_type = $1 
-- 	group by hm.id
-- )
-- select 
-- 	sqlc.embed(hm),
-- 	COALESCE(na.categories, '[]'::json) AS categories,
-- 	COALESCE(pk.packages, '[]'::json) AS packages,
-- 	COALESCE(va.jsonViews, '[]'::json) AS views,
-- 	COALESCE(fs.jsonViews, '[]'::json) AS facilities, 
-- 	COALESCE(am.jsonAmenities, '[]'::json) AS amenities, 
-- 	countries.country, 
-- 	cities.city, 
-- 	states."state",
-- 	communities.community, 
-- 	sub_communities.sub_community

-- from holiday_home hm 
-- LEFT JOIN
--     catgsStruct na ON hm.id = na.holiday_home_id
-- LEFT JOIN
--     PackgStrcut pk ON hm.id = pk.holiday_home_id
-- LEFT JOIN
--     ViewsStruct va ON hm.id = va.holiday_home_id
-- LEFT JOIN 
-- 		FacilitiesStruct fs ON hm.id = fs.holiday_home_id
-- INNER JOIN 
-- 		countries ON countries.id = hm.countries_id
-- INNER JOIN 
-- 	states ON states.id = hm.states_id 
-- INNER JOIN 
-- 	cities ON cities.id = hm.cities_id 
-- INNER JOIN 
-- 	communities ON communities.id = hm.communities_id
-- INNER JOIN 
-- 	sub_communities ON sub_communities.id = hm.subcommunity_id
-- LEFT JOIN 
-- 		AmenitiesStruct am ON hm.id = am.holiday_home_id
-- WHERE hm.status !=6 AND hm.countries_id !=1 AND hm.holiday_home_type = $1
-- ORDER BY hm.updated_at DESC
-- LIMIT $2
-- OFFSET $3;
 
-- name: GetAllLocalHolidayHomeCount :one
SELECT COUNT(*) FROM holiday_home WHERE countries_id = $1 and status != 6  and holiday_home_type = $2;

-- name: GetAllInternationalHolidayHomeCount :one
SELECT COUNT(*) FROM holiday_home WHERE countries_id != $1 and status != 6 and holiday_home_type = $2;

-- name: GetHolidayHomeById :one
SELECT * FROM holiday_home where id = $1;
 
-- name: UpdateHolidayHomeStatus :one
UPDATE holiday_home
SET
    status= $2,
    updated_at = $3
WHERE
    id = $1
RETURNING *;
 

-- name: GetAllDeletedHolidayHome :many
WITH HolidayHomeCategories AS (
	SELECT id as holiday_home_id, UNNEST(holiday_home_categories) as catg_id
	from holiday_home 
	WHERE status =6 
),
catgsStruct as(
	SELECT hm.id as holiday_home_id,
	json_agg(
		json_build_object(
                'id', hmc.catg_id,
                'title', catgs_table.title,
                'title_ar', catgs_table.title_ar,
                'holiday_home_type' , catgs_table.holiday_home_type,
                'status', catgs_table.status
            )
	) as categories
	from holiday_home hm 
	join HolidayHomeCategories hmc on hmc.holiday_home_id= hm.id
	join holiday_home_categories catgs_table on hmc.catg_id= catgs_table.id
	WHERE hm.status =6  
	group by hm.id
)
SELECT hm.id,
    hm.ref_no, 
    hm.company_types_id, 
    hm.is_branch, 
    hm.companies_id, 
    hm.location_url,
    hm.ranking,
    hm.holiday_home_type,
    countries.country, 
	cities.city, 
	states."state",
	communities.community, 
	sub_communities.sub_community,
	hm.title, hm.title_ar FROM holiday_home hm 
INNER JOIN 
		countries ON countries.id = hm.countries_id
INNER JOIN 
	states ON states.id = hm.states_id 
INNER JOIN 
	cities ON cities.id = hm.cities_id 
INNER JOIN 
	communities ON communities.id = hm.communities_id
INNER JOIN 
	sub_communities ON sub_communities.id = hm.subcommunity_id
where hm.status = 6 Order by hm.updated_at DESC;
 
-- name: GetAllCountDeletedHolidayHome :one
SELECT count(*) FROM holiday_home where status = 6;

-- name: GetAllDeletedHolidayHomeWithPagination :many
WITH HolidayHomeCategories AS (
	SELECT id as holiday_home_id, UNNEST(holiday_home_categories) as catg_id
	from holiday_home 
	WHERE status =6 
),
catgsStruct as(
	SELECT hm.id as holiday_home_id,
	json_agg(
		json_build_object(
                'id', hmc.catg_id,
                'title', catgs_table.title,
                'title_ar', catgs_table.title_ar,
                'holiday_home_type' , catgs_table.holiday_home_type,
                'status', catgs_table.status
            )
	) as categories
	from holiday_home hm 
	join HolidayHomeCategories hmc on hmc.holiday_home_id= hm.id
	join holiday_home_categories catgs_table on hmc.catg_id= catgs_table.id
	WHERE hm.status =6  
	group by hm.id
)
SELECT hm.id,
    hm.ref_no, 
    hm.company_types_id, 
    hm.is_branch, 
    hm.companies_id, 
    hm.location_url,
    hm.ranking,
    hm.holiday_home_type,
    countries.country, 
	cities.city, 
	states."state",
	communities.community, 
	sub_communities.sub_community,
	hm.title, hm.title_ar FROM holiday_home hm 
INNER JOIN 
		countries ON countries.id = hm.countries_id
INNER JOIN 
	states ON states.id = hm.states_id 
INNER JOIN 
	cities ON cities.id = hm.cities_id 
INNER JOIN 
	communities ON communities.id = hm.communities_id
INNER JOIN 
	sub_communities ON sub_communities.id = hm.subcommunity_id
where hm.status = 6 Order by hm.updated_at DESC
LIMIT $1 OFFSET $2;



-- name: GetAllHolidayHome :many
SELECT * FROM holiday_home where status != 6 ORDER BY id DESC LIMIT $1 OFFSET $2;


-- name: GetHolidayHomeByCategory :many
SELECT * 
FROM holiday_home 
WHERE holiday_home_type = $1 
AND holiday_home_categories = ARRAY[$2::bigint];

-- name: GetAllHolidayHomeCategoryByTitle :one
select * from holiday_home_categories Where title ILIKE $1 AND status != 6;

-- name: FilterHolidayHome :many
SELECT
    sqlc.embed(holiday_home)
FROM
    holiday_home
LEFT JOIN cities ON holiday_home.cities_id = cities.id
LEFT JOIN communities ON holiday_home.communities_id = communities.id
LEFT JOIN states ON holiday_home.states_id = states.id
LEFT JOIN countries ON holiday_home.countries_id = countries.id
LEFT JOIN sub_communities ON holiday_home.subcommunity_id = sub_communities.id
LEFT JOIN holiday_home_categories ON holiday_home_categories.id = ANY (holiday_home.holiday_home_categories)
LEFT JOIN holiday_media ON holiday_home.id = holiday_media.holiday_home_id
WHERE
    ( @country_id::bigint = 0 OR holiday_home.countries_id =  @country_id::bigint)  -- UAE
    AND ( @states_id::bigint = 0  OR holiday_home.states_id = @states_id::bigint )  -- states filter
    AND ( @subcommunity_id::bigint = 0  OR holiday_home.cities_id = @subcommunity_id::bigint )  -- subcommunity filter
    AND ( @cities_id::bigint = 0  OR holiday_home.cities_id = @cities_id::bigint )  -- City filter
    AND (@holiday_home_type::bigint = 0 OR holiday_home.holiday_home_type =  @holiday_home_type::bigint)  -- Type filter
    AND (holiday_home.price BETWEEN @min_price::bigint AND @max_price::bigint)  -- Price range filter
    AND (ARRAY_LENGTH(@no_of_rooms::bigint[], 1) IS NULL OR holiday_home.no_of_rooms = ANY (@no_of_rooms::bigint[])) -- Bedrooms filter
    AND (ARRAY_LENGTH(@no_of_bathrooms::bigint[], 1) IS NULL OR holiday_home.no_of_bathrooms = ANY (@no_of_bathrooms::bigint[]))  -- Bathrooms filter
    AND (CASE WHEN @status::bigint IS NULL THEN TRUE WHEN @status::bigint = 0 THEN TRUE ELSE holiday_home.status = @status::bigint END)  -- Status filter
    AND (@user_id::bigint = 0  OR holiday_home.posted_by = @user_id::bigint  ) -- Ownership filter
    AND (ARRAY_LENGTH(@holiday_home_categories::bigint[], 1) IS NULL OR (holiday_home.holiday_home_categories IS NOT NULL AND holiday_home.holiday_home_categories && @holiday_home_categories::bigint[])) --categories filter
    AND (CASE WHEN ARRAY_LENGTH(@facilities::bigint[], 1) IS NULL THEN TRUE ELSE holiday_home.facilities && @facilities::bigint[] END)  -- facilities filter
    	AND(
		CASE WHEN ARRAY_LENGTH(@views::bigint [],
			1) IS NULL THEN
			TRUE
		ELSE
			holiday_home."views" && @views::bigint []
		END) -- views
	-- media
	AND(@media::bigint = 0
		OR(array_length(image_url,
				@image_url) IS NOT NULL)
		OR(array_length(image360_url,
				@image360_url) IS NOT NULL)
		OR(array_length(video_url,
				@video_url) IS NOT NULL)
		OR(array_length(panaroma_url,
				@panaroma_url) IS NOT NULL))
    AND (ARRAY_LENGTH(@ranking::bigint[], 1) IS NULL OR holiday_home.ranking = ANY (@ranking::bigint[])) -- Ranking filter
    AND (@community::varchar IS NULL OR communities.community ILIKE @community::varchar)  -- Community filter 
    AND (CASE WHEN @searchWith::varchar IS NULL THEN TRUE ELSE holiday_home.title ILIKE @searchWith::varchar OR holiday_home.title_ar ILIKE @searchWith::varchar OR cities.city ILIKE @searchWith::varchar OR sub_communities.sub_community ILIKE @searchWith::varchar OR holiday_home_categories.title ILIKE @searchWith::varchar END)  -- Search purpose filter
    AND holiday_home.status NOT IN (5, 6) GROUP BY holiday_home.id LIMIT $1 OFFSET $2;

-- name: GetDeletedHolidayHomeById :one
SELECT id,ref_no FROM holiday_home where id = $1 and status =6;



-- name: CreateNewHolidayHome :one
INSERT INTO holiday_home (
    ref_no,
    company_types_id,
    is_branch,
    companies_id,
    title,
    title_ar,
    holiday_home_categories,
    countries_id,
    states_id,
    cities_id,
    communities_id,
    subcommunity_id,
    lat,
    lng,
    ranking,
    price_per_night,
    no_of_hours,
    no_of_rooms,
    no_of_bathrooms,
    views,
    facilities,
    holiday_package_inclusions,
    description,
    description_ar,
    posted_by,
    status,
    holiday_home_type,
    created_at,
    updated_at,
    price_per_adults,
    price_per_children,
    no_of_guest,
    amenities,
    location_url
)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32 ,$33,$34) RETURNING *;



-- name: UpdateNewHolidayHome :one
UPDATE holiday_home
SET
    company_types_id = $2,
    is_branch = $3,
    companies_id = $4,
    title = $5,
    title_ar = $6,
    holiday_home_categories = $7,
    countries_id = $8,
    states_id = $9,
    cities_id = $10,
    communities_id = $11,
    subcommunity_id = $12,
    lat = $13,
    lng = $14,
    ranking = $15,
    price_per_night = $16,
    no_of_hours = $17,
    no_of_rooms = $18,
    no_of_bathrooms = $19,
    views = $20,
    facilities = $21,
    holiday_package_inclusions = $22,
    description = $23,
    description_ar = $24,
    price_per_adults=$25,
    updated_at = $26,
    status = $27,
    holiday_home_type = $28,
    price_per_children=$29,
    no_of_guest=$30,
    amenities=$31,
   location_url=$32
WHERE
    id=$1
RETURNING *;

