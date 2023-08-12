class PDF::IO::Blob does Blob[uint8]  is repr('VMArray') {
    method encoding{ 'latin-1' }
    method codes { self.bytes }
    multi method Str { self.decode("latin-1") }
    multi method Stringy { self.decode("latin-1") }

    multi method substr( WhateverCode $from-whatever!, |c ) {
        my UInt \from = $from-whatever( $.codes );
        $.substr( from, |c );
    }
    multi method substr(Int $from, UInt $len = $.codes - $from) { self.subbuf($from, $len).decode("latin-1") }
    multi method COERCE(Blob $_) { self.new($_) }
}
