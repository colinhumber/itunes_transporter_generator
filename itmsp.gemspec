$:.push File.expand_path("../lib", __FILE__)
require "itunes"

Gem::Specification.new do |s|
  s.name        = 'itunes_transporter_generator'
  s.version     = Itunes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "iTunes Transporter App Store Package Generator"
  s.description = "A command-line tool for generating and packaging app store assets for Game Center and In-App Purchases"
  s.authors     = ["Colin Humber"]
  s.email       = 'colinhumber@gmail.com'
  s.homepage    = 'https://github.com/colinhumber/itunes_transporter_generator'
  s.license     = 'MIT'
  
  s.add_dependency 'builder', '~>3.0.0'
  s.add_dependency 'commander', '~> 4.1.3'
  
  s.files       	  = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }  
  s.executables   	= `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths 	= ['lib']
end
