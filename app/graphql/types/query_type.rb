module Types
  class QueryType < Types::BaseObject
    field :show_product_query, resolver: Queries::Products::ShowProductQuery
  end
end
