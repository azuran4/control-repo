#node puppet.local {
node puppet-server {
  include role::master,
}
