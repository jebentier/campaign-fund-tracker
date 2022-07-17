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

    field :total_outbound_contributions, Float,  null: false
    field :total_inbound_contributions,  Float,  null: false
    field :outbound_contributions,       [Types::Contribution], null: false do
      argument :first,  Integer, required: false, default_value: 10
      argument :offset, Integer, required: false, default_value: 0
      argument :id,     ID,      required: false, default_value: nil
    end
    field :inbound_contributions,        [Types::Contribution], null: false do
      argument :first,  Integer, required: false, default_value: 10
      argument :offset, Integer, required: false, default_value: 0
      argument :id,     ID,      required: false, default_value: nil
    end

    def outbound_contributions(first:, offset:, id:)
      if id
        object.outbound_contributions.where(id: id)
      else
        object.outbound_contributions.limit(first).offset(offset)
      end
    end

    def inbound_contributions(first:, offset:, id:)
      if id
        object.outbound_contributions.where(id: id)
      else
        object.outbound_contributions.limit(first).offset(offset)
      end
    end

    def total_outbound_contributions
      object.outbound_contributions.sum(:amount)
    end

    def total_inbound_contributions
      object.inbound_contributions.sum(:amount)
    end
  end
end
