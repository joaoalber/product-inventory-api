module Mutations
  module Products
    class CreateProductMutation < BaseMutation
      field :product, Types::ProductType, null: false

      argument :name, String, required: true
      argument :description, String, required: false
      argument :archived, Boolean, required: true
      argument :price, Float, required: true
      argument :quantity, Integer, required: true
      argument :categories, [String], required: true

      def resolve(name:, description: nil, archived:, 
                  price:, quantity:, categories:)

        product = Product.new(name: name, description: description, archived: archived,
                              price: price, quantity: quantity, categories: categories)

        if product.save
          { product: product, errors: [] }
        else
          { product: nil, errors: product.errors.full_messages }
        end
      end
    end
  end
end
