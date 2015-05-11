
case node['platform_family'].to_s
when 'rhel'
  cmd = %w(yum updateinfo summary).join(' ')
  z = Mixlib::ShellOut.new(cmd)
  z.run_command
  bleh = []
  z.stdout.split("\n").each do |y|
    bleh.push($1) if y.match(/(\d+\s+\w+\s+notice\(s\))/)
  end
  node.default['motd']['updates'] = bleh
end

