# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{will_paypal}
  s.version = "0.1.1"
  s.platform    = Gem::Platform::RUBY

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bumann - Railslove", "Jan Kus - Railslove"]
  s.description = %q{Paypal NVP API Class.}
  s.email = ["michael@railslove.com", "jan@railslove.com"]
  s.extra_rdoc_files = ["lib/will_paypal.rb", "README.rdoc"]
  s.files = ["init.rb", "lib/will_paypal.rb", "Manifest", "Rakefile", "README.rdoc", "will_paypal.gemspec"]
  s.homepage = %q{https://github.com/railslove/Will-Paypal}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Will_Paypal", "--main", "README.rdoc"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{will_paypal}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Paypal NVP API Class.}

  s.add_development_dependency "rspec", "~> 2.6.0"
  s.add_development_dependency "fakeweb"

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end