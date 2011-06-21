guard 'bundler' do
  watch('Gemfile')
  watch('Gemfile.lock')
end

guard 'test' do
  watch(%r{^test/fixtures/articles/(.+)\.txt$})
  watch(%r{^test/fixtures/templates/(.+)$})
  watch(%r{^test/fixtures/pages/(.+)$})
  
  watch(%r{^lib/(.+)\.rb$})       { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^lib/ruby_slippers/(.+)\.rb$})  { |m| ["test/unit/#{m[1]}_test.rb", "test/integration/#{m[1]}_test.rb"] }
  watch(%r{^test/integration/.+_test\.rb$})
  watch(%r{^test/unit/.+_test\.rb$})
  watch(%r{^test/support/(.+)\.rb$})          { "test" }
end
