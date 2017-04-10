require "bundler/setup"
require "rhust"

r = Rhust::Rhust.new
puts r.get
r.incr
puts r.get
