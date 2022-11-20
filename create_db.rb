require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "development.sqlite3"
)

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name

      t.timestamps
    end
  end
end

CreateItems.new.change

class Item < ActiveRecord::Base
end

30.times do |n|
  Item.create(name: "name #{n}")
end