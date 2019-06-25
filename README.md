Forward SSH agent socket into a container

Still experimental -- contact anil@recoil.org or bryan@uber.com if you want help.


## Installation

Assuming you have a `/usr/local`

```
$ git clone git://github.com/uber-common/docker-ssh-agent-forward
$ cd docker-ssh-agent-forward
$ make
$ make install
```

On every boot, do:

```
pinata-ssh-forward
```

and the you can run `pinata-ssh-mount` to get a Docker CLI fragment that adds
the SSH agent socket and sets `SSH_AUTH_SOCK` within the container.

```
$ pinata-ssh-mount
-v ssh-agent:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent/ssh-agent.sock

$ docker run -it $(pinata-ssh-mount) 
/ssh-agent-forward ssh -T git@github.com
The authenticity of host 'github.com (192.30.252.128)' can't be established.
RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,192.30.252.128' (RSA) to the list of known hosts.
PTY allocation request failed on channel 0
Hi avsm! You've successfully authenticated, but GitHub does not provide shell access.
```

To fetch the latest image, do:

```
pinata-ssh-pull
```

## Using with docker-compose

To use with docker-compose, you can change the ssh-agent volume type to a host directory
rather than a docker volume, which can then be mounted in docker-compose.yml. To do this,
create a `.pinata-ssh.env` file in your home directory and set the `VOLUME_TYPE` to "bind":
```
echo 'VOLUME_TYPE=bind' > ~/.pinata-ssh.env
```

This will cause the ssh-agent file to be written to `$HOME/.pinata-ssh-agent`, which
you can reference in your docker-compose.yml:

```
# docker-compose.yml
services:
...
  volumes:
    - type: bind
      source: ${HOME}/.pinata-ssh-agent
      target: /ssh-agent
  environment:
    - SSH_AUTH_SOCK=/ssh-agent/ssh-agent.sock
...
```

The host mount path can also be changed by setting a `HOST_VOLUME_PATH` in the
.pinata-ssh.env file.

## Troubleshooting

If pinata-ssh-forward fails to run, run `ssh-add -l`. If there are no identities, then run `ssh-add`.

## Developing

To build an image yourself rather than fetching from Docker Hub, run
`./pinata-ssh-build.sh` from your clone of this repo.

We didn't bother installing the build script with the Makefile since using the
hub image should be the common case.

## Contributors

* Justin Cormack
* https://github.com/uber-common/docker-ssh-agent-forward/graphs/contributors

[License](LICENSE.md) is ISC.
