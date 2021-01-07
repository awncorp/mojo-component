package Mojolicious::Component;

use 5.014;

use strict;
use warnings;

use registry;
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;
use Data::Object::Space;

use Mojo::Loader ();

# VERSION

has controller => (
  is => 'ro',
  isa => 'InstanceOf["Mojolicious::Controller"]',
  opt => 1,
);

has space => (
  is => 'ro',
  isa => 'InstanceOf["Data::Object::Space"]',
  new => 1,
);

fun new_space($self) {
  Data::Object::Space->new(ref $self)
}

has processor => (
  is => 'ro',
  isa => 'InstanceOf["Mojo::Template"]',
  new => 1,
);

fun new_processor($self) {
  require Mojo::Template; Mojo::Template->new(vars => 1)
}

# METHODS

method preprocess(Str $input) {
  return $input;
}

method postprocess(Str $input) {
  return $input;
}

method render(Any %args) {
  return $self->processor->render(
    ($self->postprocess($self->preprocess($self->template || ''))),
    {
      $self->variables(%args),
      component => $self,
    }
  );
}

method template(Str | Object $object = $self, Str $section = 'component') {
  my $template;
  my $space = $object
    ? Data::Object::Space->new(ref($object) || $object)
    : $self->space;
  for my $package ($space->package, @{$space->inherits}) {
    if ($template = Mojo::Loader::data_section($package, $section)) {
      last;
    }
  }
  return $template;
}

method variables(Any %args) {
  (
    %args,
  )
}

1;

__DATA__

@@ component
