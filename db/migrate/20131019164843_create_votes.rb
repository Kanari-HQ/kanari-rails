class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :vote_type
      t.references :event, index: true

      t.timestamps
    end
  end
end
