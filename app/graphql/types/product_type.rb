# frozen_string_literal: true

module Types
  class ProductType < Types::BaseObject
    field :id, ID
    field :name, String
    field :description, String
    field :archived, Boolean
    field :price, Float
    field :quantity, Integer
    field :categories, [String]
    field :created_at, GraphQL::Types::ISO8601DateTime
    field :updated_at, GraphQL::Types::ISO8601DateTime
  end
end
