class CreateJoinTableGossipTags < ActiveRecord::Migration[8.1]
  def change
    create_table :join_table_gossip_tags do |t|
      t.references :gossip, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
