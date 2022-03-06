require "rails_helper"

module Queries
  module Products
    RSpec.describe ListProductQuery, type: :request do
      describe '.resolve' do
        context 'when product exists' do
          it 'list all products' do
            3.times do |product|
              Product.create(
                name: "product-#{product}",
                description: 'simple product',
                archived: false,
                price: 10.0,
                quantity: 2,
                categories: ['simple products']
              )
            end

            post '/graphql', params: { query: query }

            json = JSON.parse(response.body)
            response = json['data']['listProductQuery']

            expect(response.size).to eq(3)
          end

          it 'list products by all filters' do
            Product.create(
              name: "product",
              archived: true,
              price: 9.0,
              quantity: 1,
              categories: ['amazing products', 'beauty products']
            )
            

            post '/graphql', params: { query: filter_query(
              categories: ['amazing products'], price: 8.0, archived: true) 
            }

            puts response.body

            json = JSON.parse(response.body)
            response = json['data']['listProductQuery']

            expect(response.size).to eq(1)
            expect(response.first['name']).to eq("product")
          end
        end
      end

      private

      def query
        <<~GQL
          query {
            listProductQuery {
              id
              archived
              description
              name
            }
          }
        GQL
      end

      def filter_query(archived:, price:, categories:)
        <<~GQL
          query {
            listProductQuery(
              categories: #{categories}, archived: #{archived}, price: #{price}
            ) {
              id
              archived
              description
              name
            }
          }
        GQL
      end
    end
  end
end