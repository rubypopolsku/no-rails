require "hanami/router"
require "active_record"
require "JSON"

require "./app/models/item.rb"
require "./app/controllers/items_controller.rb"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "development.sqlite3"
)

app = Hanami::Router.new do
  get "/items", to: ->(env) do
    ItemsController.new(env).index
  end

  get "/items/:id", to: ->(env) do
    ItemsController.new(env).show
  end

  post "/items", to: ->(env) do
    ItemsController.new(env).create
  end
    
  put "/items/:id", to: ->(env) do
    ItemsController.new(env).update
  end

  delete "/items/:id", to: ->(env) do
    ItemsController.new(env).delete
  end

  redirect "/", to: "/items"
end

run app