#!/usr/bin/env perl
# Strip the <nav class="nav__links"> block from every learn page.
# Bottom tab bar handles all navigation site-wide now.
use strict;
use warnings;

my $dir = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/learn';
opendir(my $dh, $dir) or die;
my @files = map { "$dir/$_" } sort grep { /\.html$/ } readdir($dh);
closedir($dh);

my $touched = 0;
for my $fp (@files) {
  open(my $in, '<', $fp) or die;
  my $html = do { local $/; <$in> };
  close $in;
  my $orig = $html;

  # Remove the entire <nav class="nav__links"...>...</nav> block
  $html =~ s|<nav class="nav__links"[^>]*>.*?</nav>\s*||s;

  if ($html ne $orig) {
    open(my $out, '>', $fp) or die;
    print $out $html;
    close $out;
    $touched++;
    my $name = $fp; $name =~ s|.*/||;
    print "OK    $name\n";
  }
}
print "\n$touched updated.\n";
