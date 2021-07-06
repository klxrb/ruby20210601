role :app, %w{deploy@domain.name}
role :web, %w{deploy@domain.name}
role :db,  %w{deploy@domain.name}

# we use agent forwarding, so we need to make sure the ssh-agent is actually
# running and primed with the key you want to use; make it so via:
#
#     eval `ssh-agent`; ssh-add
#
# which will add the defult ssh key to the agent

set :ssh_options, {
  forward_agent: true,
  auth_methods:  %w[publickey],
}
