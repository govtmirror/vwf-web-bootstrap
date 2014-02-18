$:<< File.join(File.dirname(__FILE__), 'stack')

if !ENV['VWF_HOST'] || ENV['VWF_HOST'] == ''
  raise "Missing argument: VWF_HOST"
end

require 'essential'
require 'scm'
require 'apache'
require 'vwf'

policy :stack, :roles => :app do
  requires :webserver               # Apache or Nginx
  requires :scm                     # Git

  requires :vwf
end

deployment do
  delivery :capistrano do
    begin
      recipes 'Capfile'
    rescue LoadError
      recipes 'deploy'
    end
  end
 
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end

begin
  gem 'sprinkle', ">= 0.2.3" 
rescue Gem::LoadError
  puts "sprinkle 0.2.3 required.\n Run: `sudo gem install sprinkle`"
  exit
end