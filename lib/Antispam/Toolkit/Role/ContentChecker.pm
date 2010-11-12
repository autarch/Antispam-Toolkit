package Antispam::Toolkit::Role::ContentChecker;

use strict;
use warnings;
use namespace::autoclean;

use Antispam::Toolkit::Types qw( ArrayRef NonEmptyStr );
use List::AllUtils qw( first );

use Moose::Role;
use MooseX::Params::Validate qw( validated_hash );

requires qw( check_content _build_accepted_content_types );

has _accepted_content_types => (
    is       => 'bare',
    isa      => ArrayRef [NonEmptyStr],
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_accepted_content_types',
);

around check_content => sub {
    my $orig = shift;
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        content_type => { isa => NonEmptyStr },
        content      => { isa => NonEmptyStr },
        email        => { isa => NonEmptyStr, optional => 1 },
        ip           => { isa => NonEmptyStr, optional => 1 },
        username     => { isa => NonEmptyStr, optional => 1 },
    );

    return
        unless first { $_ eq $p{content_type} }
        @{ $self->_accepted_content_types() };

    return $self->$orig(@_);
};

1;

