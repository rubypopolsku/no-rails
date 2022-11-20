class ItemsController
  attr_reader :env

  def initialize(env)
    @env = env
  end

  def index
    [200, {}, [Item.all.to_json]]
  end

  def show 
    begin
      item = Item.find(env["router.params"][:id].to_i)
      [200, {}, [item.to_json]]
    rescue
      [404, {}, ["no item found"]]
    end
  end

  def create
    params = Rack::Request.new(env).params
    begin
      item = Item.create(params)

      [201, {}, [item.to_json]]
    rescue => error
      [422, {}, [error.to_json]]
    end
  end

  def update
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

  def delete
    item = Item.find(env["router.params"][:id].to_i)
    item.delete

    [204, {}, []]
  rescue ActiveRecord::RecordNotFound
    [404, {}, ["no item found"]]
  rescue => error
    [422, {}, [error.to_json]]
  end
end