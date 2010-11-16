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

# ABSTRACT: A role for classes which check whether a piece of content is spam

__END__

=head1 SYNOPSIS

  package MyContentChecker;

  use Moose;

  with 'Antispam::Toolkit::Role::ContentChecker';

  sub check_content { ... }

=head1 DESCRIPTION

This role specifies an interface for classes which check whether a piece of
content is spam.

=head1 ATTRIBUTES

This role provides one attribute:

=head2 $checker->_accepted_content_types()

This is an array reference of non-empty strings. Each string should be a MIME
type. This attribute cannot be set by the constructor. The class consuming the
role must provide a C<< $checker->_build_accepted_content_types() >> method.

=head1 REQUIRED METHODS

Classes which consume this method must provide two methods:

=head2 $checker->_build_accepted_content_types()

This method should return an array reference of mime types which the class can
check, such as "text/html", "text/plain", etc.

=head2 $checker->check_content( ... )

This method implements the actual spam checking for a piece of content. It
must accept the following named parameters:

=over 4

=item * content_type

The MIME type for the piece of content.

=item * content

The content itself. This must be a non-empty string.

=item * email

An email address associated with the content. This is optional.

=item * ip

An ip address associated with the content. This is optional.

=item * username

A username associated with the content. This is optional.

=back

=head1 METHODS

This role provides an around modifier for the C<< $checker->check_content() >>
method. The modifier does validation on all the parameters, so there's no need
to implement this in the class itself.

If the provided C<content_type> is not one of the accepted types, the original
method will not be called.

=head1 BUGS

See L<Antispam::Toolkit> for bug reporting details.

=cut

