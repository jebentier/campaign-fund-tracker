# frozen_string_literal: true

require 'graphql'

module Types
  class Base < GraphQL::Schema::Object; end
  class Contribution < Base; end

  module LegalEntityInterface
    include GraphQL::Schema::Interface
    include GraphQL::Types::Relay::Node

    field :name,    String, null: false
    field :state,   String, null: false
    field :country, String, null: false

    field :total_outbound_contributions, Float, null: false
    field :total_inbound_contributions,  Float, null: false

    field :outbound_contributions,       Types::Contribution.connection_type, null: false
    field :inbound_contributions,        Types::Contribution.connection_type, null: false

    def outbound_contributions
      object.outbound_contributions
    end

    def inbound_contributions
      object.inbound_contributions
    end

    def total_outbound_contributions
      object.outbound_contributions.sum(:amount)
    end

    def total_inbound_contributions
      object.inbound_contributions.sum(:amount)
    end
  end
end
