# frozen_string_literal: true

require 'graphql'
require 'oj'
require_relative 'base'

module Types
  class DataSource < Base
    description 'The source of the data provided by our system'

    field :name,     String, null: false
    field :promo,    String, null: false
    field :logo,     String, null: false
    field :url,      String, null: false
    field :metadata, String, null: false

    def metadata
      Oj.dump(object.metadata)
    end
  end
end
