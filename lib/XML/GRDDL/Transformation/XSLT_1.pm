package XML::GRDDL::Transformation::XSLT_1;

use 5.008;
use common::sense;
use base qw[XML::GRDDL::Transformation];

use Scalar::Util qw[blessed];
use XML::LibXML;
use XML::LibXSLT;

our $VERSION = '0.001';

sub transform
{
	my ($self, $input) = @_;
	
	my $response = $self->{'response'};
	
	my $parser    = XML::LibXML->new();
	$parser->base_uri($response->base);
	my $style_doc = $parser->parse_string($response->content);
	my $xslt      = XML::LibXSLT->new();
	my $stylesheet;
	local $@ = undef;
	eval { $stylesheet = $xslt->parse_stylesheet($style_doc); };
	warn $@ if $@;

	if ($stylesheet && !$@)
	{
		unless (blessed($input) && $input->isa('XML::LibXML::Document'))
		{
			$parser->base_uri($self->{referer});
			$input = $parser->parse_string($input);
		}
		
		my $results = $stylesheet->transform($input);	
		
		return ($stylesheet->output_as_chars($results), $stylesheet->media_type) if wantarray;
		return $stylesheet->output_as_chars($results);
	}
	
	return;
}

1;

__END__

=head1 NAME

XML::GRDDL::Transformation::XSLT_1 - represents an XSLT transformation

=head1 DESCRIPTION

Implements XSLT transformations. Uses L<XML::LibXSLT>, so
supports whatever XSLT is supported by libxslt should work.

=head1 SEE ALSO

L<XML::GRDDL>, L<XML::GRDDL::Transformation>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2008-2010 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
