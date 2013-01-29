$:.unshift File.expand_path("../lib", __FILE__)

require "testality/version"

Gem::Specification.new do |gem|
	gem.name = "testality"
	gem.version = Testality::VERSION
	gem.summary = "Testality"
	gem.description = "Browser script test aggregation server"
	gem.authors = ["Stuart Wakefield"]
	gem.email = ["me@stuartwakefield.co.uk"]
	gem.files = Dir["lib/**/*.rb"]
	gem.homepage = "http://stuartwakefield.co.uk/testality"
end
