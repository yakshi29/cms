#
# Cookbook:: cms_3.X.iscsi_cookbook
# Spec:: default
#
# Copyright 2018 IBM Corporation, All Rights Reserved

require 'spec_helper'


let(:iscsi_template) { chef_run.template('/etc/iscsi/iscsid.conf') }
let(:initiator_template) { chef_run.template('/etc/iscsi/initiatorname.iscsi') }

it 'installs open-iscsi' do
      expect(chef_run).to install_package('open-iscsi')
    end 

 %w{iscsi iscsid}.each do |iscsi_service|
      it "#{iscsi_service} service will be started" do
        expect(chef_run).to start_service(iscsi_service)
      end  
      
 %w{iscsi iscsid}.each do
 it "{iscsi_service} service will be enabled" do
        expect(chef_run).to enable_service(iscsid_service)
      end
describe 'bash_iscsi_login' do
expect(chef_run).to run_bash('targetname=`iscsiadm -m discovery -t st -p #{ipaddress}`')

expect(chef_run).to run_bash('iscsiadm --mode node --targetname $targetname --portal #{ipaddress}:3260 --login')
end
end
end
#uninstall script
describe 'bash_iscsi_remove' do
expect(chef_run).to run_bash('iscsiadm --mode session | awk '{print $4}' | sed '2d'')

expect(chef_run).to run_bash('iscsiadm --mode session  | cut -d "," -f1 |  awk '{print $3}' | sed '1d'')

expect(chef_run).to run_bash('iscsiadm --mode session  | cut -d "," -f1 |  awk '{print $3}' | sed '2d'')

expect(chef_run).to run_bash('iscsiadm --mode node --targetname $sessionname1 --portal $sessionip1 --logout')

expect(chef_run).to run_bash('iscsiadm --mode node --targetname $sessionname1 --portal $sessionip1 --logout')

expect(chef_run).to run_bash('iscsiadm -m node -o delete -T "$sessionname1" --portal $sessionip1')
expect(chef_run).to run_bash('iscsiadm -m node -o delete -T "$sessionname1" --portal $sessionip2')

end

let(:iscsi_template) { chef_run.template('/etc/iscsi/iscsid.conf') }
let(:initiator_template) { chef_run.template('/etc/iscsi/initiatorname.iscsi') }



%w{iscsi iscsid}.each do |iscsi_service|
      it "#{iscsi_service} service will be started" do
        expect(chef_run).to stop_service(iscsi_service)
      end

 %w{iscsi iscsid}.each do
 it "{iscsi_service} service will be enabled" do
        expect(chef_run).to disable_service(iscsid_service)
      end


end
end
