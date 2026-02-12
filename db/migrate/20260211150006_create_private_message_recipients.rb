class CreatePrivateMessageRecipients < ActiveRecord::Migration[8.1]
  def change
    create_table :private_message_recipients do |t|
      t.references :private_message, null: false, foreign_key: true
      t.references :recipient, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
