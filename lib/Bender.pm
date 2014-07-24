package Bot::Phenwick;
use 5.12.0;
use Moses;
use namespace::autoclean;
use experimental qw(switch);

server   'irc.perl.org';
nickname 'Flexo';
channels '#axkit-dahut';

plugins
  Trust => 'Bender::Plugin::Trust',
  Barfly => 'Bender::Plugin::Barfly',
  Wank => 'Bender::Plugin::Wank',
  ;

event irc_bot_addressed => sub {
    my ( $self, $nickstr, $channel, $msg ) = @_[ OBJECT, ARG0, ARG1, ARG2 ];
    my ($nick) = split /!/, $nickstr;
    given ($msg) {
        when (/^\?$/) {
            $self->privmsg( $channel => "$nick: ?" );
        }
    }
};

1;
__END__

