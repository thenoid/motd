
manufacturer = ''
if defined?(node['dmi']['system']['manufacturer'])
  manufacturer = node['dmi']['system']['manufacturer']
end

case manufacturer.to_s
when /dell/i
  if File.exist?('/opt/dell/srvadmin/sbin/racadm')
    node.default['console']['type'] = 'drac'
    drac = {}
    cmd = %w(/opt/dell/srvadmin/sbin/racadm getconfig -g cfgLanNetworking
             | egrep -v ^#
             | egrep "=").join(' ')
    z = Mixlib::ShellOut.new(cmd)
    z.run_command
    z.stdout.split.each do |y|
      x = y.split('=')
      w = Hash[*x]
      drac.merge!(w)
    end
    node.default['console']['config'] = drac
    cfgnicipaddress = node.default['console']['config']['cfgNicIpAddress']
    node.default['console']['ip'] = cfgnicipaddress
  end
else
  node.default['console'] = { 'type' => '', 'config' => {}, 'ip' => '' }
end
