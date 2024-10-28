require_relative "lib/data_structures/version"

Gem::Specification.new do |spec|
  spec.name        = "c8o_data_structures"
  spec.version     = DataStructures::VERSION
  spec.authors     = [ "Rahoul Baruah" ]
  spec.email       = [ "baz@collabor8online.co.uk" ]
  spec.homepage    = "https://www.collabor8online.co.uk"
  spec.summary     = "https://www.collabor8online.co.uk"
  spec.description = "https://www.collabor8online.co.uk"
  spec.license     = "LGPL"

  spec.metadata["allowed_push_host"] = "https://gems.c8online.net"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/collabor8online"
  spec.metadata["changelog_uri"] = "https://github.com/collabor8online"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.0.rc1"
end
