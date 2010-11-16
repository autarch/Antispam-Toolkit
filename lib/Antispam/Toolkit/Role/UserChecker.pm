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

# ABSTRACT: A role for classes which check whether a user is a spammer

__END__

=head1 SYNOPSIS

  package MyUserChecker;

  use Moose;

  with 'Antispam::Toolkit::Role::UserChecker';

  sub check_user { ... }

=head1 DESCRIPTION

This role specifies an interface for classes which check whether a specific
user is a spammer.

=head1 REQUIRED METHODS

Classes which consume this method must provide one method:

=head2 $checker->check_user( ... )

This method implements the actual spam checking for a user. It must accept the
following named parameters:

=over 4

=item * user

The user to be checked. This must be a non-empty string.

=item * email

An email address associated with the user. This is optional.

=item * ip

An ip address associated with the user. This is optional.

=item * username

A username associated with the user. This is optional.

=back

=head1 METHODS

This role provides an around modifier for the C<< $checker->check_user() >>
method. The modifier does validation on all the parameters, so there's no need
to implement this in the class itself.

The modifier also checks that at least one of the parameters has been
provided, and croaks if this is not the case.

=head1 BUGS

See L<Antispam::Toolkit> for bug reporting details.

=cut
