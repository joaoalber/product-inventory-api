# frozen_string_literal: true

module Types
  class InputProductType < Types::BaseInputObject
    argument :id, Integer, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :archived, Boolean, required: false
    argument :price, Integer, required: false
    argument :quantity, Integer, required: false
    argument :categories, [String], required: false
  end
end