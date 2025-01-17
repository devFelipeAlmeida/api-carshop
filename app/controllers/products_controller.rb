class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show update destroy ]
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :authorize_admin, only: [:create]

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    @product.user = current_user
  
    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!
  end

  def search
    @products = Product.search(params[:query])
    render json: @products
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def authorize_admin
      unless current_user&.admin?
        render json: { error: 'Acesso não autorizado' }, status: :forbidden
      end
    end

    def product_params
      params.require(:product).permit(:name, :description, :price)
    end
end
