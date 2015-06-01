require 'sinatra'
require 'erb'
require 'github/markup'

class Post
    attr_accessor :path, :title, :id
    def initialize(path, title, id)
        @path = path
        @title = title
        @id = id
    end
    
    def render
        ERB.new(File.read('./views/post.erb')).result(binding)        
    end
    
    def content
        render do
            GitHub::Markup.render(@path, File.read(@path))
        end
    end    
end

posts = []

cont_id = 0
Dir["./posts/*.markdown"].each { |post|
    title = post.partition('-').last.gsub("-", " ").partition('.').first
    new_post = Post.new(post, title, cont_id)
    cont_id += 1
    posts << new_post
}

class Blog
    INDEX_PATH = './views/index.markdown'
    
    attr_accessor :posts
    
    def initialize(posts)
        @posts = posts
    end
    
    def render
        ERB.new(File.read('./views/layout.erb')).result(binding)
    end
    
    def content
        render do
            GitHub::Markup.render('index.markdown', File.read(INDEX_PATH))
        end
    end
        
end

page = Blog.new(posts)
get '/' do
    page.content
end

get '/post/:id' do
    p_id = params['id']
    puts p_id
    page.posts[p_id.to_i].content
end