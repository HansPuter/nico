#!/usr/bin/perl

BEGIN { push @INC, '/home/peter/perl5/lib/perl5/'; }

# Modules used
use strict;
use warnings;

use Term::ReadKey;
use AtExit;
use Switch;

use constant { true => 1, false => 0 };

sub disableRawMode
{
	print "disableRawMode\n";
	ReadMode 0;
	#my $stdin = IO::Termios->new( \*STDIN );
	#$stdin->setflags( "+icanon", "+echo" );
	#$stdin->setflag_echo( 1 );	
}

sub enableRawMode
{
	ReadMode 5; # ultra-raw
				# Echo off, unbuffered, signals disabled, Xon/Xoff 
                # disabled, 8-bit mode enabled if parity permits,
                # and CR to CR/LF translation turned off., turn off controls keys
	#my $stdin = IO::Termios->new( \*STDIN );
	#$stdin->setflags( "-echo", "-icanon" );
	#$stdin->setflag_echo( 0 );	
	#$stdin->cfmakeraw
}

sub iscntrl
{
	my ($p) = @_;
	if (ord($p) > 31 && ord($p) < 127) {
		return false;
	}

	return true;
}

sub CTRL_KEY
{
	my ($p) = @_;
	return ord($p) & 0x1f;
}

sub editorReadKey 
{
	my $key = "";
	while (not defined ($key = ReadKey(0))) {
	}

  	return $key;
}

sub editorProcessKeypress 
{
  	my $key = editorReadKey;
  	my $keyno = ord($key);
  	switch ($keyno) {
		case (CTRL_KEY("q")) {	# Crtl-Q quits
			die "1: quit pressed!\r\n";
		}
		else {
			print "?$keyno ";
		}
  	}
}

sub editorRefreshScreen 
{
  print "\x1b[2J";
  print "\x1b[H";
}

###############################################################################
# MAIN
###############################################################################

sub main 
{
	enableRawMode();

    my $scope2 = AtExit->new;
    $scope2->atexit( \&disableRawMode);
	
	while (true) {
		editorRefreshScreen();
		editorProcessKeypress();
	}

}

main();
