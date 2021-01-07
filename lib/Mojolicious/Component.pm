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

has template => (
  is => 'ro',
  isa => 'InstanceOf["Mojo::Template"]',
  new => 1,
);

fun new_template($self) {
  require Mojo::Template; Mojo::Template->new(vars => 1)
}

method render(Any %args) {
  my $template;
  for my $package ($self->space->package, @{$self->space->inherits}) {
    if ($template = Mojo::Loader::data_section($package, 'component')) {
      last;
    }
  }
  return $self->template->render(($template || ''), {
    $self->variables(%args), component => $self,
  });
}

method variables(Any %args) {
  (
    %args,
  )
}

1;

__DATA__

@@ component
