use v6;

class PDF::IO {
    # a poor man's polymorphism: allow pdf input from IO handles or strings
    # could be obseleted by cat-strings, when available
    has Str $.path is rw;

    method coerce($v is raw, |c) { self.COERCE($v, |c) }

    proto method COERCE( $value ) returns PDF::IO {*}

    multi method COERCE( PDF::IO $value!, :$path ) {
        # don't reCOERCE
        $value.path = $_ with $path;
        $value;
    }

    multi method COERCE( IO::Path $value, |c ) {
	self.COERCE( $value.open( :bin, |c ) );
    }

    multi method COERCE( IO::Handle $value!, |c ) {
        (require ::('PDF::IO::Handle')).bless( :$value, |c );
    }

    multi method COERCE( Str $value! where { !.isa(PDF::IO) }, |c) {
        (require ::('PDF::IO::Str')).bless( :$value, |c );
    }

    multi method COERCE( Blob $_!, |c) {
        my $value = .decode: "latin-1";
        (require ::('PDF::IO::Str')).bless( :$value, |c );
    }

    multi method stream-data( List :$ind-obj! ) {
        $.stream-data( |$ind-obj[2] );
    }
    multi method stream-data( Hash :$stream! ) is default {
        $stream<encoded>
    }

    method substr(|c) is DEPRECATED<byte-str> { $.byte-str(|c) }

    method byte-str(|c) {
	$.subbuf(|c).decode('latin-1');
    }
}
