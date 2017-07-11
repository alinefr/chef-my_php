#
# Cookbook:: my_php
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'chef_nginx::default'
include_recipe 'php-fpm::default'

node.default['php-fpm']['listen'] = '/var/run/php-fpm-www.sock'

file '/etc/nginx/sites-enabled/000-default' do
  action :delete
end

template '/etc/nginx/sites-available/my_php' do
  source 'my_php.erb'
  notifies :restart, 'service[nginx]', :delayed
end

link '/etc/nginx/sites-enabled/my_php' do
  to '/etc/nginx/sites-available/my_php'
end

directory node['nginx']['default_root'] do
  recursive true
end

file "#{node['nginx']['default_root']}/test.php" do
  content '<?php
phpinfo();'
end
