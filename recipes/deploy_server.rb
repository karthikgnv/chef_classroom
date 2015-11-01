# Cookbook Name:: chef_classroom
# Recipe:: deploy_server

require 'chef/provisioning/aws_driver'
with_driver "aws::#{region}"
class_name = node['chef_classroom']['class_name']

include_recipe 'chef_portal::_refresh_iam_creds'

machine "#{class_name}-chefserver" do
  machine_options create_machine_options(region, 'marketplace', server_size, portal_key, 'chef_server')
  tags [ 'chefserver', class_name ]
  recipe 'chef_classroom::server'
end

chef_data_bag 'class_machines'

1.upto(count) do |i|
  chef_classroom_lookup "#{class_name}-chefserver" do
    tags [ 'chefserver', class_name ]
    platform 'amazon'
  end
end

include_recipe 'chef_classroom::_refresh_portal'
