package Antispam::Toolkit::Role::Database;

use strict;
use warnings;
use namespace::autoclean;

use Moose::Role;

requires qw( match_value );

1;

# ABSTRACT: An interface-only role for classes store and match values

__END__

=head1 DESCRIPTION

This role should be consumed by any class which can store and match values. It
specifies a common interface for these classes, but does not specify an
implementation.

=head1 REQUIRED METHODS

This role requires one method:

=head2 $db->match_value($value)

This method takes a value and returns true if it is in the database, and false
if not. The exact mechanics of how matching is done are left up to the
implementation. This means you a match can be an exact match, a regular
expression match, etc.

=head1 BUGS

See L<Antispam::Toolkit> for bug reporting details.

=cut
