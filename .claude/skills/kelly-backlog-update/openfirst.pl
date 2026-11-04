#!/usr/bin/perl
# usage: openfirst.pl <backlog.md> ...
# Within every run of top-level items, puts the open items ("- [ ]") before the done ones ("- [x]"),
# keeping each item's indented sub-items with it and the order within each group. Keeps CRLF or LF.
use strict; use warnings;
for my $f (@ARGV) {
  open my $h,'<:raw',$f or die; local $/; my $t=<$h>; close $h;
  my $crlf = $t =~ /\r\n/; $t =~ s/\r\n/\n/g;
  my @L = split /\n/, $t, -1; my @out; my (@open,@done,$cur);
  my $flush = sub { push @out, map {@$_} @open, @done; @open=(); @done=(); };
  for my $l (@L) {
    if ($l =~ /^- \[( |x)\]/i) { $cur=[$l]; push @{ $1 eq ' ' ? \@open : \@done }, $cur; next }
    if ($l =~ /^\s+\S/ && $cur) { push @$cur, $l; next }
    $flush->(); $cur=undef; push @out, $l;
  }
  $flush->();
  my $r = join "\n", @out; $r =~ s/\n/\r\n/g if $crlf;
  open my $o,'>:raw',$f or die; print $o $r; close $o;
}
