class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :event_code
      t.string :soundcloud_url
      t.timestamp :start_time
      t.timestamp :end_time

      t.timestamps
    end
  end
end
