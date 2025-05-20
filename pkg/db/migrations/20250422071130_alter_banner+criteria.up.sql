ALTER TABLE "banner_criteria"
    DROP COLUMN "type";

ALTER TABLE "banner_criteria"
    DROP COLUMN "name";

ALTER TABLE "banner_criteria"
    ADD COLUMN "banner_type_id" bigint NOT NULL DEFAULT 0;

ALTER TABLE "banner_criteria"
    ADD COLUMN "banner_name_id" bigint NOT NULL DEFAULT 0;
