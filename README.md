# TaskCluster Passwords

> **NOTE** This is currently full of garbage secrets.  Don't put anything
> important here, yet. When everyone is able to read and write secrets here, we
> will move this to a private git repository and add the real secrets.

This repository contains passwords for the TaskCluster team.  It is designed to
be used with the [passwordstore](https://www.passwordstore.org/) utility,
although that is not required.


# Setup

* Install [passwordstore](https://www.passwordstore.org/)
* Clone this repository to `~/.password-store`
* Run `pass`; you should see a hierarchical list of the names of passwords.

Now you'll need to set up GPG, if you haven't already

* Get yourself set up with a [keybase](https://keybase.io) account, if you haven't already.
  * Generate a private key locally following the keybase process.
  * Follow (`keybase follow <username>`) all of the other team members listed in [.team.txt](.team.txt).
  * If you aren't already added, get someone who is already set up to follow the instructions below.

Now, you should be able to read a secret (see below)! Before you go on, though,
set yourself up to edit secrets, too. First, download the public keys for the
whole team:

```
gpg --keyserver gpg.mozilla.org --recv-keys $(grep -v '#' < ~/.password-store/.team.txt | awk '{ print $2 }')
```

Now, you need to find some way to ensure that these are the right keys, and
tell GnuPG that. It insists!

The most expedient way to accomplish this is to trust the key of someone who
has signed all of the other team members' keys. Most likely, this is the person
who added you to the repo. Check that the fingerprint listed in keybase matches
the fingerprint in `.team.txt`, and verify the fingerprint with them via some
other channel, too (irc is OK). Once that's done:

```
$ gpg --edit-key $FINGERPRINT
gpg> trust
# Set the trust to "fully", meaning "Their signature on a key would be as good as your own"
gpg> sign
# answer yes
gpg> save
$ gpg --keyserver gpg.mozilla.org --send-key $FINGERPRINT
```

If you've got the time, it is smart to do this for several people. If you're a
GnuPG guru with a carefully groomed PGP keychain, then of course you can make
your own choices here.


# How To..


## ..read a secret

If it's been a while, run `git -C ~/.password-store pull` to get the latest
passwords.

Run `pass <secretname>`.  Secrets are in a directory structure, and you can see
the whole list with a simple `pass`:

```
$ pass
Password Store
├── new-pass
└── test-pass
$ pass new-pass
new!
```

The `pass` command has a `-c` option to copy the first line to the clipboard
and clear it 45 seconds later, which means you never even have to see the
password or risk pasting it into a chat.


## ..add or update a secret

If it's been a while, run `git -C ~/.password-store pull` to get the latest
passwords.  Then run `pass edit <secretname>`. This will open an editor where
you can edit the password.

Always put the password alone on the first line, with any additional
information two lines later (like a git commit message):

```
wiejeiWuez0ohhuoyuoGh7Neequ6eeT1JidahjiD3loi3sio8b

username: taskcluster-accounts@mozilla.com
```

Once you're done, `git -C ~/.password-store push` so everyone else can see your
handiwork.

### Troubleshooting

If you see an error like

```
gpg: C816CF70AB94621D: There is no assurance this key belongs to the named user
gpg: /dev/shm/pass.vuaQuQnSdZ1OE/XPxFC-testy.txt: encryption failed: Unusable public key
GPG encryption failed. Would you like to try again? [y/N] 
```

don't panic, but don't say "n"! Open a new terminal, and get any signatures on the
keys that you might have missed:

```
gpg --keyserver gpg.mozilla.org --recv-keys $(grep -v '#' < ~/.password-store/.team.txt | awk '{ print $2 }')
```

then go back and try again.  If that still doesn't work, figure out whose key
it is (in this case, `gpg --list-keys C816CF70AB94621D`) and verify the
fingerprint as above, then sign and trust the key.  Note that the key id in the
error message is not the same as the fingerprint!

If you find that this is your own key, use `--edit-key` to edit the key and set
its trust level to "ultimate". Any key for which you have the secret key should
have ultimate trust.

## ..add a new person to the team

This new person should be on keybase already.  Follow them.  Then get a copy of
the user's key locally.

```
USER=..
curl https://keybase.io/$USER/pgp_keys.asc | gpg --import
```

Update your repo, then edit `.team.txt` to include their username and
fingerprint.  You can get their fingerprint by going to their homepage on
https://keybase.io and clicking the key link.  Select the full-length
fingerprint and copy/paste. It should paste without spaces.

Verify the new key. The new user can see their fingerprint locally with

```
gpg --list-secret-keys --fingerprint
```

Having verified the key both in keybase and some other channel, sign the key
(encourage everyone to do this actually) and publish the signature:

```
gpg --sign-key $FINGERPRINT
# answer questions
gpg --keyserver gpg.mozilla.org --send-key $FINGERPRINT
```

Then re-init the password store:


```
pass init $(grep -v '#' < ~/.password-store/.team.txt | awk '{ print $2 }')
```

It should re-encrypt files to include the new user and commit the results. If
you're happy, `git push`.  If not, `git reset --hard HEAD^`.


## ..remove a person from the team

Update your repo, then edit `.team.txt` to remove the person's key. Commit
and push.

Now the fun part: change all of those passwords, since they are still in the
git repo on that person's laptop. You can list the passwords the person still
has access to with

```sh
KEYID=D56B32E5
for f in `git ls-files | grep '.gpg$'`; do
    [ -n "`gpg --list-only --no-default-keyring --secret-keyring /dev/null $f 2>&1 | grep $KEYID`" ] && echo $f
done
```

where KEYID is found in the `pub` key in

```
$ gpg --list-keys $FINGERPRINT
pub   2048R/D56B32E5 2017-03-15
uid                  person@somewhere.com
sub   2048R/33198A27 2017-03-15
```

# Tips


## tcpw

To ensure that you are always using the latest version, and that your changes
are pushed right away, add this file as `tcpw` somewhere in your $PATH:

```sh
#! /bin/bash

PASSWORD_STORE_DIR=~/.password-store  # or wherever you like

cd $PASSWORD_STORE_DIR
git pull --quiet 1>&2
pass "${@}"
git push --quiet
```

Now you can run `tcpw some/password` to read an up-to-date password, or `tcpw
edit another/password` to edit one and push the results to the rest of the team
right away.
