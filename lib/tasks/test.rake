require 'rake/testtask'
namespace :test do
  TEST_TYPES = %w(unit integration)
  TEST_TYPES.each do |type|
    Rake::TestTask.new(type) do |test|
      test.libs << 'lib' << 'test'
      test.pattern = "test/#{type}/*_test.rb"
      test.verbose = true
    end
  end
  
  Rake::TestTask.new(:all) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
end