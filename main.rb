class Task
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String, :required => true
  property :completed_at, DateTime
  belongs_to :list
end
class List
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String, :required => true
  has n, :tasks
end
DataMapper.finalize

get('/styles.css'){ content_type 'text/css', :charset => 'utf-8' ; scss :styles }

# Index Handler
#--------------
get '/' do
  @lists = List.all(:order => [:name])
  slim :index
end


# Task Handlers
#--------------
post '/:id' do
  List.get(params[:id]).tasks.create params['task']
  redirect to('/')
end

delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect to('/')
end

get '/:task' do
  @task = params[:task].split('-').join(' ').capitalize
  slim :task
end

put '/task/:id' do
  task = Task.get params[:id]
  task.completed_at = task.completed_at.nil? ? Time.now : nil
  task.save
  redirect to('/')
end

# List Handlers
# -------------
post '/new/list' do
  List.create params['list']
  redirect to('/')
end

delete '/list:id' do
  List.get(params[:id]).destroy
  redirect to('/')
end

# Sass handler
# ------------
get '/styles.css' do
  scss :styles
end
