package XML::GRDDL::Transformation;

use 5.008;
use common::sense;
use base qw[XML::GRDDL::External];

use XML::GRDDL::Transformation::XSLT_1;
use XML::GRDDL::Transformation::RDF_EASE;

our $VERSION = '0.001';

sub new
{
	my $class = shift;
	my $self  = $class->SUPER::new(@_);
	
	my $response = $self->{grddl}->_fetch(
		$self->{uri},
		Referer  => $self->{referer},
		Accept   => 'application/xslt+xml, text/xslt, text/xsl, text/x-rdf+css, text/css',
		);
	
	$self->{'response'} = $response;
	
	if ($response->header('content-type') =~ m#xslt?#i
	||  $response->content =~ m#http://www.w3.org/1999/XSL/Transform#)
	{
		return bless $self, 'XML::GRDDL::Transformation::XSLT_1';
	}
	elsif ($response->header('content-type') =~ /text\/(css|x\-rdf\+css)/i)
	{
		return bless $self, 'XML::GRDDL::Transformation::RDF_EASE';
	}

	return $self;
}

sub uri
{
	my ($self) = @_;
	return $self->{uri};
}

sub transform
{
	my ($self, $input) = @_;
	warn "Cannot perform transformation: ".$self->{uri};
	return;
}

sub model
{
	my ($self, $input) = @_;
	my ($rdf, $type) = $self->transform($input);
	
	return $self->{grddl}->_rdf_model($rdf, $self->{referer}, $type, 1)
		if $rdf;
	
	return;
}

1;

__END__

=head1 NAME

XML::GRDDL::Transformation - represents a transformation

=head1 DESCRIPTION

The interface is a little weird.

=head2 Constructor

=over 4

=item C<< XML::GRDDL::Transformation->new($turi, $duri, [$grddl]) >>

Constructs a new transformation object.

$turi is the URI of the transformation itself; $duri is the document URI, used
for sending an HTTP Referer header, and for resolving relative URIs found in
the document; $grddl is an XML::GRDDL object used as a cache between
requests, and used for its C<ua> method.

=back

=head2 Methods

=over 4

=item C<< $transformation->uri >>

Returns the URI of the transformation.

=item C<< $transformation->transform($xml) >>

Transforms some XML, either an a well-formed XML string, or an
XML::LibXML::Document. Returns a string.

If called in list context returns a string, media type pair.

=item C<< $transformation->model($xml) >>

Transforms some XML and then parses the result as RDF. Returns an
RDF::Trine::Model.

The intermediate RDF format can be any format supported by
RDF::RDFa::Parser or RDF::Trine::Parser, including RDF/XML, Turtle
and XHTML+RDFa.

=back

=head1 SEE ALSO

L<XML::GRDDL>.

L<XML::GRDDL::Transformation::XSLT_1>,
L<XML::GRDDL::Transformation::RDF_EASE>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2008-2010 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
