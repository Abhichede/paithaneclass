class AddColumnToStudentFee < ActiveRecord::Migration[5.0]
  def change
    add_column :student_fees, :fee_structure_id, :integer
  end
end
