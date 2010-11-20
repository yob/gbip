Gem::Specification.new do |spec|
  spec.name = "gbip"
  spec.version = "0.8.3"
  spec.summary = "A library for access the globalbooksinprint.com API"
  spec.files =  Dir.glob("{examples,lib,specs}/**/**/*") +
    ["Rakefile", "CHANGELOG"]
  spec.test_files = Dir[ "spec/**/*.rb" ]
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w{README COPYING LICENSE CHANGELOG}
  spec.rdoc_options << '--title' << 'gbip Documentation' <<
  '--main'  << 'README' << '-q'
  spec.author = "James Healy"
  spec.email = "jimmy@deefa.com"
  spec.homepage = "https://github.com/yob/gbip/"
  spec.description = <<END_DESC
  gbip is a small library to interact with the
  globalbooksinprint.com API. The API is based
  on raw TCP sockets, none of this fancy HTTP stuff.
END_DESC

  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec", "~>2.1")
  spec.add_development_dependency("not_a_mock", "~>1.0.1")

  spec.add_dependency('rbook-isbn', '>= 1.0')
end
