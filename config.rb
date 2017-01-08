page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :blog do |blog|
  blog.prefix = 'blog'
  blog.layout = 'article_layout'

  # TODO template for article command (https://github.com/middleman/middleman/issues/1708)
  # blog.new_article_template = ''
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'

  # Enable pagination
  blog.paginate = true
  blog.per_page = 25
  blog.page_link = 'page/{num}'
end

activate :directory_indexes

activate :syntax, :line_numbers => true
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

activate :google_analytics do |ga|
    ga.tracking_id = 'UA-2474105-1'
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript
end

after_build do |builder|
  src = File.join(config[:source], 'CNAME')
  dst = File.join(config[:build_dir], 'CNAME')
  builder.thor.source_paths << File.dirname(__FILE__)
  builder.thor.copy_file(src, dst)
end

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end
