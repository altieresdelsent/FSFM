var float16Arr = [
.1757,
3182,
-.01322,
166e-6,
16510,
.564,
.005264,
-.011154,
-1223,
-418e-6,
-.0315,
-8.29,
-2813e-8,
-8.12,
-1.368,
.02547,
NaN,
-.0522,
-157e-6,
.0278,
.001596,
26740,
-15740,
1.357,
-958e-6,
-4876,
-44800,
3645e-7,
3415e-8,
-.1102,
62.94,
.01868,
-493.5,
.05264,
4.977,
-3.908,
-674,
444.5,
821,
NaN,
5180,
335.5,
33e3,
-.1674,
239.2,
-42530,
366e-7,
.05957,
.2305,
218.8,
.9487,
14504,
67.56,
-670,
-32300,
.02477,
-7868,
1.122,
-593e-7,
-31.9,
-1.017,
-354.2,
1.359,
-.015434,
-.001796,
219e-7,
-5755e-7,
12.05,
-.2162,
-.03793,
33e-5,
-264e-6,
503e-6,
.3792,
53.25,
-1638e-7,
28050,
-285e-6,
1349,
-.7314,
-7634e-7,
-.2299,
.006786,
12.14,
3.684,
1392,
-.009636,
-4.965,
-.995,
-90.1,
.4128,
.1459,
.2001,
1057e-7,
NaN,
855,
429e-7,
-18.25,
-.046,
180.4
];
var int16Arr = [
12703,
27191,
41669,
2417,
29704,
14467,
7524,
41398,
58567,
36569,
43016,
51237,
33240,
51215,
48505,
9861,
32376,
43694,
35109,
10014,
5770,
30343,
62384,
15726,
37849,
60611,
63864,
3577,
573,
44814,
21470,
9416,
57270,
10941,
17658,
50129,
57668,
24306,
25194,
32737,
27919,
23870,
30727,
45403,
23418,
63793,
614,
11168,
13152,
23254,
15255,
29461,
21561,
57660,
63459,
9815,
61359,
15485,
33763,
53242,
48145,
56713,
15728,
41959,
38747,
367,
37047,
18950,
45803,
43227,
3432,
35923,
4127,
13841,
21160,
35166,
30425,
36011,
25925,
47578,
37441,
45915,
7923,
18962,
17246,
25968,
41199,
50423,
48118,
54690,
13979,
12459,
12903,
1773,
32220,
25262,
720,
52368,
43491,
22947];

function testFloat16ToFloat32() {
	var str = "",
	indice = 0,
	resultado = 0,
	original = 0,
	funcionouTeste = true;
	console.log("rodou testeee..");
	for(indice = 0; indice < 100; indice++) {
		resultado = float16ToFloat32(int16Arr[indice]);
		original = float16Arr[indice];
		if(resultado != original) {
			funcionouTeste = false
			str += "indice + "+ indice+" errado, era para ser "+original+" resultado foi "+resultado+"";
		}

	}
	if (funcionouTeste === true) {
		document.getElementById("text").textContent = "It's alive!!";
	} else {
		document.getElementById("text").textContent = str;
	}
	return str;
} 