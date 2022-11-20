require "hanami/router"
require "active_record"
require "JSON"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "development.sqlite3"
)

class Item < ActiveRecord::Base
end

app = Hanami::Router.new do
  get "/items", to: ->(env) { [200, {}, [Item.all.to_json]]}

  get "/items/:id", to: ->(env) do
    begin
      item = Item.find(env["router.params"][:id].to_i)
      [200, {}, [item.to_json]]
    rescue
      [404, {}, ["no item found"]]
    end
  end

  post "/items", to: ->(env) do
    params = Rack::Request.new(env).params
    begin
      item = Item.create(params)

      [201, {}, [item.to_json]]
    rescue => error
      [422, {}, [error.to_json]]
    end
  end
    
  put "/items/:id", to: ->(env) do
    begin
      params = Rack::Request.new(env).params
      item = Item.find(env["router.params"][:id].to_i)
      item.update(params)

      [200, {}, [item.to_json]]
    rescue ActiveRecord::RecordNotFound
      [404, {}, ["no item found"]]
    rescue => error
      [422, {}, [error.to_json]]
    end
  end

  delete "/items/:id", to: ->(env) do
    item = Item.find(env["router.params"][:id].to_i)
    item.delete

    [204, {}, []]
  rescue ActiveRecord::RecordNotFound
    [404, {}, ["no item found"]]
  rescue => error
    [422, {}, [error.to_json]]
  end

  redirect "/", to: "/items"
end

run app