require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

task :make do
	if  ENV['branch'] =~ /^(\*|\d+(\.\d+){0,2}(\.\*)?)$/	
		puts "Is a tag! So building gem ..."
		Rake::Task["build"].invoke
	else
		puts "Not a tag!"	
	end	
end

task :publish do
	if  ENV['branch'] =~ /^(\*|\d+(\.\d+){0,2}(\.\*)?)$/
		puts "Is a tag! So publishing gem to rubygems.org ..."
		arguments = ['gem', 'push', "pkg/zipMoney-${#ENV['branch']}.gem"]
        system(*arguments)
    else
		puts "Not a tag!"	
	end	
end

task :test => :spec