
Chef::Log.info("******Creating ENV.******")
# show app information
app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}"
run_as = "#{node['my_app']['nodejsapp']['runas']}"
env = "#{node['test']['ENV']}"

Chef::Log.info("********** The app's ENV is '#{env}' **********")
Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")
Chef::Log.info("********** The app's runas is '#{run_as}' **********")
Chef::Log.info("********** The app's user is '#{node['deploy']['nodejsapp']['user']}' **********")

# Clone code
git app_path do
  repository app["app_source"]["url"]
  revision 'master'
  action :sync
end

# Prepare Env node
cookbook_file "/tmp/install_env" do
  source "install.sh"
  owner 'root'
  group 'root'
  mode 0777
  action :create
end

# Install Env
execute "install_env" do
  user "root"
  command "/tmp/install_env"
end

# Install App and Start App
template  "#{app_path}/config/#{env}.json" do
  source "config.json.erb"
  owner "#{run_as}"
  group "#{run_as}"
  mode 0600
end