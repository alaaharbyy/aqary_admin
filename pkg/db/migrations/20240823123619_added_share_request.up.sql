
CREATE TABLE "share_requests" (
    "id" bigserial   NOT NULL,
    -- share_id bigint
    -- sharing_type bigint
    -- Sharing Types :
    -- 1- Internal
    -- 2- External
    -- documents varchar[]
    "shared_doc_id" bigint   NOT NULL,
    "request_status" bigint   NOT NULL,
    -- /*
    -- Request Statuses :
    -- 1- Pending
    -- 2 - Rejected
    -- 3- Approved
    -- */
    "share_with" bigint   NOT NULL,
    "owner_id" bigint   NOT NULL,
    "created_by" bigint   NOT NULL,
    "created_at" timestamptz   NOT NULL,
    "updated_at" timestamptz   NOT NULL,
    CONSTRAINT "pk_share_requests" PRIMARY KEY (
        "id"
     )
);


ALTER TABLE "share_requests" ADD CONSTRAINT "fk_share_requests_shared_doc_id" FOREIGN KEY("shared_doc_id")
REFERENCES "shared_doc" ("id");

ALTER TABLE "share_requests" ADD CONSTRAINT "fk_share_requests_share_with" FOREIGN KEY("share_with")
REFERENCES "users" ("id");

ALTER TABLE "share_requests" ADD CONSTRAINT "fk_share_requests_owner_id" FOREIGN KEY("owner_id")
REFERENCES "users" ("id");

ALTER TABLE "share_requests" ADD CONSTRAINT "fk_share_requests_created_by" FOREIGN KEY("created_by")
REFERENCES "users" ("id");