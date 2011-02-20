package XML::GRDDL::Transformation::Hardcoded;

use 5.008;
use common::sense;
use base qw[XML::GRDDL::Transformation];

use HTTP::Headers;
use HTTP::Response;

our $VERSION = '0.003';
our %known;

sub content { return ''; }

sub response
{
	my ($self) = @_;
	
	return HTTP::Response->new(
		200,
		'OK',
		HTTP::Headers
			->new
			->header('Content-Base' => $self->{uri})
			->header('Content-Type' => 'application/xslt+xml'),
		$self->content,
		);
};

1;

=head1 NAME

XML::GRDDL::Transformation::Hardcoded - mechanism for hard-coding XSLT files

=head1 SEE ALSO

L<XML::GRDDL::Transformation>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2011 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
