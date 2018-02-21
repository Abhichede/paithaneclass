class CreateJoinTableStudentsAndStudentFees < ActiveRecord::Migration[5.0]
  def change
    create_join_table :students, :fee_structures do |t|
      t.index [:student_id, :fee_structure_id]
      t.index [:fee_structure_id, :student_id]
    end
  end
end
