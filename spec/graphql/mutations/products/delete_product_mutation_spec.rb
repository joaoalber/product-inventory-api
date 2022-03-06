require "rails_helper"

module Mutations
  module Products
    RSpec.describe DeleteProductMutation, type: :request do
      describe '.resolve' do
        context 'when product exists' do
          it 'deletes the product' do
            product = Product.create(
              name: "product",
              description: "simple product",
              archived: false,
              price: 10.0,
              quantity: 2,
              categories: ["simple products"]
            )

            post '/graphql', params: { query: query(product_id: product.id) }
            deleted_product = Product.find_by(id: product.id)

            expect(deleted_product).to be_nil
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
            deleteProductMutation(input: {
              id: #{product_id}
            }) {
              product {
                name
                id
              }
            }
          }
        GQL
      end
    end
  end
end