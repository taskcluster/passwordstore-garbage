# TaskCluster Passwordstore

The Taskcluster team's psaswords are at ssh://gitolite3@git-internal.mozilla.org/taskcluster/secrets.git.

To connect to that repo, set up automatic tunneling by adding the following to
`~/.ssh/config`:

```
Host ssh.mozilla.com
    ForwardAgent yes
    User <your mozilla posix username>

Host git-internal.mozilla.org
    User gitolite3
    ProxyCommand ssh -W %h:%p -oProxyCommand=none ssh.mozilla.com
```

Then update the remote:

```
git remote set-url origin ssh://gitolite3@git-internal.mozilla.org/taskcluster/secrets.git
```

and pull the updated information:

```
git pull
```

You will need to enter MFA credentials with each access.  Once you have access, see the README in that file for next steps.

## Troubleshooting

If you have trouble, try `ssh -v ssh.mozilla.com`.  Once you can get a prompt
there, try `ssh -v git-internal.mozilla.org` from that prompt.
