SSH key deploy playbook, update multiple hosts from a lets encrypt based public ssh key.

If using a jump host, tell ansible to reference this file when making connections
<pre>
cat << EOF >> ~/.ansible.cfg
[ssh_connection]
ssh_args = -F /home/$USER/.ssh/config -o ControlMaster=auto -o ControlPersist=30m
EOF
</pre>