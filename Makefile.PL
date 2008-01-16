use strict;
use warnings;
use inc::Module::Install;

name('Test-TableDriven');
all_from('lib/Test/TableDriven.pm');

requires 'Data::Dumper';
requires 'Filter::EOF';
requires 'Test::More';
WriteAll();
