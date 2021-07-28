class RemoveStartTimeFromRequests < ActiveRecord::Migration[6.1]
  def change
    change_table :requests do |t|
      t.remove :start_time
    end
  end
end
