ruby_block "Execute the new cookbooks" do
  block do
    @cookbook_loader = node.cookbook_loader # needed for include_recipe to work
    reload_definitions

    node[:scalarium_custom_cookbooks][:recipes].each do |r|
      begin
        Chef::Log.info("Executing custom recipe: #{r}")
        include_recipe r
      rescue Exception => e
        Chef::Log.error("Caught exception during execution of custom recipe: #{r}: #{e} - #{e.backtrace.join("\n")}")
        raise e
      end
    end
  end
  
  only_if do
    Chef::Log.info("Executing custom cookbooks") if node[:scalarium_custom_cookbooks][:enabled]
    node[:scalarium_custom_cookbooks][:enabled]
  end
end
