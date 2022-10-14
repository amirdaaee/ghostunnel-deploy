local context = import '../../data/context.jsonnet';
local context_client = context.client, context_common = context.common;
{
  services: {
    [context_client.name]: {
      image: 'ghostunnel/ghostunnel:latest',
      ports: [
        context_client.listen_port + ':' + context_client.listen_port,
      ],
      command: [
        'client',
        '--listen=0.0.0.0:' + context_client.listen_port,
        '--target=' + context_client.target_host + ':' + context_common.server_port,
        '--unsafe-listen',
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
