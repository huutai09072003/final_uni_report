class CreateJoinTableFacilitiesSections < ActiveRecord::Migration[7.2]
  def change
    create_join_table :facilities, :sections do |t|
      t.index [:facility_id, :section_id]
      t.index [:section_id, :facility_id]
    end
  end
end
