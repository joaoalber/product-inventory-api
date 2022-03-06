module Queries
  module Products
    class ListProductQuery < Queries::BaseQuery
      type [Types::ProductType], null: false

      argument :archived, Boolean, required: false
      argument :categories, [String], required: false
      argument :price, Float, required: false

      def resolve(archived: nil, categories: nil, price: nil)
        params = validate_params(
          archived: archived, categories: categories, price: price
        )

        begin
          if params.blank?
            product = Product.all
          else
            product = Product.chain_query_scopes(params.to_a)
          end
        rescue => e
          raise GraphQL::ExecutionError, e.message
        end

        product
      end

      private

      def validate_params(params)
        params.compact
      end
    end
  end
end