# Written by George Kopf
# Cookbook:: applyDemo
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

remote_file '/home/tomcat/baseMetadata.xml' do
  source "http://192.168.1.24:8081/repository/maven-snapshots/com/kopf/devOpsDemo/maven-metadata.xml"
  mode '0755'
  action :create
end

ruby_block 'parse the baseMetadata.xml file' do
block do
  baseMetadata = File.readlines("/home/tomcat/baseMetadata.xml")
  baseMetadataLine = baseMetadata.grep(/<version>/)
  node.default['baseVersion'] = baseMetadataLine.first[/version>(.*?)<\/version/, 1]
  end
  action :run
end

remote_file '/home/tomcat/elementMetadata.xml' do
  source lazy {"http://192.168.1.24:8081/repository/maven-snapshots/com/kopf/devOpsDemo/#{node['baseVersion']}/maven-metadata.xml"}
  mode '0755'
  action :create
end

ruby_block 'parse the elementMetadata.xml file' do
  block do
    elementMetadata = File.readlines("/home/tomcat/elementMetadata.xml")
    elementMetadataLines = elementMetadata.grep(/<value>/)
    node.default['elementVersion'] = elementMetadataLines.first[/<value>(.*?)<\/value>/,1]
  end
end

remote_file '/home/tomcat/demo.war.zip' do
  source lazy {"http://192.168.1.24:8081/repository/maven-snapshots/com/kopf/devOpsDemo/#{node['baseVersion']}/devOpsDemo-#{node['elementVersion']}.war"}
  mode '0755'
  action :create
end

ruby_block 'Deploy and clean up' do
  block do
    FileUtils.rm_rf '/usr/share/tomcat/webapps/demo*'
    File.rename '/home/tomcat/demo.war.zip', '/usr/share/tomcat/webapps/demo.war.zip'
    File.rename '/usr/share/tomcat/webapps/demo.war.zip', '/usr/share/tomcat/webapps/demo.war'
    File.delete '/home/tomcat/baseMetadata.xml'
    File.delete '/home/tomcat/elementMetadata.xml'
    end
    action :run
end
