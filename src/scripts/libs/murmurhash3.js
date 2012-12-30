/*
 *  The MurmurHash3 algorithm was created by Austin Appleby.  This JavaScript port was authored
 *  by Peter Zotov (based on Java port by Yonik Seeley) and is placed into the public domain.
 *  The author hereby disclaims copyright to this source code.
 *
 *  This produces exactly the same hash values as the final C++
 *  version of MurmurHash3 and is thus suitable for producing the same hash values across
 *  platforms.
 *
 *  There are two versions of this hash implementation. First interprets the string as a
 *  sequence of bytes, thereby ignoring most significant byte of each codepoint. The
 *  second is
 *
 *  See http://github.com/whitequark/murmurhash3-js for future updates to this file.
 */
define([], function () { 
var MurmurHash3 = {
    mul32: function(m, n) {
        var nlo = n & 0xffff;
        var nhi = n - nlo;
        return ((nhi * m | 0) + (nlo * m | 0)) | 0;
    },

    hashBytes: function(data, len, seed) {
        var c1 = 0xcc9e2d51, c2 = 0x1b873593;

        var h1 = seed;
        var roundedEnd = len & ~0x3;

        for (var i = 0; i < roundedEnd; i += 4) {
            var k1 = (data.charCodeAt(i)     & 0xff)        |
                ((data.charCodeAt(i + 1) & 0xff) << 8)  |
                ((data.charCodeAt(i + 2) & 0xff) << 16) |
                ((data.charCodeAt(i + 3) & 0xff) << 24);

            k1 = this.mul32(k1, c1);
            k1 = ((k1 & 0x1ffff) << 15) | (k1 >>> 17);  // ROTL32(k1,15);
            k1 = this.mul32(k1, c2);

            h1 ^= k1;
            h1 = ((h1 & 0x7ffff) << 13) | (h1 >>> 19);  // ROTL32(h1,13);
            h1 = (h1 * 5 + 0xe6546b64) | 0;
        }

        k1 = 0;

        switch(len % 4) {
            case 3:
                k1 = (data.charCodeAt(roundedEnd + 2) & 0xff) << 16;
                // fallthrough
            case 2:
                k1 |= (data.charCodeAt(roundedEnd + 1) & 0xff) << 8;
                // fallthrough
            case 1:
                k1 |= (data.charCodeAt(roundedEnd) & 0xff);
                k1 = this.mul32(k1, c1);
                k1 = ((k1 & 0x1ffff) << 15) | (k1 >>> 17);  // ROTL32(k1,15);
                k1 = this.mul32(k1, c2);
                h1 ^= k1;
        }

        // finalization
        h1 ^= len;

        // fmix(h1);
        h1 ^= h1 >>> 16;
        h1  = this.mul32(h1, 0x85ebca6b);
        h1 ^= h1 >>> 13;
        h1  = this.mul32(h1, 0xc2b2ae35);
        h1 ^= h1 >>> 16;

        return h1;
    },

    hashString: function(data, len, seed) {
        var c1 = 0xcc9e2d51, c2 = 0x1b873593;

        var h1 = seed;
        var roundedEnd = len & ~0x1;

        for (var i = 0; i < roundedEnd; i += 2) {
            var k1 = data.charCodeAt(i) | (data.charCodeAt(i + 1) << 16);

            k1 = this.mul32(k1, c1);
            k1 = ((k1 & 0x1ffff) << 15) | (k1 >>> 17);  // ROTL32(k1,15);
            k1 = this.mul32(k1, c2);

            h1 ^= k1;
            h1 = ((h1 & 0x7ffff) << 13) | (h1 >>> 19);  // ROTL32(h1,13);
            h1 = (h1 * 5 + 0xe6546b64) | 0;
        }

        if((len % 2) == 1) {
            k1 = data.charCodeAt(roundedEnd);
            k1 = this.mul32(k1, c1);
            k1 = ((k1 & 0x1ffff) << 15) | (k1 >>> 17);  // ROTL32(k1,15);
            k1 = this.mul32(k1, c2);
            h1 ^= k1;
        }

        // finalization
        h1 ^= (len << 1);

        // fmix(h1);
        h1 ^= h1 >>> 16;
        h1  = this.mul32(h1, 0x85ebca6b);
        h1 ^= h1 >>> 13;
        h1  = this.mul32(h1, 0xc2b2ae35);
        h1 ^= h1 >>> 16;

        return h1;
    },

/**
 * JS Implementation of MurmurHash3 (r136) (as of May 20, 2011)
 * 
 * @author <a href="mailto:gary.court@gmail.com">Gary Court</a>
 * @see http://github.com/garycourt/murmurhash-js
 * @author <a href="mailto:aappleby@gmail.com">Austin Appleby</a>
 * @see http://sites.google.com/site/murmurhash/
 * 
 * @param {string} key ASCII only
 * @param {number} seed Positive integer only
 * @return {number} 32-bit positive integer hash 
 */

    murmurhash3_32_gc: function(key, seed) {
    var remainder, bytes, h1, h1b, c1, c1b, c2, c2b, k1, i;
    
    remainder = key.length & 3; // key.length % 4
    bytes = key.length - remainder;
    h1 = seed;
    c1 = 0xcc9e2d51;
    c2 = 0x1b873593;
    i = 0;
    
    while (i < bytes) {
        k1 = 
          ((key.charCodeAt(i) & 0xff)) |
          ((key.charCodeAt(++i) & 0xff) << 8) |
          ((key.charCodeAt(++i) & 0xff) << 16) |
          ((key.charCodeAt(++i) & 0xff) << 24);
        ++i;
        
        k1 = ((((k1 & 0xffff) * c1) + ((((k1 >>> 16) * c1) & 0xffff) << 16))) & 0xffffffff;
        k1 = (k1 << 15) | (k1 >>> 17);
        k1 = ((((k1 & 0xffff) * c2) + ((((k1 >>> 16) * c2) & 0xffff) << 16))) & 0xffffffff;

        h1 ^= k1;
        h1 = (h1 << 13) | (h1 >>> 19);
        h1b = ((((h1 & 0xffff) * 5) + ((((h1 >>> 16) * 5) & 0xffff) << 16))) & 0xffffffff;
        h1 = (((h1b & 0xffff) + 0x6b64) + ((((h1b >>> 16) + 0xe654) & 0xffff) << 16));
    }
    
    k1 = 0;
    
    switch (remainder) {
        case 3: k1 ^= (key.charCodeAt(i + 2) & 0xff) << 16;
        case 2: k1 ^= (key.charCodeAt(i + 1) & 0xff) << 8;
        case 1: k1 ^= (key.charCodeAt(i) & 0xff);
        
        k1 = (((k1 & 0xffff) * c1) + ((((k1 >>> 16) * c1) & 0xffff) << 16)) & 0xffffffff;
        k1 = (k1 << 15) | (k1 >>> 17);
        k1 = (((k1 & 0xffff) * c2) + ((((k1 >>> 16) * c2) & 0xffff) << 16)) & 0xffffffff;
        h1 ^= k1;
    }
    
    h1 ^= key.length;

    h1 ^= h1 >>> 16;
    h1 = (((h1 & 0xffff) * 0x85ebca6b) + ((((h1 >>> 16) * 0x85ebca6b) & 0xffff) << 16)) & 0xffffffff;
    h1 ^= h1 >>> 13;
    h1 = ((((h1 & 0xffff) * 0xc2b2ae35) + ((((h1 >>> 16) * 0xc2b2ae35) & 0xffff) << 16))) & 0xffffffff;
    h1 ^= h1 >>> 16;

    return h1 >>> 0;
}    
};

return MurmurHash3;
});