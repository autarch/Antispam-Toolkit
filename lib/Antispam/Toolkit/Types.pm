package Antispam::Toolkit::Types;

use strict;
use warnings;

use base 'MooseX::Types::Combine';

__PACKAGE__->provide_types_from(
    qw(
        Antispam::Toolkit::Types::Internal
        MooseX::Types::Common::Numeric
        MooseX::Types::Common::String
        MooseX::Types::Moose
        MooseX::Types::Path::Class
        )
);

1;

# ABSTRACT: Types for use by Antispam modules

__END__

=head1 DESCRIPTION

This module exports a number of types created via L<MooseX::Types>. In
addition to internal types, it also exports types from
L<MooseX::Types::Common::Numeric>, L<MooseX::Types::Common::String>,
L<MooseX::Types::Moose>, and L<MooseX::Types::Path::Class>.

=head1 TYPES

This module exports the following internally defined types:

=head2 DataFile

This is a subtype of the C<File> type provided by
L<MooseX::Types::Path::Class>. The file must exist and not be empty.

=head2 Details

This is an array reference of non-empty strings. It defines a coercion from a
string to an array reference. It is used by the L<Antispam::Toolkit::Result>
class.

=head2 NonNegativeNum

A non-negative number.

=head1 BUGS

See L<Antispam::Toolkit> for bug reporting details.

=cut
