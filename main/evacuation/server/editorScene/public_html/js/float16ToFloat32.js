function float16ToFloat32(ival) {
	var sign = (ival & 0x8000) >> 15,
		exp = (ival & 0x7c00) >> 10,
		sig = (ival & 0x3ff) >> 0,
		ret = null;
	if (exp === 0) {
		if (sig === 0) {
			sign = sign << 31;
			ret = sign | exp | sig;
		} else {
			n_bit = 1;
			bit = 0x0200;
			while ((bit & sig) === 0) {
				n_bit = n_bit + 1;
				bit = bit >> 1;
			}
			sign = sign << 31;
			exp = (-14 - n_bit + 127) << 23;
			sig = ((sig & (~bit)) << n_bit) << (23 - 10);
			ret = sign | exp | sig;
		}
	}
	else if (exp === 0x1f) {
		if (sig === 0) {// Inf
			if (sign === 0) {
				ret = 0x7f800000;
			}
			else {
				ret = 0xff800000;
			}
		}
		else {// NaN
			ret = 0x7fc00000 | (sign<<31);
		}
	}
	else {
		sign = sign << 31;
		exp = (exp - 15 + 127) << 23;
		sig = sig << (23 - 10);
		ret = sign | exp | sig;
	}
	var buffer = new ArrayBuffer(4);
	new DataView(buffer).setInt32(0, ret, true);

	return new Float32Array(buffer)[0];
}