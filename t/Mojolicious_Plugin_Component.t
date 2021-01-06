use 5.014;

use strict;
use warnings;
use routines;

use Test::Auto;
use Test::More;

=name

Mojolicious::Plugin::Component

=cut

=tagline

Module-based Component Rendering

=cut

=abstract

Module-based Component Rendering Plugin

=cut

=includes

method: register

=cut

=synopsis

  package App;

  use Mojo::Base 'Mojolicious';

  package App::Component::Image;

  use Mojo::Base 'Mojolicious::Component';

  has alt => 'random';
  has height => 126;
  has width => 145;
  has src => '/random.gif';

  1;

  # __DATA__
  #
  # @@ component
  #
  # <img
  #   alt="<%= $component->alt %>"
  #   height="<%= $component->height %>"
  #   src="<%= $component->src %>"
  #   width="<%= $component->width %>"
  # />

  package main;

  my $app = App->new;

  my $component = $app->plugin('component');

  my $image = $app->component->use('image');

  my $rendered = $image->render;

=cut

=inherits

Mojolicious::Plugin

=cut

=description

This package provides L<Mojolicious> module-based component rendering plugin.

=cut

=method register

The register method registers one or more component builders in the
L<Mojolicious> application. The configuration information can be provided when
registering the plugin by calling L<plugin> during setup, or by specifying the
data in the application configuration under the key C<component>. By default,
if no configuration information is provided the plugin will register a builder
labeled C<use> which will load components under the application's C<Component>
namespace.

=signature register

register(InstanceOf["Mojolicious"] $app, Maybe[HashRef] $config) : Object

=example-1 register

  package main;

  use Mojolicious::Plugin::Component;

  my $app = Mojolicious->new;

  my $component = Mojolicious::Plugin::Component->new;

  $component = $component->register($app);

=example-2 register

  package main;

  use Mojolicious::Plugin::Component;

  my $app = Mojolicious->new;

  my $component = Mojolicious::Plugin::Component->new;

  $component = $component->register($app, {
    v1 => 'App::V1::Component',
    v2 => 'App::V2::Component',
  });

  # $app->component->v1('image')
  # $app->component->v2('image')

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-1, 'register', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  my $app = App->new;
  my $component = $app->plugin('component');
  is ref($result), 'Mojolicious::Plugin::Component';
  is ref($component), ref($result);
  my $image = $app->component->use('image');
  is ref($image), 'App::Component::Image';
  my $rendered = $image->render;
  like $rendered, qr/<img/;
  like $rendered, qr/alt="random"/;
  like $rendered, qr/height="126"/;
  like $rendered, qr/src="\/random\.gif"/;
  like $rendered, qr/width="145"/;
  $result
});

$subs->example(-2, 'register', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

ok 1 and done_testing;

package
  App::Component::Image;

1;

__DATA__

@@ component

<img
  alt="<%= $component->alt %>"
  height="<%= $component->height %>"
  src="<%= $component->src %>"
  width="<%= $component->width %>"
/>
