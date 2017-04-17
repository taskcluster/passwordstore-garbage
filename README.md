# TaskCluster Passwords

> **NOTE** This repository is no longer in use!

The secrets are now at ssh://gitolite3@git-internal.mozilla.org/taskcluster/secrets.git.

To connect to that repo, set up automatic tunneling by adding the following to
`~/.ssh/config`:

```
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

You will need to enter MFA credentials with each access.
