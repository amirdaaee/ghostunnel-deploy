local context = import '../../data/context.jsonnet';
local compose = import './docker-compose.jsonnet';
local context_client = context.client;
local container = compose.services[context_client.name];
[
  {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata:
    { name: context_client.name + '-deploy' },
  spec: {
    replicas: 1,
    selector: {
      matchLabels:
        { app: context_client.name },
    },
    strategy: { rollingUpdate: { maxSurge: '25%', maxUnavailable: '25%' }, type: 'RollingUpdate' },
    template: {
      metadata: {
        labels:
          { app: context_client.name },
      },
      spec: {
        containers: [{
          name: context_client.name,
          image: container.image,
          imagePullPolicy: 'IfNotPresent',
          ports: [
            { containerPort: context_client.listen_port },
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
      },
    },
  },
}, 
{
  apiVersion: 'v1',
  kind: 'Service',
  metadata:
    { name: context_client.name + '-loadbalancer' },
  spec:
    {
      ports:
        [{
          port: context_client.listen_port,
          targetPort: self.port,
          protocol: 'TCP',
          name: 'tcp-' + self.port,
        }],
      selector:
        { app: context_client.name },
      type: 'LoadBalancer',
    },
}
]
