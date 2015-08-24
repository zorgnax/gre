use Test::More;
use warnings;

runcmd("./bin/gre '' t/data");
my $test = $STDOUT eq <<EOSTR;
t/data/fruits.txt
t/data/pokemon.mon
t/data/dir1/simpsons.txt
EOSTR
ok $test, "file listing recursive and textonly";

runcmd("./bin/gre apple t/data");
my $e = qr{(?:\e\[.*?[mK])*};
$test = $STDOUT =~ m{
    ^${e}t/data/fruits.txt${e}\n
    ${e}1${e}:${e}apple${e}\n
    ${e}3${e}:pine${e}apple${e}\n$
}x;
ok $test, "found the apples";

done_testing;

sub runcmd {
    my ($cmd) = @_;
    system "$cmd >t/stdout 2>t/stderr";
    $EXITCODE = $? >> 8;
    if (open my $fh, "<", "t/stdout") {
        $STDOUT = do {local $/; <$fh>};
        close $fh;
    }
    if (open my $fh, "<", "t/stderr") {
        $STDERR = do {local $/; <$fh>};
        close $fh;
    }
    if ($ENV{DEBUG}) {
        print "STDOUT: $STDOUT\n";
        print "STDERR: $STDERR\n";
        print "EXITCODE: $EXITCODE\n";
    }
    END {system "rm t/stdout t/stderr"}
}

