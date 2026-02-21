CREATE TABLE night_staff_warnings (
  `id` SERIAL PRIMARY KEY,
  `staff_user_id` INTEGER,
  `user_id` INTEGER,
  `reason` TEXT,
  `banned` BOOLEAN,
  `banned_time` FLOAT,
  `banned_real_time` FLOAT,
  `created` FLOAT
);