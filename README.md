# TaskCluster Passwordstore

The Taskcluster team's psaswords are at ssh://gitolite3@git-internal.mozilla.org/taskcluster/secrets.git.

To connect to that repo, first make sure you've got your SSH key defined (https://login.mozilla.com) and that you know your POSIX username (often just the userpart of your @mozilla.com email).
Then set up automatic tunneling by adding the following to `~/.ssh/config`:

```
Host ssh.mozilla.com
    ForwardAgent yes
    User <your mozilla posix username>

Host git-internal.mozilla.org
    User gitolite3
    ProxyCommand ssh -W %h:%p -oProxyCommand=none ssh.mozilla.com
```

Then clone the repo:

```
git clone ssh://gitolite3@git-internal.mozilla.org/taskcluster/secrets.git
```

You will need to enter MFA credentials with each access.  Once you have access, see the README in that file for next steps.

## Troubleshooting

If you have trouble, try `ssh -v ssh.mozilla.com`.  Once you can get a message
about not allowing logins there ("This server is intended only for use as a
jumphost"), try `ssh -v git-internal.mozilla.org`.
