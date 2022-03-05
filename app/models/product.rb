class Product < ApplicationRecord
  serialize :categories, Array
end
