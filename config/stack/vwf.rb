def mkdir_and_chown(path, user)
  runner "mkdir -p #{path}"
  runner "chown #{user} #{path}"
end

package :vwf do
  user_name = 'vwf'
  app_name = 'vwf-web'
  host_name = ENV['VWF_HOST']
  app_path = "/var/www/#{app_name}"
  current_path = "#{app_path}/current"
  shared_path = "#{app_path}/shared"
  public_path = "#{current_path}/_site"
  locals = {
    :user_name => user_name,
    :host_name => host_name,
    :host_name_escaped => host_name.gsub('.', '\.'),
    :app_name => app_name,
    :public_path => public_path
  }

  # Directory structure
  mkdir_and_chown(app_path, user_name)
  mkdir_and_chown(shared_path, user_name)
  mkdir_and_chown("#{shared_path}/config", user_name)
  mkdir_and_chown(current_path, user_name)
  mkdir_and_chown("#{current_path}/_site", user_name)

  # Apache virtual host

  # Remove the default Apache config
  runner "rm -f /etc/apache2/sites-enabled/000-default"

  # Install Apache config for VWF Web
  requires :apache
  remote_file = "/etc/apache2/sites-enabled/001-#{app_name}"
  local_template = File.join(File.dirname(__FILE__), app_name, "001-#{app_name}.erb")
  puts "Creating Apache config: #{remote_file}"
  file remote_file,
    :contents => render(local_template, locals),
    :sudo => true do
    post :install, '/etc/init.d/apache2 restart'  
  end

  # Do a Git pull of the vwf-web repo
  # Put it in #{app_path}
  # Have jekyll generate the _site directory
  # BUT WE DON"T HAVE RUBY OH NOES!!
end
