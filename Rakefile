# require "bundler"
# Bundler.setup

gemspec = eval(File.read("itmsp.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["itmsp.gemspec"] do
  system "gem build itmsp.gemspec"
end