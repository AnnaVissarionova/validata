require File.expand_path('lib/validata/version', __dir__)
Gem::Specification.new do |spec|
  spec.name                  = 'validata'
  spec.version               = Validata::VERSION
  spec.authors               = ['Anna Vissarionova, Daria Shuvalova']
  spec.email                 = ['a.vissarionova04@mail.ru']
  spec.summary               = 'Validate common or your own data types'
  spec.description           = 'This gem provides methods to validate emails, phone numbers, passwords, dates.It also allows to set your own data type and validating rules.'
  spec.homepage              = 'https://github.com/AnnaVissarionova/validata'
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.5.0'
  spec.files = Dir['README.md', 'LICENSE',
                 'lib/**/*.rb','lib/**/*.rake',
                 'validata.gemspec', '.github/*.md',
                 'Gemfile', 'Rakefile']
  spec.add_development_dependency 'rubocop', '~> 1.63'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.37'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'rake', '~> 12.3'
end
