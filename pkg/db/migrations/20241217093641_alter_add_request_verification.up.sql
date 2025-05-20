ALTER TABLE "approvals"
ADD CONSTRAINT "fk_approvals_workflow_step"
FOREIGN KEY ("workflow_step")
REFERENCES "workflows" ("id")
ON DELETE CASCADE
ON UPDATE CASCADE;
