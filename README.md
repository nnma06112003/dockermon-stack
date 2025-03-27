# dockermon-stack
## Network
```bash
sudo docker network create --scope=swarm --attachable -d overlay coinswarmnet
```

```bash
sudo docker network create --scope=swarm -d overlay loggingnet
```
## Stack 
```bash
sudo docker stack deploy -c elk.yml elk
```

```bash
sudo docker stack deploy -c mrnam.yml mystack
```
