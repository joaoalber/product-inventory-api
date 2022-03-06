require "rails_helper"

module Mutations
  module Products
    RSpec.describe BulkUpdateProductMutation, type: :request do
      describe '.resolve' do
        context 'when products exists' do
          it 'updates all the products' do
            2.times do |product|
              Product.create(
                name: "product-#{product}",
                description: "simple product",
                archived: false,
                price: 10.0,
                quantity: 2,
                categories: ["simple products"]
              )
            end

            products = Product.all
            post '/graphql', params: { query: query(products) }

            json = JSON.parse(response.body)
            result = json['data']['bulkUpdateProductMutation']['updated']

            expect(result).to be true
          end
        end

        context 'when one of the products does not exist' do
          it 'returns an error and rollback all tried updates' do
            product = Product.create(
              name: "product",
              description: "simple product",
              archived: false,
              price: 10.0,
              quantity: 2,
              categories: ["simple products"]
            )

            post '/graphql', params: { query: wrong_query(product.id) }

            json = JSON.parse(response.body)
            error_message = json['errors'][0]['message']

            expect(error_message).to eq("Couldn't find Product with 'id'=7777")
            expect(product.reload.name).to eq("product")
          end
        end
      end

      private

      def query(products)
        <<~GQL
          mutation {
            bulkUpdateProductMutation(input: {
              products: [
                {
                  id: #{products.first.id},
                  name: "product_updated"
                },
                {
                  id: #{products.last.id},
                  name: "product_updated_2"
                }
              ]
            }) {
              updated
            }
          }
        GQL
      end

      def wrong_query(product_id)
        <<~GQL
          mutation {
            bulkUpdateProductMutation(input: {
              products: [
                {
                  id: #{product_id},
                  name: "product_updated"
                },
                {
                  id: 7777,
                  name: "product_updated_2"
                }
              ]
            }) {
              updated
            }
          }
        GQL
      end
    end
  end
end