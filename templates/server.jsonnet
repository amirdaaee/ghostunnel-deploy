local manifest=import './server/kubernetes.jsonnet';
local compose=import './server/docker-compose.jsonnet';
{
  'docker-compose.yaml': std.manifestYamlDoc(compose),
  'manifest.yaml': std.manifestYamlStream(manifest)
}
