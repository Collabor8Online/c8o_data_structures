ignore(/bin/, /spec\/test_app\/storage/, /spec\/test_app\/tmp/, /spec\/test_app\/public/, /spec\/test_app\/log/, /spec\/test_app\/bin/)

group :development do
  guard :rspec, cmd: "bundle exec rspec" do
    watch(%r{^spec/.+_spec\.rb$}) { "spec" }
    watch(%r{^lib/(.+)\.rb$})
    watch(%r{^app/(.+)\.rb$})
  end

  guard :bundler do
    require "guard/bundler"
    require "guard/bundler/verify"
    helper = Guard::Bundler::Verify.new

    files = ["Gemfile"]
    files += Dir["*.gemspec"] if files.any? { |f| helper.uses_gemspec?(f) }

    # Assume files are symlinked from somewhere
    files.each { |file| watch(helper.real_path(file)) }
  end
end

guard :standardrb, fix: true, all_on_start: true, progress: true do
  watch(/.+\.rb$/)
end
