package Bender::Plugin::Barfly;
use strict;
use POE::Component::IRC::Plugin qw(PCI_EAT_NONE);
use Regexp::Common qw(IRC pattern);
use Bone::Easy qw(pickup);

sub depends { qw( Bender::Core::BotAddressed ) }

my $NICK         = $RE{IRC}{nick}{-keep};
my $CHANNEL      = $RE{IRC}{channel}{-keep};
my $hey_baby     = qq[^hey\\s+baby[!?.]*];
my $how_you_doin = qq[^how\\s+you\\s+doin[?.!]*];
my $hit_on_who   = qq[^hit on[:,]?\\s*$NICK\\s*(?:in\\s+$CHANNEL)?[?.!]*];

pattern
  name   => [qw[COMMAND hit_on]],
  create => qq[$hit_on_who],
  ;

pattern
  name   => [qw[COMMAND hey_baby]],
  create => qq[$hey_baby],
  ;

pattern
  name   => [qw[COMMAND how_you_doin]],
  create => qq[$how_you_doin],
  ;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{responses} = [ map { chomp; [ split /\s+/, $_, 2 ] } <DATA> ];
    return $self;
}

sub PCI_register {
    my ( $self, $irc ) = @_;
    $self->{irc} = $irc;
    $irc->plugin_register( $self, 'SERVER', qw(msg bot_addressed public) );
    return 1;
}

sub PCI_unregister {
    my ( $self, $irc ) = @_;
    delete $self->{irc};
    return 1;
}

sub S_msg {
    my ( $self, $irc, $nickstring, $to, $message ) = @_;
    $message = $$message;
    if ( my ( $who, $where ) = $message =~ $RE{COMMAND}{hit_on}{-i} ) {
        $irc->yield( privmsg => $where => $who . ': ' . pickup );
    }
    return PCI_EAT_NONE;
}

sub S_bot_addressed {
    my ( $self, $irc, $nickstring, $channels, $message ) = @_;
    $message = $$message;
    my @channels = @{$$channels};
    if ( my ( $who, $where ) = $message =~ $RE{COMMAND}{hit_on} ) {
        if ($where) { @channels = ($where) }
        for my $channel (@channels) {
            $irc->yield( privmsg => $channel => $who . ': ' . pickup );
        }
    }
    elsif ( $message =~ $RE{COMMAND}{hey_baby}{-i} ) {
        my $who = ( split /!/, $$nickstring )[0];
        for my $channel (@channels) {
            $irc->yield( privmsg => $channel => $who . ': ' . pickup );
        }
    }
    elsif ( $message =~ $RE{COMMAND}{how_you_doin}{-i} ) {
        my $who = ( split /!/, $$nickstring )[0];
        for my $channel (@channels) {
            $irc->yield( privmsg => $channel => $who . ': ' . pickup );
        }
    }
    return PCI_EAT_NONE;
}

sub S_public {
    my ( $self, $irc, $nickstring, $channels, $message ) = @_;
    $message = $$message;
    my @channels = @{$$channels};
    if ( $message =~ $RE{COMMAND}{hey_baby}{-i} ) {
        my $who = ( split /!/, $$nickstring )[0];
        for my $channel (@channels) {
            $irc->yield( privmsg => $channel => $who . ': ' . pickup );
        }
    }
    elsif ( $message =~ $RE{COMMAND}{how_you_doin}{-i} ) {
        my $who = ( split /!/, $$nickstring )[0];
        for my $channel (@channels) {
            $irc->yield( privmsg => $channel => $who . ': ' . pickup );
        }
    }
    return PCI_EAT_NONE;
}

=for example
sub hey_baby 
	:Public(  $RE{PUBLIC}{hey_baby} ) 
	:Public(  $RE{PUBLIC}{how_you_doin} )
{
	my ($self, $irc, $ctxt) = @_;
	my $nick = (split(/!/, $ctxt->{nickstring}))[0];
	my @channels = @{ $ctxt->{channels} };
	for my $channel (@channels) {
		$irc->yield(privmsg => $channel => $nick . ': ' . pickup);
	}
}
=cut

1;
__END__
