class Product < ActiveRecord::Base
    validates :title, presence: true
    has_many :items
    has_many :orders, through: :items
end
