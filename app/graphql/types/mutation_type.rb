module Types
  class MutationType < Types::BaseObject
    field :create_product_mutation, mutation: Mutations::Products::CreateProductMutation
  end
end
