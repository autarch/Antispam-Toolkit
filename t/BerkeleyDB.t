use strict;
use warnings;

use BerkeleyDB::Hash;
use File::Temp qw( tempdir );
use Path::Class qw( dir file );

use Test::More 0.88;

my $dir = dir( tempdir( CLEANUP => 1 ) );

my $file = $dir->file('listed_email_7.db');

{

    package MyBDB;

    use Moose;
    use MooseX::StrictConstructor;

    with 'Antispam::Toolkit::Role::BerkeleyDB';

    sub _store_value {
        my $self  = shift;
        my $db    = shift;
        my $value = shift;

        $db->db_put( $value => 1 );

        return;
    }
}

{
    MyBDB->build(
        database => $file,
        file     => file( 't', 'data', 'listed_email_7.txt' ),
    );

    ok(
        -f $file,
        'build creates a new Berkeley DB file'
    );

    my $db = BerkeleyDB::Hash->new( -Filename => $file );

    for my $email (qw( foo@example.com bar@example.com )) {
        my $val;
        $db->db_get( $email, $val );

        ok(
            $val,
            "Berkeley DB file contains $email"
        );
    }

    {
        my $val;
        $db->db_get( 'autarch@urth.org', $val );

        ok(
            !$val,
            'Berkeley DB file does not contain autarch@urth.org'
        );
    }
}

{
    my $sfsdb = MyBDB->new(
        database => $file,
        name     => 'listed email 7',
    );

    for my $email (qw( foo@example.com bar@example.com )) {
        ok(
            $sfsdb->match_value($email),
            "Berkeley DB file contains $email (match_value method)"
        );
    }

    ok(
        !$sfsdb->match_value('autarch@urth.org'),
        'Berkeley DB file does not contain autarch@urth.org (match_value method)'
    );
}

{
    my $sfsdb = MyBDB->new( database => $file );

    like(
        $sfsdb->name(),
        qr/^listed_email_7\.db - \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d$/,
        'default name includes file basename and last mod time'
    );
}

done_testing();
