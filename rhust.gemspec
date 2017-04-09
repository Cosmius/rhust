Gem::Specification.new do |s|
  s.name        = 'rhust'
  s.version     = '0.0.0'
  s.date        = '2017-04-08'
  s.summary     = "rhust"
  s.authors     = ["Cosmia Fu"]
  s.files       = ["lib/rhust.rb", "ext/rhust/src/lib.rs", "ext/rhust/Cargo.toml"]
  s.extensions  = %w[ext/rhust/extconf.rb]
end
