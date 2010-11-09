package Antispam::Toolkit::Role::UserChecker;

use strict;
use warnings;
use namespace::autoclean;

use Antispam::Toolkit::Types qw( NonEmptyStr );
use Carp qw( croak );
use List::AllUtils qw( any );

use Moose::Role;
use MooseX::Params::Validate qw( validated_hash );

requires 'check_user';

around check_user => sub {
    my $orig = shift;
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        email    => { isa => NonEmptyStr, optional => 1 },
        ip       => { isa => NonEmptyStr, optional => 1 },
        username => { isa => NonEmptyStr, optional => 1 },
    );

    unless ( any {defined} @p{qw( email ip username )} ) {
        # Gets us out of Moose-land.
        local $Carp::CarpLevel = $Carp::CarpLevel + 1;
        croak 'You must pass an email, ip, or username to check_user';
    }

    return $self->$orig(%p);
};

1;

