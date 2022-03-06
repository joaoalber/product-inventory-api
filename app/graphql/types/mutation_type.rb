module Types
  class MutationType < Types::BaseObject
    field :update_product_mutation, mutation: Mutations::Products::UpdateProductMutation
    field :create_product_mutation, mutation: Mutations::Products::CreateProductMutation
  end
end
