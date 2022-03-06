module Mutations
  module Products
    class BulkUpdateProductMutation < BaseMutation
      field :updated, Boolean, null: false

      argument :products, [Types::InputProductType], required: true

      def resolve(products)
        begin
          ActiveRecord::Base.transaction do
            products[:products].each do |product_attributes|
              product = Product.find(product_attributes.id)
              product.update!(product_attributes.to_hash.except(:id))
            end
          end
        rescue => e
          raise GraphQL::ExecutionError, e.message
        end

        { updated: true, errors: [] }
      end
    end
  end
end
