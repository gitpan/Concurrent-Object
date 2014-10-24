#!/usr/bin/perl -sw
##
## Concurrent::Channel::LinkedPipes;
##
## Copyright (c) 2001, Vipul Ved Prakash.  All rights reserved.
## This code is free software; you can redistribute it and/or modify
## it under the same terms as Perl itself.
##
## $Id: LinkedPipes.pm,v 1.2 2001/06/10 15:04:16 vipul Exp $

package Concurrent::Channel::LinkedPipes;
use Concurrent::Data::Serializer;
use IO::Handle;
use Data::Dumper;
use Concurrent::Debug qw(debug);
use vars qw($VERSION);

$VERSION = do { my @r = (q$Revision: 1.2 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r }; 


sub new { 

    my ($class, %params) = @_;
    my %self = (%params);

    $self{Payload} ||= "Data";
    $self{serializer} = new Concurrent::Data::Serializer Method => 'Storable' if $self{Payload} eq 'Perl';
    pipe (R,W); pipe (R1, W1);
    @self{qw(pid R W R1 W1)} = ($$, \*R, \*W, \*R1, \*W1);

    return bless \%self, $class;

} 


sub init { 

    my $self = shift;
    my $bufvar;
    if ($$ == $$self{pid}) { 
        $$self{W}->close;
        $$self{R1}->close; 
        $$self{W1}->autoflush();
    } else { 
        $$self{R}->close;
        $$self{W1}->close;
        $$self{W}->autoflush();
    }

}


sub getline { 

    my $self = shift;
    my $line;

    if ($$ == $$self{pid}) { 
        $line = $$self{R}->getline;
    } else { 
        $line = $$self{R1}->getline
    }

    if ($$self{Payload} eq 'Perl') { 
        return unless $line;
        $line = $self->{serializer}->deserialize ($line);
    } 

    return $line;

}


sub print { 

    my ($self, $data) = @_;

    if ($$self{Payload} eq 'Perl') { 
        $data = $self->{serializer}->serialize ($data);
    } 

    if ($$ == $$self{pid}) {
        return $$self{W1}->print($data);
    } else {
        return $$self{W}->print($data);
    }

}


sub destroy { 

    my $self = shift;
    if ($$ == $$self{pid}) { 
        $$self{R}->close;
        $$self{W1}->close; 
    } else { 
        $$self{W}->close;
        $$self{R1}->close;
    }

}


1;


