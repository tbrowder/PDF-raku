use Test;

plan 10;

use PDF::Basic::Filter;
use PDF::Basic::Filter::Flate;

my $prediction-in = buf8.new: [
    0x2, 0x1, 0x0, 0x10, 0x0,
    0x2, 0x0, 0x2, 0xcd, 0x0,
    0x2, 0x0, 0x1, 0x51, 0x0,
    0x1, 0x0, 0x1, 0x70, 0x0,
    0x3, 0x0, 0x5, 0x7a, 0x0,
    0,   1,   2,   3,    4,
    ];

my $tiff-post-prediction = buf8.new: [
    0x02, 0x01, 0x00, 0x12, 0x01, 0x02, 0x12, 0x03, 0xCF, 0x12, 0x05,
    0xCF, 0x01, 0x51, 0x00, 0x02, 0x51, 0x01, 0x72, 0x51, 0x04, 0x72,
    0x56, 0x7E, 0x00, 0x00, 0x01, 0x02, 0x03, 0x05, 0x02, 0x03, 0x05,
    0x02, 0x03, 0x05
    ];

my $png-post-prediction = buf8.new: [
    0x1, 0x0, 0x10, 0x0,
    0x1, 0x2, 0xdd, 0x0,
    0x1, 0x3, 0x2e, 0x0,
    0x0, 0x1, 0x71, 0x71,
    0x0, 0x5, 0xb5, 0x93,
    1,   2,   3,    4,
    ];

is_deeply PDF::Basic::Filter::Flate.post-prediction( $prediction-in,
                                                     :Columns(4),
                                                     :Colors(3),
                                                     :Predictor(1), ),
    $prediction-in,
    "NOOP predictive filter sanity";

is_deeply PDF::Basic::Filter::Flate.post-prediction( $prediction-in,
                                                     :Columns(4),
                                                     :Colors(3),
                                                     :Predictor(2), ),
    $tiff-post-prediction,
    "TIFF predictive filter sanity";

is_deeply PDF::Basic::Filter::Flate.post-prediction( $prediction-in,
                                                     :Columns(4),
                                                     :Predictor(12), ),
    $png-post-prediction,
    "PNG predictive filter sanity";

my $rand-data = buf8.new: [
    0x12, 0x0D, 0x12, 0x0A, 0x02, 0x47, 0x8E, 0x7A, 0x1B, 0x08, 0x28, 0x21,
    0x65, 0x5B, 0x11, 0xA0, 0x02, 0x02, 0x2F, 0x3C, 0x01, 0x4B, 0x0D, 0xC9,
    0xA0, 0x37, 0x48, 0x71, 0x0E, 0x15, 0x0B, 0x1E, 0xAE, 0x02, 0xA3, 0x31,
    0x7F, 0x01, 0x05, 0x02, 0x04, 0x08, 0x06, 0x05, 0x0F, 0xFE, 0x01, 0x1A,
    ];

for None => 1, TIFF => 2, PNG => 10 {
    my ($desc, $Predictor) = .kv;

    my $prediction = PDF::Basic::Filter::Flate.prediction( $rand-data,
                                                           :Columns(4),
                                                           :$Predictor, );

    my $post-prediction = PDF::Basic::Filter::Flate.post-prediction( $prediction,
                                                                     :Columns(4),
                                                                     :$Predictor, );

    is_deeply $post-prediction, $rand-data, "$desc predictor ($Predictor) - appears lossless";
}

