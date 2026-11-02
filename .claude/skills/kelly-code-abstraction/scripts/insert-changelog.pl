#!/usr/bin/perl
# Insert a Changelog entry above the newest "## " heading (the first one in the file).
#   perl insert-changelog.pl <Changelog.md> <entry.md>
# The entry file holds the full entry, starting with its "## <date> (...)" heading and ending with a blank line.
use strict;
use warnings;

my ($changelog, $entryFile) = @ARGV;
die "usage: perl insert-changelog.pl <Changelog.md> <entry.md>\n" unless $changelog && $entryFile;

open(my $e, '<', $entryFile) or die "cannot read $entryFile: $!\n";
my $entry = do { local $/; <$e> };
close $e;
$entry =~ /\A## \d{4}-\d{2}-\d{2} \(/ or die "the entry must start with a dated heading, e.g. '## 2026-10-20 (package 26.10.20.832): ...'\n";
$entry .= "\n" unless $entry =~ /\n\n\z/;

open(my $f, '<', $changelog) or die "cannot read $changelog: $!\n";
my $text = do { local $/; <$f> };
close $f;
$text =~ s/^(## )/$entry$1/m or die "no '## ' heading found in $changelog\n";

open($f, '>', $changelog) or die "cannot write $changelog: $!\n";
print $f $text;
close $f;
print "inserted into $changelog\n";
