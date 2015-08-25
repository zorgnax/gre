use Test::More;
use warnings;

chdir "t/data";
$ENV{PATH} = "../../bin:$ENV{PATH}";

runcmd("gre apple");
my $e = qr{(?:\e\[.*?[mK])*};
my $test = $STDOUT =~ m{
    ^${e}fruits.txt${e}\n
    ${e}1${e}:${e}apple${e}\n
    ${e}3${e}:pine${e}apple${e}\n$
}x;
ok $test, "found the apples";

runcmd("gre");
$test = $STDOUT eq <<EOSTR;
fruits.txt
pokemon.mon
dir1/bar.js
dir1/foo.html
dir1/simpsons.txt
EOSTR
ok $test, "file listing recursive and textonly";

runcmd("gre -ext=txt -no=simpsons");
$test = $STDOUT eq <<EOSTR;
fruits.txt
EOSTR
ok $test, "file filtering";

runcmd("gre -html -js");
$test = $STDOUT eq <<EOSTR;
dir1/bar.js
dir1/foo.html
EOSTR
ok $test, "file filtering with combos";

runcmd("gre -X");
$test = $STDOUT eq <<EOSTR;
fruits.txt
fruits.txt.gz
pokemon.mon
pokemon.tar.gz
dir1/bar.js
dir1/foo.html
dir1/simpsons.txt
EOSTR
ok $test, "disable builtin filters";

runcmd("gre 'krusty the clown' -i -k");
$test = $STDOUT eq <<EOSTR;
dir1/simpsons.txt
10:Krusty the Clown
EOSTR
ok $test, "ignore case";

runcmd("gre -help");
$test = $STDOUT =~ /Usage:/;
ok $test, "help";

runcmd("gre -man");
$test = $STDOUT =~ /My own take on grep\/ack/;
ok $test, "man";

runcmd("gre Krusty -A -k");
$test = $STDOUT eq <<EOSTR;
dir1/simpsons.txt
10:Krusty the Clown
11:The Happy Little Elves
12:Patty Bouvier
EOSTR
ok $test, "after context";

runcmd("gre Krusty -B -k");
$test = $STDOUT eq <<EOSTR;
dir1/simpsons.txt
8:Grampa Abraham Simpson
9:Itchy & Scratchy
10:Krusty the Clown
EOSTR
ok $test, "before context";

runcmd("gre Krusty -C -k");
$test = $STDOUT eq <<EOSTR;
dir1/simpsons.txt
8:Grampa Abraham Simpson
9:Itchy & Scratchy
10:Krusty the Clown
11:The Happy Little Elves
12:Patty Bouvier
EOSTR
ok $test, "context";

runcmd("gre -combos");
$test = $STDOUT =~ /^-html\b/m;
ok $test, "combos";

runcmd("gre Krusty -d1");
$test = $STDOUT eq "";
ok $test, "no recursion";

runcmd("gre -f pokemon.mon Krusty");
$test = $STDOUT eq "";
ok $test, "file option";

runcmd("gre -zzz");
$test = $STDOUT eq "" && $STDERR =~ /Invalid argument/;
ok $test, "unknown option";

runcmd("gre -l Krusty");
$test = $STDOUT eq <<EOSTR;
dir1/simpsons.txt
EOSTR
ok $test, "list matches option";

runcmd("gre -L Krusty");
$test = $STDOUT eq <<EOSTR;
fruits.txt
pokemon.mon
dir1/bar.js
dir1/foo.html
EOSTR
ok $test, "list nonmatches option";

runcmd("gre -m 'Char.*?zard' -k");
$test = $STDOUT eq <<EOSTR;
pokemon.mon
Charmander
Charmeleon
Charizard
EOSTR
ok $test, "multiline";

runcmd("gre zard -o -k");
$test = $STDOUT eq <<EOSTR;
pokemon.mon
6:zard
EOSTR
ok $test, "only";

runcmd("gre zard -p='**\$&**' -k");
$test = $STDOUT eq <<EOSTR;
pokemon.mon
6:**zard**
EOSTR
ok $test, "print";

done_testing;

sub runcmd {
    my ($cmd) = @_;
    system "$cmd >../stdout 2>../stderr";
    $EXITCODE = $? >> 8;
    if (open my $fh, "<", "../stdout") {
        $STDOUT = do {local $/; <$fh>};
        close $fh;
    }
    if (open my $fh, "<", "../stderr") {
        $STDERR = do {local $/; <$fh>};
        close $fh;
    }
    if ($ENV{DEBUG}) {
        print "STDOUT: $STDOUT\n";
        print "STDERR: $STDERR\n";
        print "EXITCODE: $EXITCODE\n";
    }
    END {system "rm ../stdout ../stderr"}
}

