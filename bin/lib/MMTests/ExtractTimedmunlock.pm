# ExtractTimedmunlock.pm
package MMTests::ExtractTimedmunlock;
use MMTests::SummariseMultiops;
our @ISA = qw(MMTests::SummariseMultiops);

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "ExtractTimedmunlock",
		_DataType    => DataTypes::DATA_TIME_USECONDS,
		_ResultData  => []
	};
	bless $self, $class;
	return $self;
}

sub initialise()
{
	my ($self, $reportDir, $testName) = @_;

	$self->SUPER::initialise($reportDir, $testName);
	$self->{_FieldFormat} = [ "%-${fieldLength}s", "%${fieldLength}d", "%$fieldLength.2f" ];
	$self->{_FieldHeaders} = [ "munlock", "Iteration", "Latency" ];
}

sub extractReport() {
	my ($self, $reportDir, $reportName, $profile) = @_;
	my ($elapsed, $iteration);
	my $file = "$reportDir/$profile/timedmunlock.time";

	open(INPUT, $file) || die("Failed to open $file\n");
	$iteration = 0;
	while (<INPUT>) {
		$_ =~ tr/[a-zA-Z]%//d;
		$elapsed = $_ / 1000000000;

		$self->addData("latency", $iteration, $elapsed );
		$iteration++;
	}
	close INPUT;
}

1;
