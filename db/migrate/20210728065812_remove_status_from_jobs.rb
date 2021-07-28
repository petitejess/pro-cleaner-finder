class RemoveStatusFromJobs < ActiveRecord::Migration[6.1]
  def change
    change_table :jobs do |t|
      t.remove :status
    end
  end
end
