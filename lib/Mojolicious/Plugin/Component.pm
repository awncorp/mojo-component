package Mojolicious::Plugin::Component;

use 5.014;

use strict;
use warnings;
use routines;

use Data::Object::Class;
use Data::Object::Space;

extends 'Mojolicious::Plugin';

method register($app, $config = {}) {
  $config = (%$config) ? $config : $app->config->{component} || {
    use => join('::', ref($app), 'Component'),
  };
  for my $name (sort keys %$config) {
    my $method = $name =~ s/\W+/_/gr;
    my $module = $config->{$name} or next;
    $app->helper("component.$method", fun($c, $child, %args) {
      if (!$child) {
        return undef;
      }
      Data::Object::Space->new($module)->append($child)->build(
        controller => $c,
        %args
      );
    });
  }
  return $self;
}

1;
