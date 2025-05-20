ALTER TABLE "country_guide" ADD CONSTRAINT "fk_country_id" FOREIGN KEY("country_id") REFERENCES "countries" ("id");
ALTER TABLE "city_guide" ADD CONSTRAINT "fk_city_id" FOREIGN KEY("city_id") REFERENCES "cities" ("id");
ALTER TABLE "state_guide" ADD CONSTRAINT "fk_state_id" FOREIGN KEY("state_id") REFERENCES "states" ("id");
 