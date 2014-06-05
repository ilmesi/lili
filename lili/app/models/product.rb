class Product < ActiveRecord::Base
    validates :title, presence: true
    validates :supplier_id, presence: true
    belongs_to :supplier
    has_many :items
    has_many :orders, through: :items
end
