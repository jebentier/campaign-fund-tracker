# frozen_string_literal: true

require 'graphql'

module Types
  class Base < GraphQL::Schema::Object; end
  class Contribution < Base; end

  module LegalEntityInterface
    include GraphQL::Schema::Interface
    include GraphQL::Types::Relay::Node

    field :name,    String, null: false
    field :type,    String, null: false
    field :state,   String, null: false
    field :country, String, null: false

    field :total_outbound_contributions, Float, null: false
    field :total_inbound_contributions,  Float, null: false

    field :outbound_contributions, Types::Contribution.connection_type, null: false
    field :inbound_contributions,  Types::Contribution.connection_type, null: false

    def type
      object.class.name
    end

    def outbound_contributions
      object.outbound_contributions.group(:destination_type, :destination_id).select('*, sum(amount) as amount').order(amount: :desc)
    end

    def inbound_contributions
      object.inbound_contributions.group(:source_type, :source_id).select('*, sum(amount) as amount').order(amount: :desc)
    end

    def total_outbound_contributions
      object.outbound_contributions.sum(:amount)
    end

    def total_inbound_contributions
      object.inbound_contributions.sum(:amount)
    end
  end
end
