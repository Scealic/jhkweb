#!/usr/bin/perl
# usage: organize.pl <backlog.md> <rules.tsv>
# Moves every item (with its indented sub-items) out of the file's "To Organize" (## or ###)
# into "## <Function>" > "### <Add|Change|Fix|Delete>": an open item before the first
# done item there, a done item at the end. Missing headings are created (a function at the end
# of the file, a sub-heading in Add/Change/Fix/Delete order). Keeps CRLF or LF.
# rules.tsv lines: <perl regex on the item's first line>\t<Function>\t<Sub>   (first match wins;
# end with ".\t<Function>\t<Sub>" as a catch-all). If any item matches no rule, nothing is written.
# Check the counts it prints, then run openfirst.pl and check.sh.
use strict; use warnings;
binmode STDOUT, ':utf8';
my ($file, $spec) = @ARGV;
open my $fh, '<:raw', $file or die $!; local $/; my $raw = <$fh>; close $fh;
my $crlf = $raw =~ /\r\n/;
$raw =~ s/\r\n/\n/g;
my @L = split /\n/, $raw, -1;
pop @L if @L && $L[-1] eq '';

open my $sh, '<:raw', $spec or die $!; my @rules;
for (split /\n/, do { local $/; <$sh> }) { s/\r$//; next unless /\S/; my @p = split /\t/; push @rules, [qr/$p[0]/, $p[1], $p[2]]; }

my %rank = (Add => 1, Change => 2, Fix => 3, Delete => 4);

# --- extract To Organize items
my ($ts) = grep { $L[$_] =~ /^(##|###) To Organize\s*$/ } 0..$#L; die "no To Organize" unless defined $ts;
my $level = ($L[$ts] =~ /^(#+)/)[0];
my $te = $ts + 1; $te++ while $te <= $#L && $L[$te] !~ /^#{2,${\ length $level}} /;
my @block = @L[$ts+1 .. $te-1];
my (@items, @keep);
for my $l (@block) {
  if ($l =~ /^- \[/) { push @items, [$l] }
  elsif ($l =~ /^\s+\S/ && @items) { push @{$items[-1]}, $l }
  elsif ($l =~ /\S/) { push @keep, $l }
}
splice @L, $ts+1, $te-$ts-1, ('', (@keep ? (@keep, '') : ()));

my @unmatched;
for my $it (@items) {
  my $text = $it->[0];
  my ($r) = grep { $text =~ $_->[0] } @rules;
  unless ($r) { print STDERR "UNMATCHED: ", substr($text,0,100), "\n"; die "unmatched item, file not written\n"; }
  my ($fn, $sub) = ($r->[1], $r->[2]);
  my $done = $text =~ /^- \[x\]/i;
  # find function
  my ($fi) = grep { $L[$_] eq "## $fn" } 0..$#L;
  unless (defined $fi) { push @L, '' if $L[-1] ne ''; push @L, "## $fn", ''; $fi = $#L - 1; }
  my $fe = $fi + 1; $fe++ while $fe <= $#L && $L[$fe] !~ /^## /;
  my ($si) = grep { $L[$_] eq "### $sub" } $fi+1 .. $fe-1;
  unless (defined $si) {
    my $at = $fe;
    for my $j ($fi+1 .. $fe-1) { if ($L[$j] =~ /^### (\w+)/ && ($rank{$1}//9) > $rank{$sub}) { $at = $j; last } }
    # back up over trailing blanks when inserting at section end
    if ($at == $fe) { $at-- while $at-1 > $fi && $L[$at-1] eq ''; splice @L, $at, 0, '', "### $sub", ''; $si = $at + 1; }
    else { splice @L, $at, 0, "### $sub", '', ''; $si = $at; }
    $fe = $fi + 1; $fe++ while $fe <= $#L && $L[$fe] !~ /^## /;
  }
  my $se = $si + 1; $se++ while $se <= $#L && $L[$se] !~ /^##/;
  my $ins;
  if (!$done) { ($ins) = grep { $L[$_] =~ /^- \[x\]/i } $si+1 .. $se-1; }
  unless (defined $ins) { $ins = $se; $ins-- while $ins-1 > $si && $L[$ins-1] eq ''; $ins = $si + 2 if $ins <= $si + 1; }
  splice @L, $ins, 0, @$it;
  # make sure a blank line follows the heading
  if ($L[$si+1] ne '') { splice @L, $si+1, 0, '' }
}
# normalize: blank line before every heading, collapse multiple blanks
my @out;
for my $l (@L) {
  if ($l =~ /^#/ && @out && $out[-1] ne '') { push @out, '' }
  next if $l eq '' && @out && $out[-1] eq '';
  push @out, $l;
}
pop @out while @out && $out[-1] eq '';
my $res = join("\n", @out) . "\n";
$res =~ s/\n/\r\n/g if $crlf;
open my $oh, '>:raw', $file or die $!; print $oh $res; close $oh;
printf STDERR "%s: moved %d, unmatched %d\n", $file, @items - @unmatched, scalar @unmatched;
if (@unmatched) { # put them back
  print STDERR "  UNMATCHED: ", substr($_->[0],0,100), "\n" for @unmatched;
  die "unmatched items; restore from backup\n";
}
