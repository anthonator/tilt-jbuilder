# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ['Anthony Smith']
  gem.email         = ['anthony@sticksnleaves.com']
  gem.description   = 'Jbuilder support for Tilt'
  gem.summary       = 'Adds support for rendering Jbuilder templates in Tilt.'
  gem.homepage      = 'https://github.com/anthonator/tilt-jbuilder'

  gem.add_dependency 'tilt', '>= 1.3.0', '< 3'
  gem.add_dependency 'jbuilder'

  gem.add_development_dependency 'bundler'

  gem.files         = `git ls-files`.split($ORS)
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.name          = 'tilt-jbuilder'
  gem.require_paths = ['lib']
  gem.version       = '0.7.1'
end
