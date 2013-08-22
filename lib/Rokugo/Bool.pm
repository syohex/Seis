package Rokugo::Bool;
use strict;
use warnings;
use 5.018000;

package # Hide from PAUSE
    Bool;

my ($true, $false);

use overload
    '""' => sub { ${$_[0]} },
    '!' => sub { ${$_[0]} ? $false : $true },
    fallback => 1;

my ($true_val, $false_val, $bool_vals);

BEGIN {
    my $t = 1;
    my $f = 0;
    $true  = do {bless \$t, 'Bool'};
    $false = do {bless \$f, 'Bool'};

    $true_val  = overload::StrVal($true);
    $false_val = overload::StrVal($false);
    $bool_vals = {$true_val => 1, $false_val => 1};
}
sub True() { $true }
sub False() { $false }

sub true()  { $true }
sub false() { $false }
sub boolean($) {
    die "Not enough arguments for Bool::boolean" if scalar(@_) == 0;
    die "Too many arguments for Bool::boolean" if scalar(@_) > 1;
    return not(defined $_[0]) ? false :
    "$_[0]" ? $true : $false;
}
sub _isBoolean($) {
    not(defined $_[0]) ? false :
    (exists $bool_vals->{overload::StrVal($_[0])}) ? true : false;
}

sub TO_JSON { ${$_[0]} ? \1 : \0 }

sub isa {
    my ($self, $stuff) = @_;
    return $self->isa($stuff->{name}) if UNIVERSAL::isa($stuff, 'Rokugo::Class');
    return UNIVERSAL::isa($self, $stuff);
}

1;