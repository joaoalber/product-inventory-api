module Queries
  module Products
    class ShowProductQuery < Queries::BaseQuery
      type Types::ProductType, null: false

      argument :id, Integer, required: true

      def resolve(id:)
        begin
          product = Product.find(id)
        rescue => e
          raise GraphQL::ExecutionError, e.message
        end

        product
      end
    end
  end
end