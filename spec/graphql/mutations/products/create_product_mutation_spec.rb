require "rails_helper"

module Mutations
  module Products
    RSpec.describe CreateProductMutation, type: :request do
      describe '.resolve' do
        it 'creates a product' do
          expect do
            post '/graphql', params: { query: query }
          end.to change { Product.count }.by(1)
        end

        it 'returns the product properly' do
          post '/graphql', params: { query: query }

          json = JSON.parse(response.body)
          data = json['data']['createProductMutation']['product']

          expect(data).to include(
            'name'         =>  "Harry Potter Book",
            'description'  =>  "A valuable book",
            'archived'     =>  false,
            'price'        =>  10.50,
            'quantity'     =>  1,
            'categories'   =>  ["Books", "Readers", "Harry Potter"]
          )
        end

        it 'does not create a product properly' do
          post '/graphql', params: { query: wrong_query }

          json = JSON.parse(response.body)
          error_message = json['errors'][0]['message']

          expect(error_message).to eq(
            "Argument 'name' on InputObject 'CreateProductMutationInput' " \
            "is required. Expected type String!"
          )
        end
      end

      private

      def query
        <<~GQL
          mutation {
            createProductMutation(input: {
              name: "Harry Potter Book",
              description: "A valuable book",
              archived: false,
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

      def wrong_query
        <<~GQL
          mutation {
            createProductMutation(input: {
              description: "A valuable book",
              archived: false,
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