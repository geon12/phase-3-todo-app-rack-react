require 'pry'
require 'json'

class Application
  #shotgun -p 3000
  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)
    content_type = { 'Content-Type' => 'application/json' }
    if req.path == '/tasks' && req.get?
      tasks = Task.all.map {|task| {id: task.id, text: task.text, category: task.category.name} } 
      return [200,content_type, [ tasks.to_json ]]
    
    elsif req.path == '/tasks' && req.post?
      
      body = JSON.parse(req.body.read)
      task = Task.create(text:body["text"], category: Category.find_by(name:body["category"]))
      
      task = {id: task.id, text: task.text, category: task.category.name}
      return [
        200,
        content_type,
        [ task.to_json ]
      ]
    elsif req.path.match(/tasks/) && req.get?
      id = req.path.split('/')[2]
      task = Task.find_by_id(id)
      
      if task 
        task = {id:task.id, text: task.text, category: task.category.name}
        return [
          200,
          content_type,
          [ task.to_json ]
        ]
      else
        return [
          204,
          content_type,
          [ {}.to_json ]
        ]
      end
    
    elsif req.path.match(/tasks/) && req.patch?
      id = req.path.split('/')[2]
      task = Task.find_by_id(id)
      body = JSON.parse(req.body.read)
      if task
        task.update(body)
        task = {id:task.id,text: task.text, category: task.category}
        return [
          200,
          content_type,
          [task.to_json ]
        ]
      else
        return [
          204,
          content_type,
          [ {}.to_json ]
        ]
      end
    
    elsif req.path.match(/tasks/) && req.delete?
      id = req.path.split('/')[2]
      task = Task.find_by_id(id)

      task.destroy

      return [
        204,
        {},
        ['']
      ]

    else
      return [
        404,
        {},
        ['Page not found']
      ]

    end

    resp.finish
  end

end
