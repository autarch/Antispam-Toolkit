package Antispam::Toolkit::Role::LinkChecker;

use strict;
use warnings;
use namespace::autoclean;

use Antispam::Toolkit::Types qw( NonEmptyStr );

use Moose::Role;
use MooseX::Params::Validate qw( validated_hash );

requires 'check_link';

around check_link => sub {
    my $orig = shift;
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        email    => { isa => NonEmptyStr, optional => 1 },
        ip       => { isa => NonEmptyStr, optional => 1 },
        link     => { isa => NonEmptyStr },
        username => { isa => NonEmptyStr, optional => 1 },
    );

    $self->$orig(%p);
};

1;

