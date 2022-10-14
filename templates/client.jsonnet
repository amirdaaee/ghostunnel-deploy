local manifest=import './client/kubernetes.jsonnet';
local compose=import './client/docker-compose.jsonnet';
{
  'docker-compose.yaml': std.manifestYamlDoc(compose),
  'manifest.yaml': std.manifestYamlStream(manifest)
}
