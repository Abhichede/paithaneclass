class AddColumnToStudentsProfilePhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :profile_photo, :string
  end
end
