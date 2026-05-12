#!/usr/bin/env perl
# Inject GA4 + Bing verification placeholders into the <head> of every
# page on the site. Idempotent: skips files that already have GA4.
#
# After running, the user pastes:
#   - Their GA4 measurement ID into REPLACE_WITH_GA4_ID (2 places per file)
#   - Their Bing site verification code into REPLACE_WITH_BING_CODE (1 per file)
use strict;
use warnings;

my @files = (
  'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/index.html',
  glob('"G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/learn/"*.html'),
);

my $snippet = <<'EOF';

<!-- Bing Webmaster verification, replace placeholder when you've grabbed the code from bing.com/webmasters -->
<meta name="msvalidate.01" content="REPLACE_WITH_BING_CODE" />

<!-- Google Analytics 4, replace REPLACE_WITH_GA4_ID with your measurement ID (looks like G-XXXXXXXXXX) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=REPLACE_WITH_GA4_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'REPLACE_WITH_GA4_ID', { anonymize_ip: true });
</script>
EOF

my $touched = 0;
my $skipped = 0;
for my $fp (@files) {
  open(my $in, '<', $fp) or do { print "FAIL  $fp: $!\n"; next; };
  my $html = do { local $/; <$in> };
  close $in;

  if ($html =~ /REPLACE_WITH_GA4_ID|gtag\(\s*['"]config['"]/) {
    $skipped++;
    my $n = $fp; $n =~ s|.*/||;
    print "SKIP  $n (already has GA4)\n";
    next;
  }
  # Insert right before </head>
  if ($html =~ s{</head>}{$snippet</head>}) {
    open(my $out, '>', $fp) or die;
    print $out $html;
    close $out;
    $touched++;
    my $n = $fp; $n =~ s|.*/||;
    print "OK    $n\n";
  } else {
    print "WARN  $fp: no </head>\n";
  }
}
print "\nDone. $touched touched, $skipped skipped.\n";
