# # encoding: utf-8

# Inspec test for recipe my_php::default

case os[:family]
when 'redhat'
  package = 'php-fpm'
when 'debian'
  package = 'php7.0-fpm'
end

describe package('nginx') do
  it { should be_installed }
end

describe package(package) do
  it { should be_installed }
end

remove = %w(sites/000-default conf.d/default.conf)
remove.each do |rm|
  describe file(rm) do
    it { should_not exist }
  end
end

describe file('/etc/nginx/sites-available/my_php') do
  it { should exist }
end

describe file('/etc/nginx/sites-enabled/my_php') do
  it { should be_symlink }
end

describe port(80) do
  it { should be_listening }
end

describe command('curl http://localhost/test.php') do
  its('stdout') { should match (/phpinfo()/) }
end
