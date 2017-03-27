spec = Gem::Specification.new do |s|
  s.name              = "songkick-oauth2-provider"
  s.version           = "0.10.2.1"
  s.summary           = "Simple OAuth 2.0 provider toolkit"
  s.author            = "James Coglan"
  s.email             = "james@songkick.com"
  s.homepage          = "http://github.com/songkick/oauth2-provider"

  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)

  s.files             = %w(History.txt README.rdoc) + Dir.glob("{example,lib,spec}/**/*.{css,erb,rb,rdoc,ru}")
  s.require_paths     = ["lib"]

  s.add_dependency("activerecord")
  s.add_dependency("bcrypt-ruby")
  s.add_dependency("json")
  s.add_dependency("rack")
end
