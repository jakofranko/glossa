Gem::Specification.new do |s|
  s.name        = 'glossa'
  s.version     = '1.1.0'
  s.date        = '2017-03-11'
  s.summary     = "A random naming language generator generator"
  s.description = "== Glossa is a tool for generating simple naming language generators (which can in turn generate names).

Note: Version 1.0.0 is an (almost) direct port of {mewo2's JavaScript naming-language generator}[https://github.com/mewo2/naming-language]. These initial ideas are his, and I have changed very little of the actual inner-workings (other than basically turn it into a class). I would _highly_ encourage everybody to go and checkout his original repo (link above), {read his documentation on how the language generator works}[http://mewo2.com/notes/naming-language/], and {follow @unchartedatlas}[https://twitter.com/unchartedatlas]"

  s.authors     = ["Jake Franklin"]
  s.email       = 'jacob.d.franklin@gmail.com'
  s.files       = ["lib/glossa.rb", "lib/glossa/language.rb", "lib/glossa/import_export.rb"]
  s.homepage    = 'http://rubygems.org/gems/glossa'
  s.license     = 'MIT'
end