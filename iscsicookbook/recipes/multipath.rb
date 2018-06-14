#Mutipath installation and configuration

if (node['cluster_readiness']['HAcluster']=='true' &&  node['cluster_readiness']['StorageUsername']!="")
package 'multipath-tools'

template '/etc/multipath.conf' do
  source 'multipath.conf.erb'
  owner 'root'
  group 'root'
  mode 0600
  action :create
  not_if "grep sbddisk1 /etc/multipath.conf"
end

execute 'multipath command' do
  command 'multipath -v3'
  not_if "grep sbddisk1 /etc/multipath.conf"
  end

bash "multipath config" do

user "root"
code <<-EOF


multi=`ls /dev/disk/by-id/dm-uuid-mpath* |awk  '{print substr($0,31)}' | head -1`
cat <<EOT >> /etc/multipath.conf
multipaths {
    multipath {
            wwid     $multi
            alias    sbddisk1
              }
}

EOT

multipath -F

multipath -v3

EOF
not_if "grep sbddisk1 /etc/multipath.conf"

end



service 'multipathd.service' do
  action [:enable, :start]
end



end
#Multipath cleanup
if (node['cluster_readiness']['HAcluster']=='false' &&  node['cluster_readiness']['StorageUsername']=="") 

template '/etc/multipath.conf' do
  source 'multipath.conf.erb'
  owner 'root'
  group 'root'
  mode 0600
  action :create
end


execute 'multipath flush' do
  command 'multipath -F' 
not_if "grep  sbddisk1 /etc/multipath.conf"
end

execute 'multipath reload' do
  command 'multipath -v3'
  not_if "grep sbddisk1 /etc/multipath.conf"
end

end
