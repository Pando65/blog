require './server.rb'

run lambda { |env| [200, {'Content-Type'=>'text/html'}, [page.content]] }