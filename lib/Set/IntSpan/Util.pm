package Set::IntSpan::Util;

use 5.010001;
use strict;
use warnings;

use Exporter 'import';

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(intspans2str);

sub intspans2str {
    require Set::IntSpan;

    my $opts = ref($_[0]) eq 'HASH' ? shift : {};
    $opts->{dash} //= "-";
    $opts->{comma} //= ", ";

    my @sets = Set::IntSpan->new(@_)->sets;
    my @res;
    for my $set (@sets) {
        my $min = $set->min;
        my $max = $set->max;
        my ($smin, $smax);
        if (!defined($min)) {
            $smin = "-Inf";
        }
        if (!defined($max)) {
            $smax = defined $min ? "Inf" : "+Inf";
        }
        if (defined $min && defined $max && $min == $max) {
            push @res, $min;
        } else {
            push @res, ($smin // $min) . $opts->{dash} . ($smax // $max);
        }
    }
    join($opts->{comma}, @res);
}

1;
# ABSTRACT: Utility routines related to integer spans

=head1 SYNOPSIS

 use Set::IntSpan::Util qw(intspans2str);

 $str = intspans2str(1);           # => "1"
 $str = intspans2str(1,2,3,4,5);   # => "1-5"
 $str = intspans2str(1,3,4,6,8);   # => "1, 3-4, 6-8"


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 intspans2str

Usage:

 my $str = intspans2str([ \%opts, ] @set_spec);

Given set specification, return a canonical string representation of the set.

This function passes the arguments to L<Set::IntSpan>'s constructor and then
return a canonical string representation of the set, which is a comma-separated
representation of each contiguous ranges. A single-integer range is represented
as the integer. A multiple-integers range from A to B is represented as "A-B".
Examples:

 1
 1-3
 1-3, 5-8
 -Inf-2, 5-8
 5-8, 10-Inf
 -Inf-+Inf

An optional hashref can be given in the first argument for options. Known
options:

=over

=item * dash

Default C<->.

=item * comma

Default C<, >.


=head1 SEE ALSO

L<Set::IntSpan>

=cut
