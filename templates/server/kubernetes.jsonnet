local context = import '../../data/context.jsonnet';
local compose = import './docker-compose.jsonnet';
local context_server = context.server, context_common = context.common;
local container = compose.services[context_server.name];
[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata:
      { name: context_server.name + '-deploy' },
    spec: {
      replicas: 1,
      selector: {
        matchLabels:
          { app: context_server.name },
      },
      strategy: { rollingUpdate: { maxSurge: '25%', maxUnavailable: '25%' }, type: 'RollingUpdate' },
      template: {
        metadata: {
          labels:
            { app: context_server.name },
        },
        spec: {
          containers: [{
            name: context_server.name,
            image: container.image,
            imagePullPolicy: 'IfNotPresent',
            ports: [
              { containerPort: context_common.server_port },
            ],
            volumeMounts: [
              {
                mountPath: '/cert',
                name: 'cert',
              },
            ],
            args: container.command,
            resources: {
              limits: {
                cpu: '100m',
                'ephemeral-storage': '100M',
                memory: '100M',
              },
              requests: self.limits,
            },
          }],
          restartPolicy: 'Always',
          volumes: [
            {
              name: 'cert',
              secret: {
                defaultMode: 420,
                secretName: context_server.name + '-cert',
              },
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata:
      { name: context_server.name + '-loadbalancer' },
    spec:
      {
        ports:
          [{
            port: context_common.server_port,
            targetPort: self.port,
            protocol: 'TCP',
            name: 'tcp-' + self.port,
          }],
        selector:
          { app: context_server.name },
        type: 'LoadBalancer',
      },
  },
  {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata:
      { name: context_server.name + '-cert' },
    type: 'Opaque',
    stringData: {
      'fullchain.pem': importstr '../../data/fullchain.pem',
      'privatekey.pem': importstr '../../data/privatekey.pem',
    },
  },
]
