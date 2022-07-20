# frozen_string_literal: true

require 'active_record'
require 'active_record/database_configurations/connection_url_resolver'
require 'active_support/core_ext'
require 'erb'
require 'yaml'

# Load Database spec from config/database.yml
path   = File.expand_path('../database.yml', __dir__)
source = ERB.new(File.read(path)).result
spec   = YAML.load(source) || {}

ActiveRecord::Base.configurations = spec.stringify_keys
ActiveRecord::Base.establish_connection(ENV['SERVICE_ENV'].presence&.to_sym || :development)
