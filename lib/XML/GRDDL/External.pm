package XML::GRDDL::External;

use 5.008;
use common::sense;

use XML::GRDDL;

our $VERSION = '0.003';

sub new
{
	my ($class, $profile, $referer, $grddl_object) = @_;

	# certain profiles known not to be GRDDLable
	my $ignore;
	foreach my $ignorant ($class->ignore)
	{
		if (ref $ignorant eq 'Regexp' && $profile =~ $ignorant)
			{ $ignore++ && last; }
		elsif (ref $ignorant eq 'CODE' && $ignorant->($profile))
			{ $ignore++ && last; }
		elsif ((!ref $ignorant) && $ignorant eq $profile)
			{ $ignore++ && last; }
	}
	return __PACKAGE__->_new_ignored($profile, $referer, $grddl_object)
		if $ignore; # i.e. do not bless it as a child class.
	
	my $self = bless {
		'uri'     => $profile,
		'referer' => $referer,
		'grddl'   => $grddl_object,
		}, $class;
	return $self;
}

sub _new_ignored
{
	my ($class, $profile, $referer, $grddl_object) = @_;
	my $self = bless {
		'uri'     => $profile,
		'referer' => $referer,
		'grddl'   => $grddl_object,
		}, $class;
	return $self;
}

sub ignore
{
	return;
}

sub transformations
{
	return;
}

1;

__END__

=head1 NAME

XML::GRDDL::External - base class for externally loaded documents

=head1 DESCRIPTION

This is the superclass of L<XML::GRDDL::Transformation>, L<XML::GRDDL::Profile>,
and L<XML::GRDDL::Namespace>. Doesn't do much on its own.

=head1 SEE ALSO

L<XML::GRDDL>,
L<XML::GRDDL::Transformation>, L<XML::GRDDL::Profile>, L<XML::GRDDL::Namespace>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2008-2011 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
