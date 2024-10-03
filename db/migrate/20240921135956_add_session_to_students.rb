class AddSessionToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :session, :string
  end
end
