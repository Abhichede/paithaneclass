class PreStudentGarbage < ApplicationRecord
  belongs_to :academic_year
  belongs_to :student

  attr_accessor :new_student_class
  attr_accessor :new_academic_year
  attr_accessor :fee_structure_ids
end
