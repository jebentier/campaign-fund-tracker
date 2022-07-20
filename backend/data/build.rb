# frozen_string_literal: true

require 'sqlite3'
require 'csv'
require 'oj'

CREATE_TABLE_CANDIDATES = <<-SQL
  CREATE TABLE candidates (id INTEGER PRIMARY KEY, name TEXT, key TEXT, party TEXT, state TEXT, country TEXT);
  CREATE UNIQUE INDEX IF NOT EXISTS candidates_key_index ON candidates (key);
SQL

CREATE_TABLE_COMMITTEES = <<-SQL
  CREATE TABLE committees (id INTEGER PRIMARY KEY, name TEXT, key TEXT, entity_type TEXT, state TEXT, country TEXT);
  CREATE UNIQUE INDEX IF NOT EXISTS committees_key_index ON committees (key);
SQL

CREATE_TABLE_INDIVIDUALS = <<-SQL
  CREATE TABLE individuals (id INTEGER PRIMARY KEY, name TEXT, key TEXT, state TEXT, country TEXT);
  CREATE UNIQUE INDEX IF NOT EXISTS individuals_key_index ON individuals (key);
SQL

CREATE_TABLE_CONTRIBUTIONS = <<-SQL
  CREATE TABLE contributions (source_type TEXT, source_key TEXT, target_type TEXT, target_key TEXT, amount REAL, date DATETIME);
SQL

CREATE_TABLE_OPERATING_EXPENSES = <<-SQL
  CREATE TABLE operating_expenses (id INTEGER PRIMARY KEY, candidate_key TEXT, name TEXT, key TEXT, state TEXT, country TEXT);
SQL

DATABASE_FILE_PATH = File.expand_path('./sqlite/2022.db', __dir__)
JSON_FILE_PATH     = File.expand_path('./json/2022.json', __dir__)

def print_progress(counter, modulo: 1000)
  if (counter % modulo) == 0
    print '.'
  end
end

def build_sqlite_database
  File.delete(DATABASE_FILE_PATH) if File.exist?(DATABASE_FILE_PATH)
  db = SQLite3::Database.new(DATABASE_FILE_PATH)
  db.execute(CREATE_TABLE_CANDIDATES)
  db.execute(CREATE_TABLE_COMMITTEES)
  db.execute(CREATE_TABLE_INDIVIDUALS)
  db.execute(CREATE_TABLE_CONTRIBUTIONS)

  print "Processing Candidates ."
  progress_counter = 0
  File.open(File.expand_path('./raw/fec/2022/candidates.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      db.execute('INSERT INTO candidates (name, key, party, state, country) VALUES (?, ?, ?, ?, ?)', data[1], data[0], data[2], data[4], 'USA')
      progress_counter += 1
      print_progress(progress_counter)
    end
  end
  puts "\n=> Inserted #{db.last_insert_row_id} candidates\n"

  print "\nProcessing Committees ."
  progress_counter = 0
  File.open(File.expand_path('./raw/fec/2022/committees.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      db.execute('INSERT OR IGNORE INTO committees (name, key, entity_type, state, country) VALUES (?, ?, ?, ?, ?)', data[1], data[0], data[8], data[5], 'USA')
      progress_counter += 1
      print_progress(progress_counter)
    end
  end
  puts "\n=> Inserted #{db.last_insert_row_id} commitees\n"

  print "\nProcessing Committee to Candidate Contributions ."
  progress_counter = 0
  File.open(File.expand_path('./raw/fec/2022/committee-to-candidate-contributions.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      db.execute('INSERT INTO contributions (source_type, source_key, target_type, target_key, amount, date) VALUES (?, ?, ?, ?, ?, ?)', 'committee', data[0], 'candidate', data[16], data[14], data[4])
      progress_counter += 1
      print_progress(progress_counter)
    end
  end
  puts "\n=> Inserted #{db.last_insert_row_id} contributions\n"

  print "\nProcessing Committee to Committee Contributions ."
  progress_counter = 0
  File.open(File.expand_path('./raw/fec/2022/committee-to-committee-transactions.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      db.execute('INSERT INTO contributions (source_type, source_key, target_type, target_key, amount, date) VALUES (?, ?, ?, ?, ?, ?)', 'committee', data[0], 'committee', data[15], data[14], data[13])
      progress_counter += 1
      print_progress(progress_counter)
    end
  end
  puts "\n=> Inserted #{db.last_insert_row_id} contributions\n"

  db.close
end

build_sqlite_database
