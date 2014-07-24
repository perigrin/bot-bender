package Bender::Plugin::Wank;
use strict;
use warnings;
use Carp;

use version; qv(0.01);

use POE::Component::IRC::Plugin qw(:ALL);

#
# TODO: directed actions
# 'Bender wank $foo'
# /ctcp ACTION $channel starts $gerund $foo's $noun
# -- Nacho
#

sub new {
    my $class = shift;
    my $self = bless {gerunds => [gerunds()], nouns => [nouns()]}, $class;
    return $self;
}

sub PCI_register {
    my ( $self, $irc ) = @_;
    $self->{irc} = $irc;
    $irc->plugin_register( $self, 'SERVER', qw(public msg) );
    return 1;
}

sub PCI_unregister {
    my ( $self, $irc ) = @_;
    delete $self->{irc};
    return 1;
}

sub S_public {
    my ( $self, $irc, $nickstring, $channels, $message ) = @_;
    ( $message, $channels ) = ( $$message, $$channels );
    if ( $message =~ /^wank\s+it[!.]*?$/i ) {
	    warn "wanking into $channels->[0]";
		my $gerunds = $self->{gerunds};
		my $nouns = $self->{nouns};
        my $gerund = lc $gerunds->[ rand @$gerunds ];
        my $noun   = $nouns->[ rand @$nouns ];
        return $irc->yield(
            'ctcp' =>  $channels->[0],
            "ACTION gets busy $gerund $noun"
        );
    }
    return PCI_EAT_NONE;
}

