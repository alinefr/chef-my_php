#
# Cookbook:: my_php
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.default['php-fpm']['listen'] = '/var/run/php-fpm-www.sock'
node.default['php-fpm']['user'] = node['nginx']['user']

include_recipe 'chef_nginx::default'
include_recipe 'php-fpm::default'


remove = %w(sites-enabled/000-default conf.d/default.conf)
remove.each do |rm|
  file "/etc/nginx/#{rm}" do
    action :delete
    notifies :reload, 'service[nginx]', :delayed
  end
end

nginx_site 'my_php' do
  template 'my_php.erb'
end

directory node['nginx']['default_root'] do
  recursive true
end

file "#{node['nginx']['default_root']}/test.php" do
  content '<?php
phpinfo();'
end
