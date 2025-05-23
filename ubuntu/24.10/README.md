# Docker container with ssh and docker

This repository contains a Docker setup for running an Ubuntu 25.04 container with SSH and Docker support.

## Services

### workspace1

- **Image**: `izetmolla/ubuntu:25.04`
- **Container Name**: `workspace1`
- **Hostname**: `workspace1`
- **Working Directory**: `/workspace`
- **TTY**: `true`
- **Restart Policy**: `always`
- **Volumes**:
    - `./workspace1:/workspace`
- **Environment Variables**:
    - `ROOT_PWD`: `yourstrongpassword`
    - `ROOT_SSH_PUBLIC_KEY`: ``
    - `SOFTWARES`: ``
    - `CUSTOM_SOFTWARES`: `go,nvm`

## Usage

To run the container, use the following command:

```sh
docker-compose up -d
```

This will start the `workspace1` container with the specified configuration.

## Notes

- Ensure that the `ROOT_PWD` environment variable is set to a strong password.
- You can add your SSH public key to the `ROOT_SSH_PUBLIC_KEY` environment variable for SSH access.
- Customize the `SOFTWARES` and `CUSTOM_SOFTWARES` environment variables as needed.
