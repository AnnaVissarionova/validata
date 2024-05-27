# frozen_string_literal: true

require File.expand_path("lib/validata/version", __dir__)

Gem::Specification.new do |spec|
  spec.name                  = "validata"
  spec.version               = Validata::VERSION
  spec.authors               = ["Anna Vissarionova", "Daria Shuvalova","Ruslana Zhuravleva"]
  spec.email                 = ["a.vissarionova04@mail.ru"]
  spec.summary               = "Validate common or your own data types"
  spec.description           = "This gem provides methods to validate emails, phone numbers, passwords, dates. It also allows you to set your own data type and validation rules."
  spec.homepage              = "https://github.com/AnnaVissarionova/validata"
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 3.0"
  spec.files = Dir["README.md", "LICENSE",
                   "lib/**/*.rb", "lib/**/*.rake",
                   "validata.gemspec", ".github/*.md",
                   "Gemfile", "Rakefile"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
