class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :full_phone_number
      t.integer :country_code
      t.bigint :phone_number
      t.boolean :activated
      t.boolean :email_verified
      t.string :device_id
      t.text :unique_auth_id
      t.string :password_digest
      t.string :type
      t.string :user_name
      t.string :platform
      t.string :user_type
      t.integer :app_language_id
      t.datetime :last_visit_at
      t.boolean :is_blacklisted
      t.date :suspend_until
      t.integer :status
      t.integer :role_id
      t.string :full_name
      t.integer :gender
      t.date :date_of_birth
      t.integer :age
      t.string :country_name
      t.string :new_email
      t.datetime :deleted_at
      t.datetime :visit_on_account_destroy
      t.timestamps
    end
  end
end
