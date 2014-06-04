class OrdersController < ApplicationController
    def create
        @product = Product.find(params[:product_id])
        @order = @product.orders.create()
        redirect_to product_path(@product)
    end
end
