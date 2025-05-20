-- ! WARNING:: NO NEED TO RUN AGAIN IF THE SEQUENCE IS ALREADY ALTERED.

-- TRUNCATE TABLE section_permission CASCADE;
-- TRUNCATE TABLE permissions CASCADE;
-- TRUNCATE TABLE sub_section CASCADE;

-- -- it has to be unique so they will not conflict with each other
-- ALTER SEQUENCE section_permission_id_seq RESTART WITH 1;
-- ALTER SEQUENCE permissions_id_seq RESTART WITH 300;
-- ALTER SEQUENCE sub_section_id_seq RESTART WITH 1300;

-- REFRESH MATERIALIZED VIEW section_permission_mv;
-- REFRESH MATERIALIZED VIEW permissions_mv;
-- REFRESH MATERIALIZED VIEW sub_section_mv;