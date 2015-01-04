use v6;

class PDF::Basic::IndObj;

has Int $.obj-num is rw;
has Int $.gen-num is rw;

#| construct and object instancefrom a PDF::Grammar::PDF ast representation of
#| an indirect object: [ $obj-num, $gen-num, $type => $content ]
multi method new-delegate( Array :$ind-obj!, :$input ) {
     my $obj-num = $ind-obj[0];
    my $gen-num = $ind-obj[1];
    my %params = $ind-obj[2].kv;
    %params<input> = $input
        if $input.defined;

    $.new-delegate( :$obj-num, :$gen-num, |%params);
}

multi method new-delegate( Array :$array!, *%params) {
    require ::("PDF::Basic::IndObj::Array");
    return ::("PDF::Basic::IndObj::Array").new( :$array, |%params );
}

multi method new-delegate( Hash :$dict!, *%params) {
    require ::("PDF::Basic::IndObj::Dict");
    return ::("PDF::Basic::IndObj::Dict").new-delegate( :$dict, |%params );
}

multi method new-delegate( Hash :$stream!, *%params) {
    require ::("PDF::Basic::IndObj::Stream");
    return ::("PDF::Basic::IndObj::Stream").new-delegate( :$stream, |%params );
}

method ast {
    :ind-obj[ $.obj-num, $.gen-num, %$.content ]
}
