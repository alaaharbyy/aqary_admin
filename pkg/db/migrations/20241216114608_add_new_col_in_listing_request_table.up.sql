ALTER TABLE listing_request 
ADD COLUMN platform bigint NOT NULL DEFAULT 1,
ADD COLUMN usage bigint NOT NULL DEFAULT 1;

ALTER TABLE listing_request
ALTER COLUMN platform DROP DEFAULT,
ALTER COLUMN usage DROP DEFAULT;

COMMENT ON COLUMN listing_request.platform IS '1 - finehome 2 - aqary investment ';