class AddStartTimeToRequests < ActiveRecord::Migration[6.1]
  def change
    change_table :requests do |t|
      t.time :start_time
    end
  end
end
