class CreateKeywords < ActiveRecord::Migration[7.2]
  def change
    create_table :keywords do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
