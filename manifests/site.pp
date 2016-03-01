# manifests/site.pp

# hiera configuration manages the nodes and what classes are applied on every node

hiera_include('classes')

Package {
  allow_virtual => true,
}
