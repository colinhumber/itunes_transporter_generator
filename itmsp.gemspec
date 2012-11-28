Gem::Specification.new do |s|
  s.name        = 'itunes_transporter_generator'
  s.version     = '0.1'
  s.date        = '2012-11-28'
  s.summary     = "iTunes Transporter Store Package Generator"
  s.description = "Builder"
  s.authors     = ["Colin Humber"]
  s.email       = 'colinhumber@gmail.com'
  s.homepage    = 'https://github.com/colinhumber/itunes_transporter_generator'
  
  s.add_dependency 'builder', '~>3.0.0'

  s.files       	= Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }  
  s.executables   	= `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths 	= ['lib']
end