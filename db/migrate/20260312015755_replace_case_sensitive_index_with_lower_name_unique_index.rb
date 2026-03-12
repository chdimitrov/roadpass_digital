class ReplaceCaseSensitiveIndexWithLowerNameUniqueIndex < ActiveRecord::Migration[8.1]
  def up
    remove_index :trips, name: 'index_trips_on_name'
    add_index :trips, :name, name: 'index_trips_on_name'
    add_index :trips, 'LOWER(name)', unique: true, name: 'index_trips_on_lower_name'
  end

  def down
    remove_index :trips, name: 'index_trips_on_lower_name'
    remove_index :trips, name: 'index_trips_on_name'
    add_index :trips, :name, unique: true, name: 'index_trips_on_name'
  end
end
