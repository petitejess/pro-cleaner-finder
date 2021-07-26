class ChangeTypeToUserTypeInProfile < ActiveRecord::Migration[6.1]
  def self.up
    rename_column :profiles, :type, :user_type
  end

  def self.down
  end
end
