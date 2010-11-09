package Antispam::Toolkit::Types::Internal;

use strict;
use warnings;

use Archive::Zip qw( AZ_OK );
use File::Temp qw( tempdir );
use Path::Class qw( dir file );

use MooseX::Types -declare => [
    qw(
        DataFile
        )
];

use MooseX::Types::Path::Class qw( File );

subtype DataFile,
    as File,
    where { -f $_ && -s _ },
    message { "The filename you provided ($_) is either empty or does not exist" };

