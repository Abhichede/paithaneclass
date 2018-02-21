class Student < ApplicationRecord
  has_many :student_fees
  belongs_to :academic_year
  has_many :pre_student_garbages
  has_and_belongs_to_many :fee_structures

  mount_uploader :profile_photo, StudentProfileUploader
end
