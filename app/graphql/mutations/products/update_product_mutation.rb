module Mutations
  module Products
    class UpdateProductMutation < BaseMutation
      field :product, Types::ProductType, null: false

      argument :id, Integer
      argument :name, String, required: false
      argument :description, String, required: false
      argument :archived, Boolean, required: false
      argument :price, Float, required: false
      argument :quantity, Integer, required: false
      argument :categories, [String], required: false

      def resolve(id:, name: nil, description: nil, archived: nil,
                  price: nil, quantity: nil, categories: nil)

        update_params =
          validate_params(name: name, description: description, archived: archived,
                          price: price, quantity: quantity, categories: categories)

        begin
          product = Product.find(id)
        rescue => e
          raise GraphQL::ExecutionError, e.message
        end

        if product.update(update_params)
          { product: product, errors: [] }
        else
          { product: nil, errors: product.errors.full_messages }
        end
      end

      private

      def validate_params(params)
        params.compact
      end
    end
  end
end
