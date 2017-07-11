# # encoding: utf-8

# Inspec test for recipe my_php::default

describe package('nginx') do
  it { should be_installed }
end

describe package('php7.0-fpm') do
  it { should be_installed }
end

describe file('/etc/nginx/sites-enabled/default') do
  it { should_not exist }
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
