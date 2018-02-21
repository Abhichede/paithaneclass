class StudentFee < ApplicationRecord
  belongs_to :student
  belongs_to :fee_structure
end
