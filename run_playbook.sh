#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook --ask-pass playbook.yml -i ./hosts