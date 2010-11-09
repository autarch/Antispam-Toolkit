package Antispam::Toolkit::Result;

use strict;
use warnings;

use Antispam::Toolkit::Types qw( ArrayRef NonEmptyStr PositiveInt );

use overload 'bool' => sub { $_[0]->is_spam() };

use Moose;
use MooseX::StrictConstructor;

has weight => (
is => 'ro',
isa => PositiveInt

has details => (
    is      => 'ro',
    isa     => ArrayRef [NonEmptyStr],
    default => sub { [] },
);

__PACKAGE__->meta()->make_immutable();

1;
