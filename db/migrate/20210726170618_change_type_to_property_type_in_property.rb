class ChangeTypeToPropertyTypeInProperty < ActiveRecord::Migration[6.1]
  def self.up
    rename_column :properties, :type, :property_type
  end

  def self.down
  end
end
