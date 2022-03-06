module Mutations
  module Products
    class DeleteProductMutation < BaseMutation
      field :product, Types::ProductType, null: false

      argument :id, Integer, required: true

      def resolve(id:)
        begin
          product = Product.destroy(id)
        rescue => e
          raise GraphQL::ExecutionError, e.message
        end

        { product: product, errors: [] }
      end
    end
  end
end
