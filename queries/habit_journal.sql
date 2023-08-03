CREATE TABLE habits_journal (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  habit VARCHAR(100),
  day_date DATE,
  starting_time INT,
  finished_time INT,
  success_count INT,
  habit_id INTEGER,
  FOREIGN KEY (habit_id) REFERENCES habits(id)
);