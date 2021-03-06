# bootstrap-markdown plugin relies on rails-assets-bootstrap gem but we use
# bootstrap-sass this line makes sure we exclude every asset comming
# from rails-assets-bootstrap to prevent conflicts with bootstrap-sass
Rails.configuration.assets.paths.reject! do |path|
  path.include?("rails-assets-bootstrap") && !path.include?("rails-assets-bootstrap-markdown")
end

Diaspora::Application.configure do
  config.serve_static_files = AppConfig.environment.assets.serve?
  # config.static_cache_control = "public, max-age=3600" if AppConfig[:serve_static_assets].to_s == 'true'
end
