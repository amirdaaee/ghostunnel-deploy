local context = import '../../data/context.jsonnet';
local context_server = context.server, context_common = context.common;
{
  services: {
    [context_server.name]: {
      image: 'ghostunnel/ghostunnel:latest',
      ports: [context_common.server_port + ':' + context_common.server_port],
      command: [
        'server',
        '--listen=0.0.0.0:' + context_common.server_port,
        '--target=' + context_server.target_url,
        '--cert=/cert/fullchain.pem',
        '--key=/cert/privatekey.pem',
        '--unsafe-target',
        '--disable-authentication',
      ],
      deploy:
        {
          mode: 'replicated',
          replicas: 1,
        },
      restart: 'unless-stopped',
    },
  },
}
