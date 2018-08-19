class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts do |t|
      t.text :debit
      t.text :credit
      t.integer :amount
      t.text :status
      t.text :note
      t.date :deadline

      t.timestamps
    end
  end
end
