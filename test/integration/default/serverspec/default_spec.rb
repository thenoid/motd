require 'spec_helper'

describe 'motd::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  secpkg = ''
  motd_file = '/etc/motd'
  if os[:family] == 'redhat'
    case os[:release].to_i
    when 6
      secpkg = 'yum-plugin-security'
    when 5
      secpkg = 'yum-security'
    end
  end

  motd_file = '/etc/motd.tail' if os[:family] == 'ubuntu'
  describe package(secpkg), if: secpkg != '' do
    it { should be_installed }
  end

  describe file(motd_file) do
    it { should be_file }
    its(:content) { should match(/Platform/) }
    its(:content) { should match(/Model/) }
    its(:content) { should match(/Console/) }
    its(:content) { should match(/Serial/) }
    its(:content) { should match(/OS/) }
    its(:content) { should match(/System information as of /) }
    its(:content) { should match(/Build Date/) } if os[:family] == 'redhat'
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
