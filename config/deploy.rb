role :app, ENV['VWF_HOST']
set :user, "vwf"

default_run_options[:pty] = true