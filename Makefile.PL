use strict;
use warnings;

use inc::Module::Install;

my $dist = 'XML-GRDDL';
my $fn   = "lib/$dist.pm"; $fn =~ s#-#/#g;

name                $dist;
perl_version_from   $fn;
version_from        $fn;
abstract_from       $fn;
readme_from         $fn;
author              'Toby Inkster <tobyink@cpan.org>';
license             'perl';

requires            'Carp'               => '1.00';
requires            'common::sense'      => 0;
requires            'CSS'                => 0;
requires            'CSS::Parse::PRDGrammar' => 0;
requires            'Data::UUID'         => 0;
requires            'Exporter'           => 0;
requires            'RDF::RDFa::Parser'  => '1.094';
requires            'RDF::Trine'         => '0.124';
requires            'Scalar::Util'       => 0;
test_requires       'Test::More'         => '0.61';
requires            'URI'                => '1.30';
requires            'URI::Escape'        => 0;
requires            'XML::LibXML'        => '1.60';
requires            'XML::LibXSLT'       => 0;
recommends          'XML::Saxon::XSLT2'  => '0.003';

resources(
	'homepage'   => "http://search.cpan.org/dist/$dist/",
	'repository' => "http://goddamn.co.uk/viewvc/perlmods/$dist/",
	'bugtracker' => "http://rt.cpan.org/Dist/Display.html?Queue=$dist",
	);
	
write_doap_changes;
write_doap_changes_xml;

include 'Test::Signature';
auto_install;
WriteAll(
	'meta' => 1,
	'sign' => 1,
	);
