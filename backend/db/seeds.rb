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
  ActiveRecord::Base.connection.execute("DELETE FROM candidates")
  ActiveRecord::Base.connection.execute("DELETE FROM committees")
  ActiveRecord::Base.connection.execute("DELETE FROM operating_expenses")
  ActiveRecord::Base.connection.execute("DELETE FROM contributions")
  puts "  Cleared database."
  puts "  Loading data..."

  print "  Processing Candidates ."
  progress_counter = 0
  File.open(File.expand_path('../data/raw/fec/2022/candidates.csv', __dir__), 'r') do |file|
    file.each_line do |line|
      data = line.split('|')
      Candidate.create!(name: data[1], fec_foriegn_key: data[0], party_afilliation: data[2], state: data[4], country: 'USA')
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
      Committee.create!(name: data[1], fec_foriegn_key: data[0], entity_type: data[8].presence || 'N/A', state: data[5].presence || 'N/A', country: 'USA')
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
      candidate = Candidate.find_by(fec_foriegn_key: data[16])
      committee = Committee.find_by!(fec_foriegn_key: data[0])
      if candidate && committee
        Contribution.create!(
          amount:      data[14].to_f,
          donated_on:  Date.parse(data[4]),
          destination: candidate,
          source:      committee
        )
        progress_counter += 1
        print_progress(progress_counter)
      end
    end
  end
  puts "\n    => Inserted #{progress_counter} contributions\n"

  puts "  Loaded data."
end
