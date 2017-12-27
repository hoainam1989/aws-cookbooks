
Chef::Log.info("******Creating ENV.******")

cookbook_file "/tmp/install_env" do
  source "install.sh"
  owner 'root'
  group 'root'
  mode 0777
  action :create_if_missing
end