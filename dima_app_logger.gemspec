$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
Gem::Specification.new do |s|
    s.name        = %q{dima_app_logger}
    s.version     = "0.0.7"
    s.summary     = %q{Application logger}
    s.description = %q{Application logger}

    s.files        = Dir['[A-Z]*', 'lib/**/*.rb', 'spec/**/*.rb', 'features/**/*', 'rails/**/*']
    s.require_path = 'lib'
    s.test_files   = Dir['spec/**/*_spec.rb', 'features/**/*']

    s.has_rdoc         = true
    s.extra_rdoc_files = ["README.rdoc"]
    s.rdoc_options = ['--line-numbers', "--main", "README.rdoc"]

    s.authors = ["Dmitry Galinsky"]
    s.email   = %q{dima.exe@gmail.com}
    s.homepage = "https://github.com/dima-exe/app_logger"

    s.add_development_dependency('rspec')
    s.add_development_dependency('rr')

    s.platform = Gem::Platform::RUBY
    s.rubygems_version = %q{1.2.0}
end

