class AddPercentageToProducts < ActiveRecord::Migration
  def change
    add_column :products, :percentage, :decimal, :precision => 3, :scale => 2
  end
end
