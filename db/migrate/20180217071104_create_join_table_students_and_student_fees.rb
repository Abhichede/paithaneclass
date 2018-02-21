class CreateJoinTableStudentsAndStudentFees < ActiveRecord::Migration[5.0]
  def change
    # create_join_table :students, :fee_structures do |t|
    #   t.index [:student_id, :fee_structure_id]
    #   t.index [:fee_structure_id, :student_id]
    # end

    create_table :fee_structures_students do |t|
      t.belongs_to :student
      t.belongs_to :fee_structure

      t.timestamps
    end

    add_index :fee_structures_students, :student_id, name: "student_id"
    add_index :fee_structures_students, :fee_structure_id, name: "fee_id"
  end
end
