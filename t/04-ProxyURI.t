#!/usr/bin/perl -s
##
##
##
## Copyright (c) 2001, Vipul Ved Prakash.  All rights reserved.
## This code is free software; you can redistribute it and/or modify
## it under the same terms as Perl itself.
##
## $Id: 04-ProxyURI.t,v 1.2 2001/06/10 15:04:21 vipul Exp $

use lib '../lib';
use Test;
BEGIN { plan tests => 11 };
use Concurrent::Object::Proxy;
use URI::URL;
use Data::Dumper;

my $URL = "http://www.vipul.net/perl/software/concurrency.cgi?abc=xyz";

my $uril = new URI::URL ($URL);
my $uri = new Concurrent::Object::Proxy (
                Class => 'URI::URL', 
                Constructor => 'new', 
                Args => [$URL],
                ProxyOverloading => 'Yes',
          );


ok( $uril->abs(),       $uri->rv ( Id => $uri->call ( Method => 'abs' ) ) );
ok( $uril->full_path(), $uri->rv ( Id => $uri->call ( Method => 'full_path' ) ) );
ok( $uril->path_query(),$uri->rv ( Id => $uri->call ( Method => 'path_query' ) ) );
ok( $uril->crack(),     $uri->rv ( Id => $uri->call ( Method => 'crack' ) ) );
ok( $uril->epath(),     $uri->rv ( Id => $uri->call ( Method => 'epath' ) ) );
ok( $uril->netloc(),    $uri->rv ( Id => $uri->call ( Method => 'netloc' ) ) );
ok( $uril->rel(),       $uri->rv ( Id => $uri->call ( Method => 'rel' ) ) );
ok( $uril->scheme(),    $uri->rv ( Id => $uri->call ( Method => 'scheme' ) ) );
ok( $uril->canonical(), $uri->rv ( Id => $uri->call ( Method => 'canonical' ) ) );
ok( $uril->as_string(), $uri->rv ( Id => $uri->call ( Method => 'as_string' ) ) );

my @pcl = $uril->path_components;
my @lc  = $uri->rv ( Id => $uri->call ( Method => 'path_components', Context => 'list' ), Context => 'list' );
ok ("@lc", "@pcl");
