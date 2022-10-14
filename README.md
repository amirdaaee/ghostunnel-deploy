# [Ghostunnel](https://github.com/ghostunnel/ghostunnel "Ghostunnel") deployment helper

## usage 
make a copy of `data/context.jsonnet.template` into `data/context.jsonnet` and fill required values

------------


### server
if you are using k8s for deployment of server, fill out `data/fullchain.pem` and `data/privatekey.pem` with your certificate data. 
else if you are using docker-compose, you should provide `/cert/fullchain.pem` and `/cert/privatekey.pem` using docker volumes inside container.

`jsonnet ./templates/server.jsonnet -S -o data/server`

------------

### client
`jsonnet ./templates/client.jsonnet -S -o data/client`