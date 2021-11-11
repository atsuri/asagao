class CreateDuties < ActiveRecord::Migration[5.2]
  def change
    create_table :duties do |t|
      t.references :member #外部キー
      t.string :name, null: false #役職

      t.timestamps
    end
  end
end
