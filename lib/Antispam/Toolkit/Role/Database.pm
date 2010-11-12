package Antispam::Toolkit::Role::Database;

use strict;
use warnings;
use namespace::autoclean;

use Moose::Role;

requires qw( contains_value _store_value );

1;

