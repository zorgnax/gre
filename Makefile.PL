use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

my $mm_ver = $ExtUtils::MakeMaker::VERSION;
if ($mm_ver =~ /_/) {
    $mm_ver = eval $mm_ver;
    die $@ if $@;
}

my @REQUIRES = (
    'strict'        => 0,
    'warnings'      => 0,
);

my @TEST_REQUIRES = (
    'Test::More'    => 0.88,
);

push(@REQUIRES, @TEST_REQUIRES) if $mm_ver < 6.64;

WriteMakefile(
    NAME => "App::Gre",
    VERSION_FROM => "lib/App/Gre.pm",
    ABSTRACT_FROM  => "lib/App/Gre.pm",
    AUTHOR => "Jacob Gelbman <gelbman\@gmail.com>",
    EXE_FILES => ["bin/gre"],
    PREREQ_PM => { @REQUIRES },

    ($mm_ver >= 6.64
        ? (TEST_REQUIRES => { @TEST_REQUIRES })
        : ()
    ),

    ($mm_ver >= 6.31
        ? (LICENSE => 'perl')
        : ()
    ),

    ($mm_ver >= 6.48
        ? (MIN_PERL_VERSION => 5.006)
        : ()
    ),

    ($mm_ver <= 6.45 ? () : (META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository  => {
                type => 'git',
                web  => 'https://github.com/zorgnax/gre',
                url  => 'https://github.com/zorgnax/gre.git',
            },
        },
    })),

    clean => {FILES => "App-Gre-*.tar.gz *.bak"},
);

