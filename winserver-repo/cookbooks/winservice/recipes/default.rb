#
# Cookbook Name:: winservice
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


powershell_script 'delete_if_exist' do
  code <<-EOH
     $Service = Get-WmiObject -Class Win32_Service -Filter "Name='TestService'"
     if ($Service) {
        $Service.Delete()
     }
  EOH
  notifies :run, 'execute[Installing Service TestService]', :immediately
end

execute 'Installing Service TestService' do
  command "sc create \"TestService\" binPath= C:\\WINDOWS\\System32\\svchost.exe "
  action :nothing
end

execute "Setting Log On User For TestService" do
  command "sc.exe config \"TestService\" obj=Administrator password=qZVZqXjiX-5"
  action :nothing
end

service "TestService" do
#  supports :status => true, :restart => true
  action [ :enable, :start ]
end
