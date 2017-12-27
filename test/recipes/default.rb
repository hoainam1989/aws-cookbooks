
Chef::Log.info("******Creating ENV.******")

app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}"

Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")

git app_path do
  repository app["app_source"]["url"]
  revision 'master'
  action :sync
end

cookbook_file "/tmp/install_env" do
  source "install.sh"
  owner 'root'
  group 'root'
  mode 0777
  action :create
end

execute "install_env" do
  user "root"
  command "/tmp/install_env"
end