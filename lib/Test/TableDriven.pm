# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package Test::TableDriven;
use strict;
use warnings;

__END__

=head1 NAME

Test::TableDriven - write tests, not scripts that run them

=head1 SYNOPSIS

   use A::Module qw/or two!/;
   use Test::TableDriven (
     foo => { got     => 'expected',
              another => 'test',
            },

     bar => [[some => 'more tests'],
             [that => 'run in order'],
             [refs => [qw/also work/]],
            ],
   );
     
   sub foo {
      my $got      = shift;
      my $expected = ...;
      return $expected;
   }    

   sub bar { same as foo }

=head1 DESCRIPTION

Writing table-driven tests is usually a good idea.  You can add test
cases by adding a line to your test file.  There's no code to fuck up,
so writing tests is as painless as possible.  Pain is bad, so
table-driven tests are good.

C<Test::TableDriven> makes writing the test drivers easy.  You simply
define your test cases and write a function to run them.
Test::TableDriven will compute how many tests need to be run, and then
run the tests.  You concentrate on your data and what you're testing,
not C<plan tests => scalar keys %test_cases + 42>.  And that's a good
thing.

=head1 WHAT DO I DO

Start by using the modules that you need for your tests:

   use strict;
   use warnings;
   use String::Length; # the module you're testing

Then write some code to test the module:

   sub strlen {
       my $got = shift;
       my $exp = String::Length->strlen($got);
       return $exp;
   }

Then write some tests cases:

   use Test::TableDriven (
       strlen => { foo => 3,
                   bar => 3,
                   ...,
                 },
   );

Now run the test file.  The output will look like:

   1..2
   ok 1 - strlen: foo => 3
   ok 2 - strlen: bar => 3

Note that the tests get run at C<Test::TableDriven->import> time, so
anything after the use line is basically ignored.

=head1 BUGS

Report them to RT, or patch them against the git repository at:

   git clone git://git.jrock.us/git/Test-TableDriven.git

(or L<http://git.jrock.us/>).

=head1 AUTHOR

Jonathan Rockway C<< <jrockway AT cpan.org> >>.

=head1 COPYRIGHT

Test::TableDriven is copyright (c) 2007 Jonathan Rockway.  You may
use, modify, and redistribute it under the same terms as Perl itself.

=cut

