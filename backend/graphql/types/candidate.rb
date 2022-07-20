# frozen_string_literal: true

require 'graphql'
require_relative 'base'

module Types
  class Contribution < Base; end

  class Candidate < Base
    description 'A candidate running for office in their home country'

    field :id,                  ID,     null: false
    field :name,                String, null: false
    field :state,               String, null: false
    field :country,             String, null: false
    field :fec_foriegn_key,     String, null: false
    field :total_outbound_contributions, Float,  null: false
    field :total_inbound_contributions,  Float,  null: false
    field :outbound_contributions,       [Types::Contribution], null: false do
      argument :first,  Integer, required: false
      argument :offset, Integer, required: false
      argument :id,     ID,      required: false
    end
    field :inbound_contributions,        [Types::Contribution], null: false do
      argument :first,  Integer, required: false
      argument :offset, Integer, required: false
      argument :id,     ID,      required: false
    end

    def outbound_contributions(first: 10, offset: 0, id: nil)
      if id
        object.outbound_contributions.where(id: id)
      else
        object.outbound_contributions.limit(first).offset(offset)
      end
    end

    def inbound_contributions(first: 10, offset: 0, id: nil)
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
