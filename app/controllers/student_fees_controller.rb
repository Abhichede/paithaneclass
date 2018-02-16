class StudentFeesController < ApplicationController
  before_action :set_student_fee, only: [:show, :edit, :update, :destroy]

  # GET /student_fees
  # GET /student_fees.json
  def index
    @fees = []

    FeeStructure.all.each do |fee|
      @students = Student.where("student_class = ? AND division = ?", fee.student_class, fee.section)
      allocated = 0.0
      paid = 0.0
      balance = 0.0

      @students.each do |sfee|
        allocated += sfee.allocated_fee.to_f
        paid += sfee.total_paid.to_f
        balance += (sfee.allocated_fee.to_f + sfee.total_paid.to_f)
      end

      @fees.push([structure: fee.structure, allocated: allocated, paid: paid, balance: balance])
    end
  end

  # GET /student_fees/1
  # GET /student_fees/1.json
  def show
  end

  # GET /student_fees/new
  def new
    @student_fee = StudentFee.new
    @student = Student.find(params[:student_id])
  end

  # GET /student_fees/1/edit
  def edit
    @students = Student.all
    @student = Student.find(params[:student_id])
  end

  # POST /student_fees
  # POST /student_fees.json
  def create
    @student_fee = StudentFee.new(student_fee_params)
    @student = Student.find(student_fee_params[:student_id])

    allocated_fee = @student.allocated_fee.to_f
    discount = @student.discount.to_f
    paid_fee = @student.total_paid.to_f
    balance_amount = (allocated_fee - discount) - paid_fee
    currently_paying = student_fee_params[:amount].to_f

    respond_to do |format|
      if balance_amount > 0 && currently_paying <= balance_amount
        if @student_fee.save
          @student.update(:total_paid => (paid_fee + currently_paying))
          format.html { redirect_to controller: 'students', action: 'print_receipt', id: @student_fee.id}
          format.json { render :show, status: :created, location: @student_fees }
        else
          format.html { render :new }
          format.json { render json: @student_fee.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to student_fees_path, notice: 'Amount is greater than balance amount' }
        format.json { render json: @student_fee.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /student_fees/1
  # PATCH/PUT /student_fees/1.json
  def update
    @student = Student.find(student_fee_params[:student_id])

    currently_paying = student_fee_params[:amount].to_f
    previous_amount = @student_fee.amount
    allocated_fee = @student.allocated_fee.to_f
    discount = @student.discount.to_f
    paid_fee = @student.total_paid.to_f - previous_amount
    balance_amount = (allocated_fee - discount) - paid_fee

    respond_to do |format|
      if balance_amount > 0 && currently_paying <= balance_amount
        if @student_fee.update(student_fee_params)
          @student.update(:total_paid => (paid_fee + currently_paying))
          format.html { redirect_to student_fees_path, notice: 'Student fee was successfully updated.' }
          format.json { render :show, status: :ok, location: @student_fees }
        else
          format.html { render :edit }
          format.json { render json: @student_fee.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /student_fees/1
  # DELETE /student_fees/1.json
  def destroy
    @student_fee.destroy
    respond_to do |format|
      format.html { redirect_to student_fees_url, notice: 'Student fee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_fee
      @student_fee = StudentFee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_fee_params
      params.require(:student_fee).permit(:student_id, :payment_date, :installment_no, :amount, :payment_method, :payment_desc, :paid_by, :received_by, :academic_year_id)
    end
end
