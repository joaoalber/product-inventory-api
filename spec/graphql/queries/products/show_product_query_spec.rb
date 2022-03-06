require "rails_helper"

module Queries
  module Products
    RSpec.describe ShowProductQuery, type: :request do
      describe '.resolve' do
        context 'when product exists' do
          it 'shows product properly' do
            product = Product.create(
              name: 'product',
              description: 'simple product',
              archived: false,
              price: 10.0,
              quantity: 2,
              categories: ['simple products']
            )

            post '/graphql', params: { query: query(product_id: product.id) }

            json = JSON.parse(response.body)
            response = json['data']['showProductQuery']

            expect(response['name']).to eq('product')
            expect(response['id']).to eq(product.id.to_s)
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
          query {
            showProductQuery(id: #{product_id}) {
              name
              id
            }
          }
        GQL
      end
    end
  end
end