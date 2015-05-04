#
# Cookbook Name:: motd
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'motd::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end
    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.set['motd']['header'] = 'Dell SecureWorks - There is no cow level'
    end.converge(described_recipe)
  end

  let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }
  it 'creates template with attributes' do
    expect(chef_run).to create_template('/etc/motd').with(
        user: 'root',
        group: 'root',
        mode: 00644
      )
  end
  it 'contains a timestamp from last run' do
    expect(chef_run).to render_file('/etc/motd') \
      .with_content(/System information as of/)
  end
  it 'contains the word Platform' do
    expect(chef_run).to render_file('/etc/motd') \
      .with_content(/Platform/)
  end
  it 'contains the word Model' do
    expect(chef_run).to render_file('/etc/motd') \
      .with_content(/Model/)
  end
end
