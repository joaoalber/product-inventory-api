require "rails_helper"

module Mutations
  module Products
    RSpec.describe UpdateProductMutation, type: :request do
      describe '.resolve' do
        context 'when product exists' do
          it 'updates a product' do
            product = Product.create(
              name: "product",
              description: "simple product",
              archived: false,
              price: 10.0,
              quantity: 2,
              categories: ["simple products"]
            )

            post '/graphql', params: { query: query(product_id: product.id) }
            product = product.reload

            expect(product.name).to eq("Harry Potter Book")
            expect(product.description).to eq("A valuable book")
            expect(product.archived).to eq(true)
            expect(product.price).to eq(10.50)
            expect(product.quantity).to eq(1)
            expect(product.categories).to eq(["Books", "Readers", "Harry Potter"])
          end
        end

        context 'when product does not exist' do
          it 'returns an error' do
            post '/graphql', params: { query: query(product_id: 777) }

            json = JSON.parse(response.body)
            error_message = json['errors'][0]['message']

            expect(error_message).to eq("Couldn't find Product with 'id'=777")
          end
        end
      end

      private

      def query(product_id:)
        <<~GQL
          mutation {
            updateProductMutation(input: {
              id: #{product_id},
              name: "Harry Potter Book",
              description: "A valuable book",
              archived: true,
              price: 10.50,
              quantity: 1,
              categories: ["Books", "Readers", "Harry Potter"]
            }) {
              product {
                name
                description
                archived
                price
                quantity
                categories
              }
            }
          }
        GQL
      end
    end
  end
end