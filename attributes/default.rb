default['motd']['company'] = 'blah'
default['motd']['flavor'] = ['There is no cow level', 'The cake is a lie']
default['motd']['updates'] = []
default['dsw']['built'] = nil

unless default['motd'].key?('cache_clear')
  default['motd']['cache_clear'] = Time.now
end