my $sample-decoded = "  /TT3 1 Tf\n-0.0016 Tc 0.1771 Tw 0.46 0 Td\n[( )-1087(Desig)-5(n)1( s)-8(e)1(ssio)-5(n)1(s to i)-6(n)1(clu)-5(d)1(e)-5( i)-6(n)1(teractivit)-10(y )-7(an)-5(d inc)-8(l)1(u)-5(de v)-8(a)1(rie)-5(t)-10(y)12( of c)-8(onte)-5(n)1(t)-10( )]TJ\n-0.0017 Tc 0.0305 Tw 1.54 -1.333 Td\n[(and)-5( int)-10(e)1(ractio)-5(n)-5( in)-5( )-7(your)-9( sess)-8(io)-5(n.  Pr)]TJ\n-0.0006 Tc 0.0294 Tw 15.527 0 Td\n[(ov)-7(ide)-4( o)-4(p)2(p)-4(o)2(rtuniti)-5(es for )-7(p)-4(a)2(rticip)-4(ants to)-4( )]TJ\n-0.001 Tc 0.0032 Tw -15.527 -1.333 Td\n[(interact an)-5(d col)-5(l)1(ab)-5(orate )-13(w)15(i)1(th )-7(e)-5(a)2(ch other. )]TJ\nET\nEMC \n/P <</MCID 20 >>BDC \nBT\n/C2_0 1 Tf\n0 Tc 0 Tw 0 9 -9 0 150.8997 414 Tm\n<0083>Tj\n/TT3 1 Tf\n-0.0012 Tc 0.0034 Tw 0.46 0 Td\n[( )-1260(Practice befor)-8(e)-5( lead)-5(ing )-7(yo)-5(ur fi)-6(rst session)-12(!)10( )]TJ\nET\nEMC \n/P <</MCID 21 >>BDC \nBT\n/C2_0 1 Tf\n0 Tc 0 Tw 0 9 -9 0 165.9 414 Tm\n<0083>Tj\n/TT3 1 Tf\n-0.0009 Tc 0.0031 Tw 0.46 0 Td\n[( )-1260(Become fami)-5(li)-5(ar )-7(w)15(i)1(t)-10(h)2( the ses)-8(s)-1(ion co)-5(ntent. )]TJ\nET\nEMC \n/P <</MCID 22 >>BDC \nBT\n/C2_0 1 Tf\n0 Tc 0 Tw 0 9 -9 0 180.9003 414 Tm\n<0083>Tj\n/TT3 1 Tf\n-0.0018 Tc 0.3506 Tw 0.46 0 Td\n[( )-913(Open )7(W)-5(e)-6(b p)-6(ages, ap)-6(plic)-8(ati)-6(ons nee)]TJ\n0.344 Tw 18.487 0 Td\n[(de)-6(d f)-11(o)1(r a)-6(ppl)-6(icatio)-6(n)-6( shari)-6(n)1(g)-6( a)-6(nd )]TJ\n-0.001 Tc 0.0032 Tw -16.947 -1.333 Td\n[(screen ca)-5(pture)-5(s)-1( before sessi)-5(o)-5(n)2( beg)-5(ins. )]  ";

my $sample-encoded = [72, 137, 140, 84, 77, 111, 219, 48, 12, 189,
251, 87, 112, 55, 27, 152, 29, 201, 31, 177, 13, 20, 61, 244, 227,
176, 1, 197, 122, 48, 176, 195, 48, 12, 170, 173, 36, 26, 92, 41, 176,
149, 22, 253, 247, 35, 41, 39, 237, 182, 162, 237, 193, 18, 45, 202,
36, 31, 223, 163, 1, 86, 93, 87, 128, 132, 110, 19, 165, 34, 19, 66,
174, 161, 235, 65, 100, 178, 174, 241, 240, 17, 173, 114, 13, 2, 186,
33, 250, 17, 67, 146, 74, 209, 212, 241, 149, 158, 205, 54, 73, 171,
216, 38, 50, 134, 57, 73, 155, 88, 163, 53, 207, 198, 29, 79, 103,
240, 14, 76, 146, 174, 249, 173, 31, 15, 228, 24, 208, 212, 100, 60,
123, 188, 158, 84, 239, 205, 131, 241, 20, 59, 126, 194, 20, 117, 172,
44, 223, 6, 99, 123, 138, 61, 226, 189, 240, 189, 134, 7, 58, 80, 120,
48, 25, 142, 180, 124, 150, 200, 60, 6, 183, 1, 190, 239, 172, 215,
199, 58, 130, 31, 146, 159, 221, 215, 5, 95, 29, 240, 137, 66, 84,
132, 79, 102, 85, 9, 169, 204, 138, 162, 8, 32, 149, 29, 66, 137, 54,
124, 75, 200, 184, 198, 5, 91, 240, 241, 70, 181, 62, 185, 195, 148,
164, 45, 182, 65, 207, 220, 137, 229, 94, 6, 112, 59, 61, 167, 21, 75,
91, 69, 222, 150, 156, 182, 202, 170, 188, 62, 54, 214, 61, 80, 40,
51, 96, 217, 37, 226, 160, 117, 159, 228, 248, 160, 225, 208, 152,
252, 193, 26, 111, 40, 176, 158, 97, 227, 38, 78, 205, 110, 197, 110,
211, 155, 240, 102, 61, 117, 158, 195, 188, 192, 188, 228, 22, 69, 78,
185, 211, 37, 249, 75, 212, 136, 150, 153, 128, 99, 239, 123, 55, 146,
65, 189, 87, 119, 100, 185, 73, 121, 77, 10, 40, 226, 199, 68, 86,
177, 161, 238, 238, 184, 16, 238, 54, 21, 210, 239, 192, 249, 157,
158, 178, 144, 252, 186, 139, 174, 111, 46, 33, 90, 221, 194, 217,
217, 234, 230, 242, 203, 21, 228, 2, 206, 207, 47, 174, 240, 240, 162,
139, 86, 151, 249, 47, 17, 180, 39, 184, 68, 22, 28, 180, 144, 182,
184, 201, 74, 100, 77, 219, 214, 80, 74, 108, 217, 125, 116, 38, 68,
83, 156, 119, 191, 163, 127, 21, 155, 159, 224, 149, 175, 41, 54, 95,
139, 248, 150, 25, 236, 53, 220, 105, 236, 94, 16, 44, 49, 56, 106,
197, 108, 27, 187, 93, 216, 164, 183, 195, 4, 27, 86, 232, 52, 123,
230, 213, 56, 75, 129, 226, 79, 201, 73, 76, 175, 97, 147, 31, 199,
182, 174, 178, 246, 61, 96, 162, 61, 1, 123, 117, 20, 9, 216, 133,
238, 221, 189, 134, 141, 186, 103, 117, 140, 188, 170, 160, 143, 103,
154, 88, 200, 59, 36, 8, 144, 29, 66, 68, 29, 192, 69, 162, 90, 45,
82, 205, 138, 245, 218, 250, 55, 136, 203, 63, 14, 174, 17, 89, 139,
69, 191, 75, 92, 19, 240, 21, 21, 77, 199, 127, 248, 90, 84, 218, 183,
189, 182, 144, 212, 241, 119, 150, 62, 81, 114, 7, 123, 218, 212, 86,
207, 159, 65, 177, 189, 31, 13, 207, 189, 242, 76, 154, 179, 51, 88,
173, 25, 8, 6, 47, 195, 188, 53, 89, 217, 156, 230, 109, 224, 80, 3,
108, 176, 5, 18, 39, 12, 39, 28, 20, 135, 218, 143, 180, 153, 94, 241,
188, 211, 63, 10, 23, 152, 119, 106, 58, 253, 178, 182, 124, 196, 215,
237, 240, 214, 148, 173, 179, 182, 252, 123, 202, 230, 126, 210, 8,
168, 87, 4, 103, 239, 15, 19, 171, 144, 137, 8, 202, 212, 65, 110, 60,
111, 225, 119, 147, 147, 103, 27, 52, 58, 19, 61, 0, 127, 4, 24, 0,
243, 226, 98, 233, 10].chrs;

