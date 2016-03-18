page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = 'blog'
  blog.layout = 'article_layout'

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  # TODO template for article command (https://github.com/middleman/middleman/issues/1708)
  # blog.new_article_template = ''
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'

  # Enable pagination
  blog.paginate = true
  blog.per_page = 25
  blog.page_link = 'page/{num}'
end

page '/feed.xml', layout: false

activate :directory_indexes

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
