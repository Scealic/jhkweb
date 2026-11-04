#!/usr/bin/perl
# Check that the analysis scopes cover every source file exactly once, and count each scope's files.
#   perl scope-coverage.pl [scopes.json] [root]
# Defaults: ../references/scopes.json beside this script, root /c/repo/jhkweb.
# A path is a folder (recursive), a file, or "folder/*" (the files directly in that folder). Scopes with "coverage": false are skipped.
# Prints each scope's file count, scope paths that do not exist, files no scope covers (by folder) and files two scopes cover.
# Exit code 1 when a path is missing or a file is uncovered.
use strict;
use warnings;
use File::Find;
use File::Basename qw(dirname);
use JSON::PP;

my $scopesFile = shift // dirname(__FILE__) . '/../references/scopes.json';
my $root = shift // '/c/repo/jhkweb';
open(my $h, '<', $scopesFile) or die "cannot read $scopesFile: $!\n";
my $scopes = decode_json(do { local $/; <$h> });
close $h;

my @files;
for my $top ('Kelly-Windows-Data-v3/src', 'Kelly-Windows-v3/src', 'Kelly-Domain/src', 'Kelly-Revit-Logic-v5/src', 'Kelly-Revit-UI/src', 'Kelly-Revit-v5/src', 'Kelly-Revit-v5/modules') {
  next unless -d "$root/$top";
  find({ no_chdir => 1, wanted => sub {
    if (-d $_ && m{/(?:bin|obj|TestLogs|\.vs)$}) { $File::Find::prune = 1; return }
    return unless -f $_ && /\.(?:cs|xaml)$/;
    (my $r = $_) =~ s{^\Q$root\E/}{};
    push @files, $r;
  } }, "$root/$top");
}

sub covers {
  my ($path, $file) = @_;
  if ($path =~ m{^(.*)/\*$}) { my $d = $1; return $file =~ m{^\Q$d\E/[^/]+$} }
  return $file eq $path || index($file, "$path/") == 0;
}

my (%owners, @missing, $bad);
for my $s (@$scopes) {
  next if defined $s->{coverage} && !$s->{coverage};
  my $n = 0;
  for my $p (@{ $s->{paths} }) {
    (my $d = $p) =~ s{/\*$}{};
    push @missing, "$s->{key}: $p" unless -e "$root/$d";
  }
  for my $f (@files) {
    next unless grep { covers($_, $f) } @{ $s->{paths} };
    next if grep { covers($_, $f) } @{ $s->{exclude} // [] };
    push @{ $owners{$f} }, $s->{key};
    $n++;
  }
  printf "%-30s %4d files\n", $s->{key}, $n;
}
my @uncovered = grep { !$owners{$_} } @files;
my @twice = grep { $owners{$_} && @{ $owners{$_} } > 1 } @files;
printf "== %d source files; %d uncovered, %d in two scopes, %d scope paths missing\n", scalar @files, scalar @uncovered, scalar @twice, scalar @missing;
print "  missing path: $_\n" for @missing;
my %byDir;
$byDir{ dirname($_) }++ for @uncovered;
printf "  uncovered: %s (%d files)\n", $_, $byDir{$_} for sort keys %byDir;
print "  in two scopes: $_ (" . join(', ', @{ $owners{$_} }) . ")\n" for @twice;
exit((@uncovered || @missing) ? 1 : 0);
