#
# Cookbook Name:: motd
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#
include_recipe 'motd::console'

secpkg = ''
motd_file = '/etc/motd'

case node['platform_family'].to_s
when 'rhel'
  case node['platform_version'].to_i
  when 6
    secpkg = 'yum-plugin-security'
  when 5
    secpkg = 'yum-security'
  end

  rpmquery = Mixlib::ShellOut.new('rpm -qi basesystem')
  rpmquery.run_command
  rpmquery_matched = rpmquery.stdout.match(/Install\s*Date.*/i).to_s
  built = rpmquery_matched.gsub!(/.*Install\s*Date\W*((\S+\s?)+).*/i, '\1')
  node.default['dsw']['built'] = built
when 'debian'
  motd_file = '/etc/motd.dsw'
  template '/etc/update-motd.d/00-dsw_header' do
    source '00-dsw_header.erb'
    owner 'root'
    group 'root'
    mode 00755
  end
end

package secpkg do
  action :install
  only_if { secpkg != '' }
end

motd_ohai = {
  manufacturer: '',
  product_name: '',
  serial_number: ''
}
if !node['dmi'].nil? && !node['dmi']['system'].nil?
  dmi = node['dmi']['system'] ? node['dmi']['system'] : {}
  motd_ohai = {
    manufacturer: dmi['manufacturer'].nil? ? '' : dmi['manufacturer'],
    product_name: dmi['product_name'].nil? ? '' : dmi['product_name'],
    serial_number: dmi['serial_number'].nil? ? '' : dmi['serial_number']
  }
  puts motd_ohai
end
randy = rand(node['motd']['flavor'].length)
header = "#{node['motd']['company']}  - #{node['motd']['flavor'][randy]}"

template motd_file do
  source 'motd.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables(
    motd: node['motd'],
    header: header,
    dsw: node['dsw'],
    console: defined?(node['console']['ip']) ? node['console']['ip'] : '',
    motd_ohai: motd_ohai
  )
end
