# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'oj'

def print_progress(counter, modulo: 1000)
  if (counter % modulo) == 0
    print '.'
  end
end

puts "Seeding database..."
ActiveRecord::Base.transaction do
  puts "  Clearing database..."
  ActiveRecord::Base.connection.execute("DELETE FROM data_sources")
  ActiveRecord::Base.connection.execute("DELETE FROM candidates")
  ActiveRecord::Base.connection.execute("DELETE FROM committees")
  ActiveRecord::Base.connection.execute("DELETE FROM operating_expenses")
  ActiveRecord::Base.connection.execute("DELETE FROM contributions")
  puts "  Cleared database."
  puts "  Loading data..."

  print "  Creating Data Sources"
  fec = DataSource.create!(
    name:  "OpenFEC API",
    promo: "Data provided by the OpenFEC API",
    logo:  "https://www.fec.gov/static/img/seal--inverse.svg",
    url:   "https://www.fec.gov/data/browse-data"
  )
  puts "\n    => Data Sources created"

  print "  Processing Candidates ."
  progress_counter = 0
  File.open(File.expand_path('../data/raw/fec/2022/candidates.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      Candidate.create!(name: data[1], fec_foriegn_key: data[0], party_afilliation: data[2], state: data[4], country: 'USA', data_source: fec)
      progress_counter += 1
      print_progress(progress_counter)
    end
  end
  puts "\n    => Inserted #{progress_counter} candidates\n"

  print "\n  Processing Committees ."
  progress_counter = 0
  File.open(File.expand_path('../data/raw/fec/2022/committees.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      Committee.create!(name: data[1], fec_foriegn_key: data[0], entity_type: data[8].presence || 'N/A', state: data[6].presence || 'N/A', country: 'USA', data_source: fec)
      progress_counter += 1
      print_progress(progress_counter)
    end
  end
  puts "\n    => Inserted #{progress_counter} commitees\n"

  print "\n  Processing Committee to Candidate Contributions ."
  progress_counter = 0
  File.open(File.expand_path('../data/raw/fec/2022/committee-to-candidate-contributions.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      candidate  = Candidate.find_by(fec_foriegn_key: data[16])
      committee  = Committee.find_by(fec_foriegn_key: data[0])
      donated_on = data[13].present? ? Date.strptime(data[13], '%m%d%Y') : Date.parse(data[4])
      if candidate && committee
        Contribution.create!(
          amount:      data[14].to_f,
          donated_on:  donated_on,
          destination: candidate,
          source:      committee,
          data_source: fec
        )
        progress_counter += 1
        print_progress(progress_counter)
      end
    end
  end
  puts "\n    => Inserted #{progress_counter} contributions\n"

  print "\n  Processing Committee to Committee Contributions ."
  progress_counter = 0
  insert_counter   = 0
  File.open(File.expand_path('../data/raw/fec/2022/committee-to-committee-transactions.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      source      = Committee.find_by(fec_foriegn_key: data[0])
      destination = Committee.find_by(fec_foriegn_key: data[15])
      donated_on  = data[13].present? ? Date.strptime(data[13], '%m%d%Y') : Date.parse(data[4])
      if source && destination
        Contribution.create!(
          amount:      data[14].to_f,
          donated_on:  donated_on,
          destination: destination,
          source:      source,
          data_source: fec
        )
        insert_counter += 1
      end
      progress_counter += 1
      print_progress(progress_counter)
    end
  end
  puts "\n    => Inserted #{insert_counter} contributions out of #{progress_counter}\n"

  puts "  Loaded data."
end
