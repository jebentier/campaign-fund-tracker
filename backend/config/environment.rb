# frozen_string_literal: true

require 'declare_schema'

Dir[File.expand_path("./initializers/*.rb", __dir__)].each { |file| require file }
Dir[File.expand_path('../app/models/*.rb', __dir__)].each { |file| require file }
