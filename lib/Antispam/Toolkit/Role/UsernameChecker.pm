package Antispam::Toolkit::Role::UsernameChecker;

use strict;
use warnings;
use namespace::autoclean;

use Antispam::Toolkit::Types qw( NonEmptyStr );
use Carp qw( croak );
use List::AllUtils qw( any );

use Moose::Role;
use MooseX::Params::Validate qw( validated_hash );

requires 'check_username';

around check_username => sub {
    my $orig = shift;
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        username => { isa => NonEmptyStr, optional => 1 },
    );

    return $self->$orig(%p);
};

1;

# ABSTRACT: A role for classes which check whether an username is associated with spam

__END__

=head1 SYNOPSIS

  package MyUsernameChecker;

  use Moose;

  with 'Antispam::Toolkit::Role::UsernameChecker';

  sub check_username { ... }

=head1 DESCRIPTION

This role specifies an interface for classes which check whether a specific
username is associated with spam.

=head1 REQUIRED METHODS

Classes which consume this method must provide one method:

=head2 $checker->check_username( username => ... )

This method implements the actual spam checking for a username. The username
will be passed as a named parameter.

=head1 METHODS

This role provides an around modifier for the C<< $checker->check_username()
>> method. The modifier does validation on all the parameters, so there's no
need to implement this in the class itself.

=head1 BUGS

See L<Antispam::Toolkit> for bug reporting details.

=cut
