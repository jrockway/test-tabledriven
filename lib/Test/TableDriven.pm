# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package Test::TableDriven;
use strict;
use warnings;
use Test::More;

sub import {
    my $class = shift;
    my %tests = @_;

    my %code;
    
    my ($caller) = caller;
    # verify that the tests are callable
    foreach my $sub (keys %tests) {
        no strict 'refs';
        $code{$sub} = *{$caller. '::'. $sub}{CODE} or
          die "cannot find a sub in '$caller' to call for '$sub' tests";
    }

    # we parse the tests, put them in @todo, then run them
    my @todo;
    foreach my $test (keys %tests) {
        my $code  = $code{$test};
        my $cases = $tests{$test};
        my $t = sub { my @a = @_; sub { _run_test($code, $test, @a) }};

        if (ref $cases eq 'HASH') {
            foreach my $input (keys %{$cases}) {
                push @todo, $t->($input, $cases->{$input});
            }
        }

        elsif (ref $cases eq 'ARRAY') {
            foreach my $case (@{$cases}) {
                push @todo, $t->($case->[0], $case->[1]);
            }
        }
        
        else {
            die "I don't know how to run the tests under key '$test'";
        }
    }
    
    # now run them
    plan tests => scalar @todo;
    $_->() for @todo;
    
    return;
}

sub _run_test {
    my ($code, $test, $in, $expected) = @_;
    
    my $got = $code->($in);
    is($got, $expected, "$test: $in => $expected");
}

1;
__END__

=head1 NAME

Test::TableDriven - write tests, not scripts that run them

=head1 SYNOPSIS

   use A::Module qw/or two!/;
   use Test::TableDriven (
     foo => { input   => 'expected output',
              another => 'test',
            },

     bar => [[some => 'more tests'],
             [that => 'run in order'],
             [refs => [qw/also work/]],
             [[qw/this is also possible/] => { and => 'it works' }],
            ],
   );
     
   sub foo {
      my $in  = shift;
      my $out = ...;
      return $out;
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
   ok 1 - strlen: bar => 3
   ok 2 - strlen: foo => 3

Note that the tests get run at C<Test::TableDriven->import> time, so
anything after the use line is basically ignored.

=head1 DETAILS

I'm not in a prose-generation mood right now, so here's a list of
things to keep in mind:

=over 4

=item *  

Tests are run at import time. 

=item *  

If a subtest is not a subroutine name in the current package, the
whole test file will die.

=item *  

If a subtest definition is a hashref, the tests won't be run in order.
If it's an arrayref of arrayrefs, then the tests are run in order.

=item *  

If a test case "expects" a reference, C<is_deeply> is used to compare
the expected result and what your test returned.  If it's just a
string, C<is> is used.

=item *  

Don't run extra tests.

=item *  

Don't print to STDOUT.

=item * 

Especially don't print TAP to STDOUT :)

=back

=head1 BUGS

Report them to RT, or patch them against the git repository at:

   git clone git://git.jrock.us/Test-TableDriven

(or L<http://git.jrock.us/>).

=head1 AUTHOR

Jonathan Rockway C<< <jrockway AT cpan.org> >>.

=head1 COPYRIGHT

Test::TableDriven is copyright (c) 2007 Jonathan Rockway.  You may
use, modify, and redistribute it under the same terms as Perl itself.

=cut
