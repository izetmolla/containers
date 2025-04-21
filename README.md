# Docker container with SSH enabled.

Pull image from dockerhub 

`docker pull izetmolla/ubuntu:25.04`

Use docker compose `docker-compose.yaml`



```
services:
  workspace1:
    image: izetmolla/ubuntu:25.04
    container_name: workspace1
    hostname: workspace1
    working_dir: /workspace
    tty: true
    restart: always
    volumes:
      - ./workspace1:/workspace
    environment:
      ROOT_PWD: 'yourstrongpassword'
      ROOT_SSH_PUBLIC_KEY: ''
      SOFTWARES: ''
      CUSTOM_SOFTWARES: 'go,nvm'
      WAKATIME_KEY: ''
      GH_USERNAME: ''
      GH_EMAIL: ''
      GH_NAME: ''
      GH_KEY: ''
```