is PDF::Basic::Filter::Flate.decode($sample-encoded), $sample-decoded,
    q{Flate decompression - larger sample};

my $flate-enc = [104, 222, 98, 98, 100, 16, 96, 96, 98, 96,
186, 10, 34, 20, 129, 4, 227, 2, 32, 193, 186, 22, 72, 48, 203, 131,
8, 37, 16, 33, 13, 34, 50, 65, 74, 30, 128, 88, 203, 64, 196, 82, 16,
119, 23, 144, 224, 206, 7, 18, 82, 7, 128, 4, 251, 121, 32, 97, 117,
6, 72, 84, 1, 13, 96, 100, 72, 5, 178, 24, 24, 24, 169, 78, 252, 103,
20, 123, 15, 16, 96, 0, 153, 243, 13, 60].chrs;

my $flate-dec = [1, 0, 16, 0, 1, 2, 229, 0, 1, 4, 6, 0, 1, 5, 166, 0,
1, 10, 83, 0, 1, 13, 114, 0, 1, 16, 148, 0, 1, 19, 175, 0, 1, 22, 24,
0, 1, 24, 248, 0, 1, 27, 158, 0, 1, 30, 67, 0, 1, 32, 253, 0, 1, 43,
108, 0, 1, 69, 44, 0, 1, 76, 251, 0, 1, 134, 199, 0, 1, 0, 116, 0, 2,
0, 217, 0, 2, 0, 217, 1, 2, 0, 217, 2, 2, 0, 217, 3, 2, 0, 217, 4, 2,
0, 217, 5, 2, 0, 217, 6, 2, 0, 217, 7, 2, 0, 217, 8, 2, 0, 217, 9, 2,
0, 217, 10, 2, 0, 217, 11, 2, 0, 217, 12, 2, 0, 217, 13, 2, 0, 217,
14, 2, 0, 217, 15, 2, 0, 217, 16, 2, 0, 217, 17, 1, 1, 239, 0].chrs;

my %dict = :Filter<FlateDecode>, :DecodeParams{ :Predictor(12), :Columns(4) };

is my $result=PDF::Basic::Filter.decode($flate-enc, :%dict),
    $flate-dec, "Flate with PNG predictors - decode";

my $re-encoded = PDF::Basic::Filter.encode($result, :%dict);

is PDF::Basic::Filter.decode($re-encoded, :%dict),
    $flate-dec, "Flate with PNG predictors - encode/decode round-trip";

dies_ok { PDF::Basic::Filter.decode('This is not valid input', :%dict) },
    q{Flate dies if invalid characters are passed to decode};
