use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Test::Memory::Cycle',
    VERSION_FROM        => 'Cycle.pm', # finds $VERSION
    ABSTRACT            => "Verifies code hasn't left circular references",
    PREREQ_PM => {
        'Devel::Cycle'          => 1.03,
        'Getopt::Long'          => 0,
        'Test::Builder'         => 0,
        'Test::Builder::Tester' => 0,
        'Test::More'            => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-Memory-Cycle-*' },
);
