class ProductsController < ApplicationController

	def index
		priciest_products = Product.order(:price).limit(10)

		@products  = priciest_products.includes(:user)
		@sum_price = priciest_products.sum(:price).to_f

		products_ary = @products.map { |product| [product.name, product.price/@sum_price] }

		@products_ary = products_ary.to_json
	end

	def create
		@product = Product.new(params[:product])

		respond_to do |format|
  		if @product.save
   		 format.html { render :action => "create" }
   		 format.json { render :json => @product }
 			else
    		 format.html { render :action => "new" }
  		 format.json { render :json => @product.errors, :status => :unprocessable_entity }
 			end
		end
	end

	def new
		@product = Product.new
	end

	def show
 		@product = Product.where(:id => params[:id]).first
	end

	def edit
 		@product = Product.where(:id => params[:id]).first
	end

	def update
  	@product = Product.where(:id => params[:id]).first

 		respond_to do |format|
      if @product.update_attributes(params[:product])
    		format.html { redirect_to :back, :notice => 'Product was successfully updated.' }
    		format.json { render json: @product }
      else
      	format.html { render action: "edit" }
      	format.json { render json: @product.errors, :status => :unprocessable_entity }
      end
  	end
	end

	def destroy
 		@product = Product.where(:id => params[:id]).first
		@product.destroy

		respond_to do |format|
  		format.html { redirect_to products_url }
  		format.json { head :no_content }
		end
	end
end
