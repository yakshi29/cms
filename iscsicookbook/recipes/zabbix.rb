#
# Cookbook Name:: iscsicookbook
# Recipe:: zabbix
#
# Copyright 2018 IBM Corporation, All Rights Reserved
flag = true
config_file = '/etc/zabbix/zabbix_agentd.d/pacemaker.conf'
template config_file do
  source 'pacemaker.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  variables(
    zabbix_server_ip: '0.0.0.0',
    cust_dc: 'psl',
    cust_name: 'psl',
    cust_org: 'psl org',
  )
  only_if { flag }
end
['resource_script.sh', 'log_script.sh'].each do |conf_file|
  cookbook_file "/var/lib/zabbix/#{conf_file}" do
    owner 'root'
    group 'root'
    mode '755'
    action :create
    only_if { flag }
    notifies :restart, 'service[zabbix-agent]', :delayed 
  end
end
[config_file, '/var/lib/zabbix/resource_script.sh', '/var/lib/zabbix/log_script.sh'].each do |conf_file|
  file conf_file do
    action :delete
    not_if { flag }
    only_if { File.exist?(conf_file) }
    notifies :restart, 'service[zabbix-agent]', :delayed 
  end
end
service 'zabbix-agent'
