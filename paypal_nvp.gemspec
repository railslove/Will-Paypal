# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{paypal_nvp}
  s.version = "0.2.0"
  s.platform    = Gem::Platform::RUBY
  
  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Olivier BONNAURE - Direct Interactive LLC"]
  
  s.description = %q{Paypal NVP API Class.}
  s.email = %q{o.bonnaure@directinteractive.com}
  s.extra_rdoc_files = ["lib/paypal_nvp.rb", "README.rdoc"]
  s.files = ["init.rb", "lib/paypal_nvp.rb", "Manifest", "Rakefile", "README.rdoc", "paypal_nvp.gemspec"]
  s.homepage = %q{http://github.com/solisoft/paypal_nvp}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Paypal_nvp", "--main", "README.rdoc"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{paypal_nvp}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Paypal NVP API Class.}
  
  s.add_development_dependency "rspec", "~> 2.6.0"
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end


# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "payango_helpers/version"

Gem::Specification.new do |s|
  s.name        = "payango_helpers"
  s.version     = PayangoHelpers::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Red Davis"]
  s.email       = ["red@railslove.com"]
  s.homepage    = ""
  s.summary     = %q{Payango code helpers}
  s.description = %q{Payango code helpers for code that we use in multiple module}

  s.rubyforge_project = "payango_helpers"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "thor"
  s.add_dependency "activerecord", "3.0.6"
  s.add_dependency "activesupport"
  s.add_dependency "factory_girl"
  s.add_dependency "faker"
  s.add_dependency "uuidtools"
end
