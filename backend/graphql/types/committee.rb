# frozen_string_literal: true

require 'graphql'
require_relative 'base'
require_relative 'data_source'

module Types
  class Contribution < Base; end

  class Committee < Base
    implements Types::LegalEntityInterface

    description 'Resembels a legal entitee that has committted to a candidate'

    field :entity_type,     String,            null: false
    field :fec_foriegn_key, String,            null: false
    field :data_source,     Types::DataSource, null: false
  end
end
