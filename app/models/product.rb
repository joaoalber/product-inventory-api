class Product < ApplicationRecord

  scope :archived, ->(archived) { where(archived: archived) }
  scope :categories, ->(categories) { where('categories @> ARRAY[?]::text[]', categories) }
  scope :price, ->(price) { where('price > ?', price) }

  def self.chain_query_scopes(args)
    return [] if args.blank?

    result = self
    args.each do |arg|
      result = result.send *arg
    end

    result
  end
end
