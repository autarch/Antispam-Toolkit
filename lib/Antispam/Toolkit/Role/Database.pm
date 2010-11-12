package Antispam::Toolkit::Role::Database;

use strict;
use warnings;
use namespace::autoclean;

use Moose::Role;

requires qw( match_value _store_value );

1;

