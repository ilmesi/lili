class SuppliersController < ApplicationController
    def new
        @supplier = Supplier.new
    end

    def index
        @suppliers = Supplier.all
    end

    def show
        @supplier = Supplier.find(params[:id])
    end

    def edit
        @supplier = Supplier.find(params[:id])
    end

    def update
        @supplier = Supplier.find(params[:id])

        if @supplier.update(supplier_params)
            redirect_to @supplier
        else
            render 'edit'
        end
    end

    def destroy
        @supplier = Supplier.find(params[:id])
        @supplier.destroy

        redirect_to suppliers_path
    end

    def create
        @supplier = Supplier.new(supplier_params)

        if @supplier.save
            redirect_to @supplier
        else
            render 'new'
        end
    end

    private
    def supplier_params
        params.require(:supplier).permit(:name, :phone)
    end
end
