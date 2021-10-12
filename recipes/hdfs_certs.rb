template_ssl_server()

group node['hops']['secure_group'] do
  action :modify
  members node['hops']['hdfs']['user']
  append true
  not_if { node['install']['external_users'].casecmp("true") == 0 }
end

# Generate certificate only once - generate_x509 already checks if certificate is already generated
crypto_dir = x509_helper.get_crypto_dir(node['hops']['hdfs']['user'])
kagent_hopsify "Generate x.509" do
  user node['hops']['hdfs']['user']
  crypto_directory crypto_dir
  action :generate_x509
  not_if { node["kagent"]["enabled"] == "false" }
end