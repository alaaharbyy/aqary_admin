



-- name: GetTotalAvgHolidayHomeStayReviews :one   
WITH averages AS (
    SELECT 
        AVG(comfortness) AS avg_comfortness, 
        AVG(communications) AS avg_communications, 
        AVG(cleanliness) AS avg_cleanliness, 
        AVG(location) AS avg_location
    FROM 
        holiday_stay_reviews
        Where holiday_home_id = $1
)
SELECT 
    ROUND((
        (avg_comfortness + avg_communications + avg_cleanliness + avg_location) / 4
    )::numeric, 1) AS overall_average
FROM 
    averages;



-- name: GetAllHolidayHomeStayReviewsWithOverAllAverages :one
WITH avg_calculations AS (
    SELECT 
        holiday_home_id,
        ROUND((
            (AVG(comfortness) + AVG(communications) + AVG(cleanliness) + AVG(location)) / 4
        )::numeric, 1) AS overall_average
    FROM 
        holiday_stay_reviews
    WHERE 
        holiday_home_id = $1
    GROUP BY 
        holiday_home_id
)
SELECT 
    hsr.*,
    ac.overall_average
FROM 
    holiday_stay_reviews hsr
JOIN 
    avg_calculations ac
ON 
    hsr.holiday_home_id = ac.holiday_home_id
WHERE 
    hsr.holiday_home_id = $1;



-- -- name: GetAllParentJobCategoriesWithSubcategoryCount :many
-- WITH SubcategoryCount AS (
--     SELECT
--         parent_category_id,
--         COUNT(*) AS subcategory_count
--     FROM
--         job_categories
--     WHERE
--         status != 5 AND status != 6
--     GROUP BY
--         parent_category_id
-- )
-- SELECT
--     jc.id,
--     -- jc.ref_no,
--     jc.parent_category_id,
--     jc.category_name,
--     jc.description,
--     -- jc.company_types_id,
--     -- jc.companies_id,
--     -- jc.is_branch,
--     jc.category_image,
--     jc.created_at,
--     jc.created_by,
--     jc.status,
--     jc.company_name,
--     COALESCE(sc.subcategory_count, 0) AS subcategory_count
-- FROM
--     job_categories jc
-- LEFT JOIN
--     SubcategoryCount sc ON jc.id = sc.parent_category_id
-- WHERE
--     jc.parent_category_id = 0
--     AND jc.status != 5
--     AND jc.status != 6
-- ORDER BY
--     jc.id DESC;



-- name: DeleteExhibitionMediaByURL :one 
WITH X AS (
    SELECT id AS "media_id", array_remove(media_url, $2) AS new_array
    FROM exhibitions_media
    WHERE $2 = ANY(media_url) AND id=$1 
)
UPDATE exhibitions_media
SET media_url = x.new_array
FROM x
WHERE exhibitions_media.id = $1  AND (SELECT event_status FROM exhibitions WHERE id=exhibitions_id)!=5
RETURNING exhibitions_media.*;

-- name: DeleteExhibitionMedia :exec
DELETE FROM exhibitions_media WHERE id=$1;

-- name: CountFilterHolidayHome :one
With x As
(SELECT
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
    AND holiday_home.status NOT IN (5, 6) GROUP BY holiday_home.id) 
    SELECT COUNT(*) FROM x;


-- -- name: SearchParentCategoriesByTitle :many
-- WITH SubcategoryCount AS (
--     SELECT
--         parent_category_id,
--         COUNT(*) AS subcategory_count
--     FROM
--         job_categories
--     WHERE
--         status != 5 AND status != 6
--     GROUP BY
--         parent_category_id
-- )
-- SELECT
--     jc.id,
--     -- jc.ref_no,
--     jc.parent_category_id,
--     jc.category_name,
--     jc.description,
--     -- jc.company_types_id,
--     -- jc.companies_id,
--     -- jc.is_branch,
--     jc.category_image,
--     jc.created_at,
--     jc.created_by,
--     jc.status,
--     jc.company_name,
--     COALESCE(sc.subcategory_count, 0) AS subcategory_count
-- FROM
--     job_categories jc
-- LEFT JOIN
--     SubcategoryCount sc ON jc.id = sc.parent_category_id
-- WHERE
--     jc.parent_category_id = 0
--     AND jc.status != 5
--     AND jc.status != 6
--     AND jc.category_name ILIKE '%' || $1 || '%'
-- ORDER BY
--     jc.id DESC;



