Gem::Specification.new do |s|
  s.name     = 'infer'
  s.version  = '0.0.0'
  s.summary  = 'An ad-hoc informally specified bug-ridden slow version of half of Prolog'
  s.author   = 'James Coglan'
  s.email    = 'jcoglan@gmail.com'
  s.homepage = 'https://github.com/jcoglan/infer'
  s.license  = 'GPL-3.0'

  s.extra_rdoc_files = %w[README.md]
  s.rdoc_options     = %w[--main README.md --markup markdown]
  s.require_paths    = %w[lib]

  s.files = %w[LICENSE.md README.md] +
            %w[bin/infer] +
            Dir.glob('{lib,tapl}/**/*.{md,rb}')

  s.executables = %w[infer]
end
