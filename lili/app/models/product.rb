class Product < ActiveRecord::Base
    has_many :orders
    dependent: :destroy
    validates :title, presence: true
end