-- name: FilterExhibition :many
WITH X AS (
    SELECT 
        e.id, e.title, e.description, e.ref_no, e.start_date, e.end_date,
        e.specific_address, em.media_url,e.event_logo_url,
       CAST( COALESCE((
            SELECT 
            ROUND((
            (AVG(clean) + AVG(facilities) + AVG(location) + AVG(securities)) / 4
        )::numeric, 1) AS overall_average
            FROM exhibition_reviews er
            WHERE er.exhibition_id = e.id
        ), 0.0) AS float) AS overall_average, 
        (SELECT COUNT(id)
        FROM exhibition_reviews WHERE exhibition_id=e.id
        ) AS number_of_reviews
    FROM 
        exhibitions e
    LEFT JOIN 
        exhibitions_media em ON e.id = em.exhibitions_id AND em.gallery_type = 1 AND em.media_type = 1
    WHERE 
        e.countries_id = $1 AND (e.event_status = $2 OR e.event_status = $3)
)
SELECT id, title, description, ref_no, start_date, end_date, specific_address, media_url, event_logo_url, overall_average,number_of_reviews
FROM X
ORDER BY 
    CASE WHEN $4= 'ASC' THEN overall_average END ASC,
    CASE WHEN $4= 'DESC' THEN overall_average END DESC
LIMIT $5
OFFSET $6;



-- -- name: GetPaymentPlansForProjProperties :many
-- WITH PlanOptions AS (
--     SELECT 
--         option_no,
--         array_agg(id ORDER BY id) as plan_ids
--     FROM 
--         payment_plans_packages
--     WHERE 
--         property = 1 
--         AND payment_plans_packages.properties_id = $1
--         AND from_which_section = 'project' 
--         AND is_property = true 
--         AND status != 6 
--     GROUP BY 
--         option_no
-- )
-- SELECT 
--     po.option_no,
--     json_agg(
--         json_build_object(
--             'id', p.id,
--             'milestone', p.milestone,
--             'percentage',p.percentage
--         )
--     ) AS plan_details
-- FROM 
--     PlanOptions po
-- JOIN 
--     payment_plans_packages p ON p.id = ANY(po.plan_ids)
-- GROUP BY 
--     po.option_no
-- ORDER BY 
--     po.option_no;



-- -- name: GetSingleUnitDetailsByID :one
-- WITH AmenitiesCategories AS (
--     SELECT
--         p.id as unit_id,
--         json_agg(
--            distinct jsonb_build_object(
--                 'id', catg.id ,
--                 'title', catg.category 
--             )
--         ) AS amenities_categories
--     FROM
--         units p
--     JOIN LATERAL unnest(p.amenities_id) AS amenity_id ON true
--     JOIN amenities a ON a.id = amenity_id
--     JOIN facilities_amenities_categories catg ON catg.id = a.category_id
--     WHERE p.id = $1
--     GROUP BY
--         p.id
-- ),
-- FacilityCategories AS (
--     SELECT
--         u.id AS unit_id,
--         json_agg(
--            distinct jsonb_build_object(
--                 'id', catg.id,
--                 'title', catg.category
--             )
--         ) AS facility_categories
--     FROM
--         projects p
--     JOIN LATERAL unnest(p.facilities_id) AS facility_id ON true
--     JOIN facilities f ON f.id = facility_id
--     JOIN facilities_amenities_categories catg ON catg.id = f.category_id 
--     JOIN project_properties pp ON pp.projects_id=p.id
--     JOIN units u ON u.properties_id=pp.id
--     GROUP BY
--         u.id
-- )
-- SELECT
-- 	sqlc.embed(u),
--     sqlc.embed(c),
--     sqlc.embed(co),
--     sqlc.embed(s),
--     sqlc.embed(com),
--     sqlc.embed(scom),
--     sqlc.embed(utf),
-- 	COALESCE(ut.id,0) AS unit_type_id,
-- 	COALESCE(ut.title,'') AS unit_type_title,
-- 	COALESCE(ut.image_url, ARRAY[]::TEXT[]) AS unit_type_img,
 
-- 	COALESCE(ac.amenities_categories, '[]'::json) AS amenities_categories,
-- 	COALESCE(fc.facility_categories, '[]'::json) AS facility_categories,
-- 	COALESCE(images.id, 0) AS images_media_id,
--     COALESCE(images.file_urls, ARRAY[]::text[]) AS images,
--     COALESCE(img360.id, 0) AS img360_media_id,
--     COALESCE(img360.file_urls, ARRAY[]::text[]) AS img360,
--     COALESCE(video.id, 0) AS video_media_id,
--     COALESCE(video.file_urls, ARRAY[]::text[]) AS video,
--     COALESCE(panorama.id, 0) AS panorama_media_id,
--     COALESCE(panorama.file_urls, ARRAY[]::text[]) AS panorama
-- FROM units u 
-- JOIN unit_facts utf ON utf.unit_id=u.id 
-- JOIN addresses a ON a.id=u.addresses_id
-- JOIN cities c ON a.cities_id = c.id
-- JOIN countries co ON a.countries_id = co.id
-- JOIN states s ON s.id = a.states_id
 
