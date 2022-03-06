module Types
  class QueryType < Types::BaseObject
    field :show_product_query, resolver: Queries::Products::ShowProductQuery
    field :list_product_query, resolver: Queries::Products::ListProductQuery
  end
end
