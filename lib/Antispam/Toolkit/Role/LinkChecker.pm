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

# ABSTRACT: A role for classes which check whether a link is spam

__END__

=head1 SYNOPSIS

  package MyLinkChecker;

  use Moose;

  with 'Antispam::Toolkit::Role::LinkChecker';

  sub check_link { ... }

=head1 DESCRIPTION

This role specifies an interface for classes which check whether a specific
link is spam.

=head1 REQUIRED METHODS

Classes which consume this method must provide one method:

=head2 $checker->check_link( ... )

This method implements the actual spam checking for a link. It must accept the
following named parameters:

=over 4

=item * link

The link to be checked. This must be a non-empty string.

=item * email

An email address associated with the link. This is optional.

=item * ip

An ip address associated with the link. This is optional.

=item * username

A username associated with the link. This is optional.

=back

=head1 METHODS

This role provides an around modifier for the C<< $checker->check_link() >>
method. The modifier does validation on all the parameters, so there's no need
to implement this in the class itself.

=head1 BUGS

See L<Antispam::Toolkit> for bug reporting details.

=cut
