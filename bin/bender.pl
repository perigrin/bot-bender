#!/usr/bin/perl
use 5.12.1;
use warnings;
use lib qw(lib);

use Daemon::Control;
use Bender;

exit Daemon::Control->new(
    name        => 'Flexo',
    user        => 'bender',
    program     => sub {  Bot::Phenwick->new->run },
    stdout_file => '/usr/local/bender/log/stdout.log',
    stderr_file => '/usr/local/bender/log/stderr.log',
    pid_file    => '/var/run/bender/bender.pid',
)->run;

__END__
