# frozen_string_literal: true

require 'graphql'
require_relative 'base'
require_relative 'data_source'

module Types
  class Contribution < Base; end

  class Candidate < Base
    implements Types::LegalEntityInterface

    description 'A candidate running for office in their home country'

    field :fec_foriegn_key, String,            null: false
    field :data_source,     Types::DataSource, null: false
  end
end
