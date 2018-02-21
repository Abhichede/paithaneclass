class FeeStructure < ApplicationRecord
  has_and_belongs_to_many :students
  has_many :student_fees

  def structure
    "#{student_class} - #{section}"
  end
end