sub S_msg { 
	my ($self,$irc,$nickstring,$channels,$message) = @_;
	($message, $channels) = ($$message, $$channels);
    my $from = _nick_via_nickstring($$nickstring);
	if ( $message =~ /^wank\s+it(?:\s+in\s+(#.*))?[!.]*?$/i ) {
	    my $gerunds = $self->{gerunds};
		my $nouns = $self->{nouns};
		my $gerund = lc $gerunds->[ rand @$gerunds ];
		my $noun   = $nouns->[ rand @$nouns ];		
		if ($1) {  
			warn "wanking into $channels->[0]";
		    return $irc->yield(
	            'ctcp' =>  $1,
	            "ACTION gets busy $gerund $noun"
	        );
		} 
		else {
		   warn "wanking at $from";
		   return $irc->yield(
		       'privmsg' =>  $from,
		       "try gettin' busy $gerund $noun"
		   );
		}
	}
	return PCI_EAT_NONE; 
}

sub _nick_via_nickstring { return ( split /!/, $_[0] )[0]; }

sub gerunds {
return grep { $_ } map { s/^\s+//; $_ } map { chomp; $_ } split /\n/, q(
  Adjusting
  Arguing with
  Arm-wrestling
  Assaulting
  Attacking
  Auditioning
  Badgering
  Baiting
  Bangin'
  Banging
  Bashing
  Basting
  Battling
  Beatin'
  Beating
  Being rough with
  Bleeding
  Blowing
  Bludgeoning
  Bobbing
  Bonging
  Booting up
  Boppin'
  Bopping
  Bouncing
  Boxing
  Boxing with
  Breaking
  Buckin'
  Buffin'
  Buffing
  Buggering
  Burping
  Buttering
  Caning
  Charming
  Checking
  Chilling
  Choking
  Churning
  Clamping
  Cleaning
  Cleaning out
  Clearing
  Clobbering
  Clubbing
  Coating
  Cocking
  Cooking with
  Corralling
  Cracking
  Cranking
  Crowning
  Cuddlin'
  Cuffing
  Dancing with
  Debugging
  Decongesting
  Digitally oscillating
  Discharging
  Disciplining
  Doin' a loner with
  Doing
  Doing battle with
  Doing the knuckle shuffle on
  Doodling
  Draining
  Duking
  Emptying
  Erupting
  Exercising
  Firing
  Firming
  Fisting
  Five-knuckle-shuffle on
  Flaying
  Flicking
  Flipping
  Floggin'
  Flogging
  Fondling
  Fooling with
  Freeing
  Frigging
  Gettin' jizzy with
  Getting a load off
  Getting in touch with
  Getting to know
  Going a couple of rounds with
  Going into battle with
  Grappling
  Greasin' up
  Greasing
  Gripping
  Hacking
  Hand-starting
  Handling
  Hanging out with
  Harping on
  Having a conversation with
  Having a one-night-stand with
  Having a play date with
  Having a tug-of-war with
  Having an arm-wrestle with
  Having sex with
  Helping
  Hitting
  Hoisting
  Holding
  Honing
  Honking
  Huffing on
  Hugging
  Humping
  Jackin'
  Jacking up
  Jammin'
  Jerkin'
  Jerking
  Jiggling
  Jimmying
  Jogging
  Joshing
  Juicing
  Kneading
  Knockin' over
  Knuckle shuffle on
  Knuckling
  Launching
  Leakin'
  Loving
  Lubing
  Making friends with
  Making like Hans Solo and stroking
  Mangling
  Manhandling
  Manipulating
  Massaging
  Milking
  Moisturizing
  Molesting
  Nerking
  Oiling
  Opping
  Paddling
  Pattin'
  Peeling
  Performing diagnostics on
  Petting
  Playin' with
  Playing peek-a-boo with
  Playing ping pong with
  Playing pocket polo with
  Playing tag with
  Playing tug-o-war with
  Playing with
  Pleasing
  Plunking
  Polishing
  Pounding
  Preparing
  Priming
  Pulling
  Pummeling
  Pumpin'
  Pumping
  Punchin'
  Punching
  Punishing
  Raising
  Ramming
  Resizing
  Rippin'
  Rolling
  Romancing
  Ropin'
  Roping
  Roughing up
  Rubbing
  Sanding
  Saying hello to
  Scalpin'
  Scouring
  Scraping
  Scratchin'
  Scratching
  Seasonin'
  Shakin' hands with
  Shaking
  Shaking coconuts from
  Shaking hands with
  Shaking the coconut milk of love from
  Sharpening
  Shellacking
  Shemping
  Shifting to fifth gear with
  Shining
  Shooting
  Shuckin'
  Slammin'
  Slamming
  Slap-Boxing
  Slappin'
  Slapping
  Slapping high fives with
  Slaying
  Slicking
  Smackin'
  Smacking
  Snapping
  Spanking
  Spending some quality time with
  Spit-polishing
  Spunking
  Spurtin'
  Squashing
  Squeezing
  Squishing
  Strainin'
  Strangling
  Stretching
  Striking
  Stripping
  Strokin'
  Stroking
  Strummin'
  Sucker-punching
  Swinging
  Taking his turn at
  Taming
  Tapping
  Taunting
  Teasing
  Tenderizing
  Test-firing
  Testing
  Thrashing
  Throbbing
  Thumping
  Thwackin'
  Tickling
  Touching
  Trolling for
  Tuggin'
  Tugging
  Tussling
  Twanging
  Tweaking
  Twisting
  Unloading
  Unmasking
  Unsheathing
  Unwrapping
  Using the Force on
  Varnishing
  Vibrating
  Violating
  Visiting
  Wacking
  Wagging
  Waking
  Walking
  Waltzing with
  Wanking
  Wanking with
  Warming up
  Washing
  Waving
  Waxing
  Whackin'
  Whacking
  Whippin'
  Whipping
  Whittling
  Whomping
  Wiggling
  Winding
  Wonking
  Working
  Working a cramp out of
  Wrestling
  Wrestling with
  Wringing
  Wringing out
  Yankin'
  Yanking
);
}

sub nouns() { 
return grep { $_ } map { s/^\s+//; $_ } map { chomp; $_ } split /\n/, q(
  a friendly weapon
  a stiff joint
  Abe Lincoln
  Agent Johnson
  my beef
  Bert
  Big Ed
  Bob and the twins
  Bobby
  Bubba
  Charlie 'till he throws up
  Cheetah
  Darth Vader
  dick
  Eddy
  Elvis
  Frank
  Happy Harry Hard-on
  heavy equipment
  Henry Longfellow
  Isaiah
  it
  Jack
  Jack McNasty
  Jamby
  Jimmy
  Jimmy Dean
  Johnnie One-Eye
  Johnson
  Kojak
  Little Richard
  the ManTool
  Mount Baldy
  Mount Love
  Mr. Happy
  Mr. Ho-Ho
  Mr. Johnson
  Mr. President
  Mr. Winkie
  Mr. Wong
  Mt. Barbell
  my horn
  my knockwurst
  my little brother Peter
  my love monkey
  my own
  my own business
  my six-inch
  my thing
  my wand
  Ol' Faithful
  ol' Josh
  old beater
  Old Faithful
  one's penis
  one's self
  Oscar
  Oscar in the closet
  Pappy
  Pedro
  Percy
  Percy in his palm
  Percy with the palm
  Peter Tork
  Prince William Sound with love oil
  Richard
  Shorty
  Skippy
  Slick Mittens
  someone you love
  Stonehenge
  the alligator
  the altar boy's dinner
  the antelope
  the antenna
  the axle
  the baby
  the baby seal
  the bad guy
  the bait
  the bald champ
  the bald guy 'til he pukes
  the bald-headed moose
  the balogna
  the baloney
  the balony pony
  the banana
  the bark off his wood
  the baseball bat
  the bayonet
  the beagle
  the beanpole
  the Beanstalk
  the Beast
  the bed flute
  the beefsteak
  the bic
  the big-nosed Rasta man
  the Bishop
  the blind webster
  the blister
  the blue-veined custard chucker
  the blue-veined junket pumper
  the bobo
  the bologna pony
  the bone
  the Bone-A-Phone
  the bone-a-thon
  the Bonzo
  the boss
  the bratworst
  the bread
  the Buddha for good luck
  the bulimic one-eyed monster
  the bull
  the bunny
  the burrito
  the candle
  the cane
  the car
  the carrot
  the cat pole
  the Charmin
  the cheeta
  the chicken
  the chrome dome
  the clam
  the clown
  the cobra
  the cockpit
  the cord
  the cork
  the corn
  the cow
  the crank
  the cream from the flesh Twinkie
  the cream of cock
  the crotch trombone
  the crusader
  the Cyclops
  the Cyclops 'til he throws up
  the czar
  the devil-dolphin
  the dill
  the dog
  the dolphin
  the dong
  the donkey
  the doodle
  the dragon
  the dragon's tail
  the dude
  the dummy
  the eel
  the electric goo gun
  the elephant's trunk
  the Elmo
  the Emperor
  the family jewels
  the fat man
  the fig
  the fire pole
  the fish
  the fish tank
  the fisherman
  the flag pole
  the flesh flute
  the flesh musket
  the FleshGopher
  the fountain
  the frank
  the frog
  the fuck out of his best friend
  the gator
  the General
  the gherkin
  the goalie
  the goat
  the goblin of love
  the gorilla
  the Governor
  the gun
  the ham
  the hammer
  the hand brake
  the hand cream dispenser
  the hand shuttle
  the handbrake
  the hard drive
  the heat-seeking moisture missile
  the hedge-hog
  the helmet
  the hoagie
  the hog
  the hostages
  the hot rod
  the hound
  the injun
  the itch
  the Jack in the Box
  the Jesuit
  the Jesuit and getting cockroaches
  the jizz monster
  the Jocelyn Elders Midterm
  the Johnson
  the joystick
  the jump rope
  the king
  the knob
  the lava lamp
  the leafless palm trunk
  the light saber
  the Lighthouse
  the lizard
  the log
  the long horn
  the love muscle
  the love pump
  the love rifle
  the love tree
  the magic one-eyed wonder weasel
  the Magic Wand
  the main drain
  the main vein
  the mainsail
  the male organ
  the mango
  the manhood
  the maypole
  the meat
  the meat missle
  the midget
  the mighty dick hinge
  the mink
  the mole
  the Monk
  the monkey
  the monster
  the moose
  the morning missile
  the mule
  the munchkin
  the muppet
  the muscle
  the obelisk
  the obvious
  the ol' 1 wood
  the ol' piss pump
  the old goal post
  the old lizard
  the old man
  the one-eyed burping gecko
  the One-Eyed Champ
  the one-eyed clown
  the one-eyed field mouse with the purple turtle-neck sweater
  the one-eyed monster
  the one-eyed postal worker out of his denim cell
  the one-eyed purple-headed warrior
  the one-eyed superhero
  the one-eyed trouser snake
  the one-eyed trouser trout
  the one-eyed walleye
  the one-eyed weasel
  the one-eyed wonder weasel
  the one-eyed worm
  the one-eyed yogurt thrower
  the one-handed air guitar
  the one-stringed guitar
  the oompa loompa
  the organ
  the paddle
  the pencil
  the penis
  the pepperoni
  the pickle
  the pink eraser
  the pink match
  the pink Mustang
  the pink torpedo
  the pipe
  the pipes
  the pirate
  the piss pipe
  the piss pump
  the pisser
  the plank
  the plumbing
  the pogo stick
  the pole
  the Polish salmon
  the pony
  the ponie
  the poodle
  the Pope
  the pork spear
  the pork stick
  the pork sword
  the porpoise
  the possum
  the President
  the presidential staff
  the priest
  the primate
  the pud
  the pump
  the pump action porridge gun
  the pumpkin
  the puppy
  the purple headed warrior
  the purple helmet
  the purple-helmeted warrior
  the Purple-Helmeted Warrior of Love
  the purple people pleaser
  the purple pimple
  the purple-veined kidney stabber
  the purple-headed custard chucker
  the purple-headed stormtrooper
  the purple-headed yogurt pistol
  the purple-headed yogurt slinger
  the python
  the radish
  the rat
  the rifle
  the rocket
  the rocking horse
  the rod
  the root
  the rope
  the royal red reproduction rod
  the sack
  the salami
  the salmon
  the satin-headed serpent
  the sausage
  the sea monkey
  the self-serve pump
  the Serpent
  the sex stick
  the shaft
  the shank
  the shellaleigh
  the sheriff and waiting for the posse to come
  the shit out of his incapacitated midget
  the single serving soup dispenser
  the skin bus
  the skin flute
  the slug
  the snake
  the snake with the turtleneck sweater
  the snorkel
  the snot outta Rotney
  the snotty end of my fuck stick
  the soft soap dispenser
  the spam javelin
  the sperm whale
  the spitting llama
  the squirmin' German
  the staff
  the staked vampire 'til he flames up
  the stallion
  the stand-up organ
  the stepson
  the stick
  the stiff
  the stump
  the sugar tree
  the sump-pump
  the Surgeon General
  the suspect
  the sword
  the tadpoles
  the tapioca tube
  the testicular squatters
  the throb knob
  the Thurmond
  the timber
  the tower of power
  the tree
  the trouser mouse
  the tube
  the tube of toothpaste
  the tube steak
  the turkey
  the turtle neck
  the two-toned trouser trout
  the unemployed
  the unicorn's horn
  the vandal
  the vein
  the veiny palm tree of lust
  the Viking
  the viper and making him spit poison
  the walrus
  the weasel
  the weeble
  the weed
  the weenie
  the whip
  the white-out pen
  the whopper
  the wiener
  the wild hog
  the willie
  the window washer
  the wire
  the witness
  the wolverine
  the wood
  the worm
  the yak 'til it spits back
  the yoyo
  the zipper trout
  trouser trout
  Wally the one-eyed wonder worm
  Wee Willie Winkle
  Willy
  Willy the one-eyed wonder-worm
  wood
  Yoosef
  his animal
  his bacon
  his bayonet
  his beef
  his bird
  his bologna
  his boloney
  his bone
  his boner
  his butter
  his carrot
  his chain
  his cheese-dog
  his chicken
  his chub
  his conker
  his corn
  his crank
  his dick fish into the gene pool
  his ding dong
  his dog
  his dong
  his donk
  his dripper
  his dumber brother
  his fire hose
  his flounder
  his Franklin
  his goalie
  his goat
  his hands with his beauty bar
  his helmet
  his hook
  his horn
  his hose
  his hot dog
  his instrument
  his Jackson
  his Jimmy
  his Joey
  his John Thomas
  his Johnson
  his little friend
  his load
  his log
  his love muscle
  his man-handle
  his manhood
  his match
  his meat
  his meat saber
  his mister
  his muscle
  his noodle
  his nuts
  his one-eyed vessel
  his organ
  his own
  his own horn
  his own leg
  his own thing
  his pencil
  his piece
  his piss pump
  his pisser
  his plank
  his plonker
  his poker
  his pole
  his power cord
  his prick
  his pud
  his purple-headed warrior
  his rifle
  his rope
  his set
  his sex pistol
  his shlong
  his special friend
  his staff
  his surfboard
  his taffy
  his tater
  his thing
  his throbber
  his tool
  his tubesteak
  his turtle
  his twanger
  his twinkie
  his weasel
  his wife's best friend
  his Willy
  his wire
  his wood
  his wookie
  his worm
  his Yoda
  himself
  himself at home
  himself in the crotch
  himself into emission
  his SPARQL Endpoint
  Yul Brynner
  the opbot
);
}

1;
