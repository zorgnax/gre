use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => "App::Gre",
    VERSION_FROM => "lib/App/Gre.pm",
    ABSTRACT_FROM  => "lib/App/Gre.pm",
    AUTHOR => "Jacob Gelbman <gelbman\@gmail.com>",
    EXE_FILES => ["bin/gre"],
    PREREQ_PM => {
        "Test::More" => "0",
    },
    clean => {FILES => "App-Gre-*.tar.gz"},
);

