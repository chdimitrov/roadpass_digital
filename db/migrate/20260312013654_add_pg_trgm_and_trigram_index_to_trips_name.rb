class AddPgTrgmAndTrigramIndexToTripsName < ActiveRecord::Migration[8.1]
  def up
    enable_extension 'pg_trgm'
    add_index :trips, :name, using: :gin, opclass: :gin_trgm_ops, name: 'index_trips_on_name_trigram'
  end

  def down
    remove_index :trips, name: 'index_trips_on_name_trigram'
    disable_extension 'pg_trgm'
  end
end
