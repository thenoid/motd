
case node['platform_family'].to_s
when 'rhel'
  if (node['motd']['cache_clear'].to_i + 24 * 60 * 60 ) < Time.now.to_i
    cmd = %w(yum clean all).join(' ')
    z = Mixlib::ShellOut.new(cmd)
    z.run_command
    node.default['motd']['cache_clear'] = Time.now
  end
  cmd = %w(yum updateinfo summary).join(' ')
  z = Mixlib::ShellOut.new(cmd)
  z.run_command
  bleh = []
  z.stdout.split("\n").each do |y|
    bleh.push($1) if y.match(/(\d+\s+\w+\s+notice\(s\))/)
  end
  node.default['motd']['updates'] = bleh
end

