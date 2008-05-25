require 'rake'
require "rake/clean"
require "rake/gempackagetask"
require "rake/rdoctask"
require "rake/testtask"
require 'lib/mesabi/version'

spec = Gem::Specification.new do |s|
  s.name         = "Mesabi"
  s.version      = Mesabi::VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Dan Weinand"
  s.email        = "dan@danweinand.com"
  s.homepage     = "http://danweinand.com/projects/mesabi"
  s.summary      = "Mesabi. Lightweight gem-based web application framework."
  # s.bindir       = "bin"
  s.description  = s.summary
  # s.executables  = %w( mesabi )
  s.require_path = "lib"
  s.files        = %w( LICENSE README Rakefile ) + Dir["{docs,bin,lib}/**/*"]

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w( README LICENSE TODO )
  #s.rdoc_options     += RDOC_OPTS + ["--exclude", "^(app|uploads)"]

  # Dependencies
  s.add_dependency "rake"
  s.add_dependency "rack"
  s.add_dependency "mime-types"
  # Requirements
  s.required_ruby_version = ">= 1.8.4"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc 'Run Unit Tests'
Rake::TestTask.new('test:units') do |t|
  t.libs << "test"
  t.test_files = Dir.glob("test/units/*_test.rb")
  t.verbose = true
end