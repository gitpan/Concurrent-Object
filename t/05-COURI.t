#!/usr/bin/perl -s
##
##
##
## Copyright (c) 2001, Vipul Ved Prakash.  All rights reserved.
## This code is free software; you can redistribute it and/or modify
## it under the same terms as Perl itself.
##
## $Id: 05-COURI.t,v 1.1.1.1 2001/06/10 14:39:39 vipul Exp $

use lib '../lib';
use Test;
BEGIN { plan tests => 11 };
use Concurrent::Object;
use URI::URL;
use Data::Dumper;
use Concurrent::Debug qw(debuglevel);

my $URL = "http://www.vipul.net/perl/software/concurrency.cgi?abc=xyz";

my $uril = new URI::URL ($URL);
my $uri = Concurrent('URI::URL')->new ($URL);

ok( $uril->abs(),        $uri->abs() );
ok( $uril->full_path(),  $uri->full_path() );
ok( $uril->path_query(), $uri->path_query() ); 
ok( $uril->crack(),      $uri->crack() );
ok( $uril->epath(),      $uri->epath() );
ok( $uril->netloc(),     $uri->netloc() );
ok( $uril->rel(),        $uri->rel() );
ok( $uril->scheme(),     $uri->scheme() );
ok( $uril->canonical(),  $uri->canonical() );
ok( $uril->as_string(),  $uri->as_string() );

my @pcl = $uril->path_components;
my @lc  = $uri->path_components;
ok ("@lc", "@pcl");
