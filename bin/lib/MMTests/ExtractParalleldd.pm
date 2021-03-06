# ExtractParalleldd.pm
package MMTests::ExtractParalleldd;
use MMTests::SummariseMultiops;
use MMTests::Stat;
our @ISA = qw(MMTests::SummariseMultiops);
use strict;

sub initialise() {
	my ($self, $reportDir, $testName) = @_;
	$self->{_ModuleName} = "ExtractParalleldd";
	$self->{_DataType}   = DataTypes::DATA_TIME_SECONDS;
	$self->{_PlotType}   = "client-errorlines";
	$self->SUPER::initialise($reportDir, $testName);
}

sub extractReport() {
	my ($self, $reportDir, $reportName, $profile) = @_;
	my ($tm, $tput, $latency);
	my $iteration;
	my @clients;

	my @files = <$reportDir/$profile/time-*-1-1>;
	foreach my $file (@files) {
		my @split = split /-/, $file;
		push @clients, $split[-3];
	}
	@clients = sort { $a <=> $b } @clients;

	# Extract per-client timing information
	foreach my $client (@clients) {
		my $iteration = 0;

		foreach my $file (<$reportDir/$profile/time-$client-*>) {
			open(INPUT, $file) || die("Failed to open $file\n");
			while (<INPUT>) {
				next if $_ !~ /elapsed/;
				# $self->addData("System-$client", ++$iteration, $self->_time_to_sys($_));
				$self->addData("Elapsd-$client", ++$iteration, $self->_time_to_elapsed($_));
			}
			close(INPUT);
		}
	}

	foreach my $heading ("Elapsd") {
		foreach my $client (@clients) {
			push @{$self->{_Operations}}, "$heading-$client";
		}
	}
}

1;
