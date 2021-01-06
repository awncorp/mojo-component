use 5.014;

use strict;
use warnings;
use routines;

use Test::Auto;
use Test::More;

=name

Mojolicious::Component

=cut

=tagline

Component-based Template Class

=cut

=abstract

Component-based Template Abstract Base Class

=cut

=includes

method: render

=cut

=synopsis

  use Mojolicious::Component;

  my $component = Mojolicious::Component->new;

  # $component->render

=cut

=attributes

controller: ro, opt, InstanceOf["Mojolicious::Controller"]
space: ro, opt, InstanceOf["Data::Object::Space"]
template: ro, opt, InstanceOf["Mojo::Template"]

=cut

=description

This package provides an abstract base class for rendering derived
component-based template (partials) classes.

=cut

=method render

The render method loads the component template string data from the C<DATA>
section of the component class and renders it using the L<Mojo::Template>
object available via L</template>.

=signature render

render(Any %args) : Str

=example-1 render

  # given: synopsis

  my $rendered = $component->render;

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-1, 'render', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

ok 1 and done_testing;
