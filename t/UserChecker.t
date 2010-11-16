use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

{
    package Checker;

    use Moose;

    with 'Antispam::Toolkit::Role::UserChecker';

    sub check_user { }
}

like(
    exception { Checker->new()->check_user() },
    qr{\QYou must pass an email, ip, or username to check_user at \E\S+\QUserChecker.t line \E\d+},
    'exception when no arguments are passed to check_user()'
);

done_testing();
