class Order < ActiveRecord::Base
    has_many :items
    has_many :products, through: :items
end
