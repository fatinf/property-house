class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:show]

  # GET /properties or /properties.json
  def index
    @q = Property.ransack(params[:q])
    @properties = @q.result.page params[:page]
  end

  # GET /properties/1 or /properties/1.json
  def show
    @property_price = params[:property_price].to_f
    @down_payment = params[:down_payment].to_f
    @loan_period = params[:loan_period].to_f
    @interest_rate = params[:interest_rate].to_f

    interest_per_month = @interest_rate/100/12
    loan_period_month = @loan_period*12

    calc_a = interest_per_month * ((1 + interest_per_month) ** loan_period_month)
    pp "calc_a ---> #{calc_a}"
    calc_b = ((1 + interest_per_month) ** loan_period_month) - 1
    pp "calc_b ---> #{calc_b}"
    calc_c = (@property_price - @down_payment) * calc_a
    pp "calc_c ---> #{calc_c}"
    @monthly_payment = calc_c / calc_b
    pp "@monthly_payment ---> #{@monthly_payment}"
  end

  # GET /properties/new
  def new
    @property = Property.new
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties or /properties.json
  def create
    @property = Property.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to property_url(@property), notice: "Property was successfully created." }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1 or /properties/1.json
  def update
    respond_to do |format|
      if @property.update(property_params)
        format.html { redirect_to property_url(@property), notice: "Property was successfully updated." }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1 or /properties/1.json
  def destroy
    @property.destroy

    respond_to do |format|
      format.html { redirect_to properties_url, notice: "Property was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:name, :price, :size, :image_data, :image)
    end
end
