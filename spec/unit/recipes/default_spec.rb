#
# Cookbook:: my_php
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'my_php::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.override['nginx']['default_root'] = '/srv/www/my_php'
      end.converge(described_recipe)
    end

    before(:each) do
      pool_d = '/etc/php/7.0/fpm/pool.d'
      stub_command("test -d #{pool_d} || mkdir -p #{pool_d}").and_return(false)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes chef_nginx php-fpm cookbooks' do
      cookbks = %w(chef_nginx::default php-fpm::default)
      cookbks.each { |inc| expect(chef_run).to include_recipe(inc) }
    end

    it 'removes default nginx file' do
      remove = %w(sites/000-default conf.d/default.conf)
      remove.each { |rm| expect(chef_run).to delete_file(rm) }
    end

    it 'creates file test.php and their directory' do
      nginx_root = chef_run.node['nginx']['default_root']
      expect(chef_run).to create_directory(nginx_root)
      expect(chef_run).to create_file("#{nginx_root}/test.php")
    end
  end
end
