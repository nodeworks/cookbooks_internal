rightscale_marker :begin

execute "rkhunter --update -q"

bash "rkhunter -c -sk --summary" do
  code <<-EOF
    rkhunter -c -sk --summary
  EOF
end

rightscale_marker :end