-- LEFT JOIN unit_type_detail ut ON ut.id = u.property_types_id
 
-- LEFT JOIN communities com ON com.id = a.communities_id
 
-- LEFT JOIN sub_communities scom ON scom.id = a.sub_communities_id
-- LEFT JOIN unit_media images ON images.units_id=u.id AND images.media_type = 1 
-- LEFT JOIN unit_media img360 ON img360.units_id=u.id AND img360.media_type = 2
-- LEFT JOIN unit_media video ON video.units_id=u.id AND video.media_type = 3 
-- LEFT JOIN unit_media panorama ON panorama.units_id=u.id AND panorama.media_type = 4
 
-- LEFT JOIN AmenitiesCategories ac ON u.id=ac.unit_id 
-- LEFT JOIN FacilityCategories fc ON u.id=fc.unit_id
 
-- WHERE u.id =$1 LIMIT 1;



-- -- name: GetAmenitiesForUnit :many
-- with ids as(
-- 	select 
-- 	UNNEST(amenities_id) AS amenity
-- 	from units where units.id=$1
-- )
-- SELECT a.* from amenities a
-- JOIN ids as id on  id.amenity=a.id;



-- -- name: GetAllHolidayHomesByCountryAndType :many
-- WITH HolidayHomeCategories AS (
-- 	SELECT id as holiday_home_id, UNNEST(holiday_home_categories) as catg_id
-- 	from holiday_home 
-- 	WHERE status !=6 AND countries_id = $1  AND holiday_home_type = $2
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
-- 	WHERE hm.status !=6 AND hm.countries_id = $1 AND hm.holiday_home_type = $2 
-- 	group by hm.id
-- ),
-- PackageInclusion AS (
-- 	SELECT id as holiday_home_id, UNNEST(holiday_package_inclusions) as pkg_id
-- 	from holiday_home 
-- 	WHERE status !=6 AND countries_id = $1 AND holiday_home_type = $2 
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
-- 	WHERE hm.status !=6 AND hm.countries_id = $1 AND hm.holiday_home_type = $2
-- 	group by hm.id
-- ),
 
-- ViewsIds AS (
-- 	SELECT id as holiday_home_id, UNNEST(views) as view_id
-- 	from holiday_home
-- 	WHERE status !=6 AND countries_id = $1  AND holiday_home_type = $2
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
-- 	WHERE hm.status !=6 AND hm.countries_id = $1  AND hm.holiday_home_type = $2 
-- 	group by hm.id
-- ),
-- FacilitiesCTE AS (
-- 	select hm.id as holiday_home_id ,UNNEST(facilities) as fac 
-- 	from holiday_home hm
-- 	WHERE status !=6 AND countries_id = $1  AND holiday_home_type = $2
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
-- 	WHERE hm.status !=6 AND hm.countries_id = $1  AND hm.holiday_home_type = $2 
-- 	group by hm.id
-- ),
-- AmenitiesCTE AS (
-- 	select hm.id as holiday_home_id , UNNEST(amenities) as am 
-- 	from holiday_home hm 
-- 	WHERE status !=6 AND countries_id = $1 AND holiday_home_type = $2
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
-- 	WHERE hm.status !=6 AND countries_id =$1 AND holiday_home_type =$2 
-- 	group by hm.id
-- )
-- select 
-- 	sqlc.embed(hm),
-- 	hm.id,
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
-- LEFT JOIN 
-- 		AmenitiesStruct am ON hm.id = am.holiday_home_id
-- INNER JOIN 
-- 		countries ON countries.id = hm.countries_id
-- INNER JOIN 
-- 	states ON states.id = hm.states_id 
-- INNER JOIN 
-- 	cities ON cities.id = hm.cities_id 
-- INNER JOIN 
-- 	communities ON communities.id = hm.communities_id
-- LEFT JOIN 
-- 	sub_communities ON sub_communities.id = hm.subcommunity_id
-- WHERE hm.status !=6 AND hm.countries_id = $1 AND hm.holiday_home_type = $2 
-- ORDER BY hm.updated_at DESC
-- LIMIT $3
-- OFFSET $4;

