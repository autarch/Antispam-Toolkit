package Antispam::Toolkit::Role::BerkeleyDB;

use strict;
use warnings;
use autodie;
use namespace::autoclean;

use Antispam::Toolkit::Types qw( Bool File NonEmptyStr DataFile );
use BerkeleyDB;
use DateTime;

use Moose::Role;
use MooseX::Params::Validate qw( validated_list );

with 'Antispam::Toolkit::Role::Database';

has database => (
    is       => 'ro',
    isa      => File,
    coerce   => 1,
    required => 1,
);

has name => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    builder => '_build_name',
);

has _db => (
    is       => 'ro',
    isa      => 'BerkeleyDB::Hash',
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_db',
);

sub _build_db {
    my $self = shift;

    die "The database file must already exist"
        unless -f $self->database();

    my $env = BerkeleyDB::Env->new(
        -Home  => $self->database()->dir(),
        -Flags => DB_INIT_CDB | DB_INIT_MPOOL,
    );

    return BerkeleyDB::Hash->new(
        -Filename => $self->database(),
        -Env      => $env,
    );
}

sub _build_name {
    my $self = shift;

    my $db_file = $self->database();

    return
        $db_file->basename() . ' - '
        . DateTime->from_epoch( epoch => $db_file->stat()->mtime() )
        ->iso8601();
}

sub build {
    my $class = shift;
    my ( $file, $database, $truncate ) = validated_list(
        \@_,
        file => {
            isa    => DataFile,
            coerce => 1,
        },
        database => {
            isa    => File,
            coerce => 1,
        },
        truncate => {
            isa     => Bool,
            default => 1,
        },
    );

    my $env = BerkeleyDB::Env->new(
        -Home  => $database->dir(),
        -Flags => DB_CREATE | DB_INIT_CDB | DB_INIT_MPOOL,
    );

    my $db = BerkeleyDB::Hash->new(
        -Filename => $database,
        -Flags    => DB_CREATE,
        -Env      => $env,
    );

    if ($truncate) {
        my $lock = $db->cds_lock();

        $db->truncate( my $count )
            and die
            "Fatal error trying to write to the BerkeleyDB file at $database";

        $class->_extract_data_from_file( $file, $db );

        # This seems to return a true value even if there's not a real error
        # (maybe in the case where it doesn't actually comptact?)
        $db->compact();

        $lock->cds_unlock();

    }
    else {
        $class->_extract_data_from_file( $file, $db );
    }

    return;
}

sub _extract_data_from_file {
    my $class = shift;
    my $file  = shift;
    my $db    = shift;

    open my $fh, '<', $file;

    while (<$fh>) {
        chomp;
        $class->_store_value( $db, $_ );
    }
}

sub match_value {
    my $self = shift;
    my $key  = shift;

    my $value;
    # The return value here indicates whether or not the key exists.
    $self->_db()->db_get( $key, $value );

    return $value;
}

1;
