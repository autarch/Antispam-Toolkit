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
