#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;
require Test::TableDriven;
sub hash  { $_[0] }
sub array { $_[0] }

Test::TableDriven->import(
    hash  => { 1 => '1',
               2 => '2',
             },
    array => [[ 1 => 1 ],
              [ 2 => 2 ],
             ],
);
