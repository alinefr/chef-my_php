#
# Cookbook:: my_php
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'my_php::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node, server|
        node.override['nginx']['default_root'] = '/srv/www/my_php'
      end
      runner.converge(described_recipe)
    end

    before(:each) do
      stub_command("test -d /etc/php/7.0/fpm/pool.d || mkdir -p /etc/php/7.0/fpm/pool.d").and_return(false)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes chef_nginx cookbook' do
      expect(chef_run).to include_recipe('chef_nginx::default')
    end
    
    it 'includes php-fpm cookbook' do
      expect(chef_run).to include_recipe('php-fpm::default')
    end

    it 'removes default nginx file' do
      expect(chef_run).to delete_file('/etc/nginx/sites-enabled/000-default')
    end

    it 'renders nginx config' do
      expect(chef_run).to render_file('/etc/nginx/sites-available/my_php')
    end

    it 'creates symlink to sites-enabled' do
      resource = chef_run.link('/etc/nginx/sites-enabled/my_php')
      expect(resource).to link_to('/etc/nginx/sites-available/my_php')
    end

    it 'creates nginx root directory' do
      expect(chef_run).to create_directory(chef_run.node['nginx']['default_root'])
    end

    it 'creates file test.php' do
      expect(chef_run).to create_file("#{chef_run.node['nginx']['default_root']}/test.php")
    end
  end
end
