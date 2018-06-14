require 'spec_helper'



it 'installs multipath-tools' do
      expect(chef_run).to install_package('multipath-tools')
    end

let(:multipath_template) { chef_run.template('/etc/multipath.conf') }

describe 'multipath command' do

expect(chef_run).to run_execute('multipath -v3')
end

describe 'multipath config' do
expect(chef_run).to run_bash('ls /dev/disk/by-id/dm-uuid-mpath* |awk  '{print substr($0,31)}' | head -1')

expect(chef_run).to run_bash('cat <<EOT >> /etc/multipath.conf
multipaths {
    multipath {
            wwid     $multi
            alias    sbddisk1
              }
}

EOT
')

expect(chef_run).to run_bash('multipath -F')
expect(chef_run).to run_bash('multipath -v3')
end


      it "multipathd service will be started" do
        expect(chef_run).to start_service(multipathd_service)
      end

 it "multipathd service will be enabled" do
        expect(chef_run).to enable_service(multipathd_service)
      end

#Multipath cleanup

let(:multipath_template) { chef_run.template('/etc/multipath.conf') }


describe 'multipath flush' do

expect(chef_run).to run_execute('multipath -F')
end

describe 'multipath reload' do

expect(chef_run).to run_execute('multipath -v3')
end

