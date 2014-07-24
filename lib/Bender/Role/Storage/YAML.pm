package Bender::Role::Storage::YAML;
use strict;
use warnings;
use version;
qv(0.01);

use YAML::Syck;
use IO::AtomicFile;

use Moose::Role;

requires(qw(data read));

has data_file => (
    isa      => 'Str',
    is       => 'ro',
    required => 1,
    default => sub { 
		my $f; 
		$f = $_[0]->meta->name;
		$f =~ s/::/_/g; 
		return lc "$f.yaml"; 
	},
);

sub load {
    my ($self) = @_;
    if ( -e $self->{data_file} ) {
        my $data = LoadFile( $self->data_file );
        $self->read($data);
    }
}

sub save {
    my ($self) = @_;
    my $file = $self->data_file;
    warn "saving: $file";
    my $fh = IO::AtomicFile->open( $file, 'w' )
      || warn "couldn't open $file: $!";
    my $data = Dump $self->data();
    print $fh $data;
    $fh->close || warn "couldn't write to $file: $!";
}

sub DEMOLISH {
    my ($self) = @_;
    $self->save();
}

1;
