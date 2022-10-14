#ifndef SEKAITOON_HELPERS
#define SEKAITOON_HELPERS

//------------------------------------------------------------------------------- 

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//	1.Ichika	5.Minori	9.Kohane	13.Tsukasa	17.Kanade	21.Vocaloids
//	2.Saki		6.Haruka	10.An		14.Emu		18.Mafuyu
//	3.Honami	7.Airi		11.Akito	15.Nene		19.Ena
//	4.Shiho		8.Shizuku	12.Touya	16.Rui		20.Mizuki
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

// default skin colors, I have literally no idea as to why this needs to be static
const static vector<float, 4> DefaultSkinColor[21] = {
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Ichika//     1
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Saki//       2
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Honami//     3
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Shiho//      4
	vector<float, 4>(0.996, 0.937, 0.878, 1.0),				//Minori//     5
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Haruka//     6
	vector<float, 4>(0.996, 0.937, 0.878, 1.0),				//Airi//       7
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Shizuku//    8
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Kohane//     9
	vector<float, 4>(0.996, 0.937, 0.878, 1.0),				//An//         10
	vector<float, 4>(0.996, 0.937, 0.878, 1.0),				//Akito//      11
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Touya//      12
	vector<float, 4>(0.996, 0.937, 0.878, 1.0),				//Tsukasa//    13
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Emu//        14
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Nene//       15
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Rui//        16
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Kanade//     17
	vector<float, 4>(0.996, 0.937, 0.878, 1.0),				//Mafuyu//     18
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Ena//        19
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0),	//Mizuki//     20
	vector<float, 4>(0.9921875, 0.9609375, 0.921875, 1.0)	//Vocaloids//  21
};

// shadow 1 skin colors, I have literally no idea as to why this needs to be static
const static vector<float, 4> Shadow1SkinColor[21] = {
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Ichika//     1
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Saki//       2
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Honami//     3
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Shiho//      4
	vector<float, 4>(0.937, 0.686, 0.733, 1.0),				//Minori//     5
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Haruka//     6
	vector<float, 4>(0.937, 0.686, 0.733, 1.0),				//Airi//       7
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Shizuku//    8
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Kohane//     9
	vector<float, 4>(0.937, 0.686, 0.733, 1.0),				//An//         10
	vector<float, 4>(0.925, 0.663, 0.667, 1.0),				//Akito//      11
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Touya//      12
	vector<float, 4>(0.925, 0.663, 0.667, 1.0),				//Tsukasa//    13
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Emu//        14
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Nene//       15
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Rui//        16
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Kanade//     17
	vector<float, 4>(0.937, 0.686, 0.733, 1.0),				//Mafuyu//     18
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Ena//        19
	vector<float, 4>(0.957, 0.714, 0.804, 1.0),				//Mizuki//     20
	vector<float, 4>(0.890625, 0.7695313, 0.796875, 1.0)	//Vocaloids//  21
};

// shadow 2 skin colors, I have literally no idea as to why this needs to be static
const static vector<float, 4> Shadow2SkinColor[21] = {
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Ichika//     1
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Saki//       2
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Honami//     3
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Shiho//      4
	vector<float, 4>(0.878, 0.471, 0.537, 1.0),	//Minori//     5
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Haruka//     6
	vector<float, 4>(0.878, 0.471, 0.537, 1.0),	//Airi//       7
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Shizuku//    8
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Kohane//     9
	vector<float, 4>(0.878, 0.471, 0.537, 1.0),	//An//         10
	vector<float, 4>(0.855, 0.439, 0.443, 1.0),	//Akito//      11
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Touya//      12
	vector<float, 4>(0.855, 0.439, 0.443, 1.0),	//Tsukasa//    13
	vector<float, 4>(0.914, 0.51, 0.545, 1.0),	//Emu//        14
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Nene//       15
	vector<float, 4>(0.914, 0.51, 0.545, 1.0),	//Rui//        16
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Kanade//     17
	vector<float, 4>(0.878, 0.471, 0.537, 1.0),	//Mafuyu//     18
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Ena//        19
	vector<float, 4>(0.914, 0.51, 0.647, 1.0),	//Mizuki//     20
	vector<float, 4>(0.796875, 0.59375, 0.6367188, 1.0)		//Vocaloids//  21
};

//------------------------------------------------------------------------------- 

/* helper functions */

float blendColorBurn(const float base, const float blend){
	return (blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
}

vector<float, 3> blendColorBurn(const vector<float, 3> base, const vector<float, 3> blend){
	return vector<float, 3>(blendColorBurn(base.r,blend.r),blendColorBurn(base.g,blend.g),blendColorBurn(base.b,blend.b));
}

vector<float, 3> blendColorBurn(const vector<float, 3> base, const vector<float, 3> blend, float opacity){
	return (blendColorBurn(base, blend) * opacity + base * (1.0 - opacity));
}

float blendLinearBurn(const float base, const float blend){
	// Note : Same implementation as BlendSubtractf
	return max(base+blend-1.0,0.0);
}

vector<float, 3> blendLinearBurn(const vector<float, 3> base, const vector<float, 3> blend){
	// Note : Same implementation as BlendSubtract
	return max(base+blend-1.0,0.0);
}

vector<float, 3> blendLinearBurn(const vector<float, 3> base, const vector<float, 3> blend, const float opacity){
	return (blendLinearBurn(base, blend) * opacity + base * (1.0 - opacity));
}

// map range functions
float mapRange(const float min_in, const float max_in, const float min_out, const float max_out, const float value){
    float slope = (max_out - min_out) / (max_in - min_in);
    
    return min_out + slope * (value - min_in);
}

float lerpByZ(const float startScale, const float endScale, const float startZ, const float endZ, const float z){
   float t = (z - startZ) / max(endZ - startZ, 0.001);
   t = saturate(t);
   return lerp(startScale, endScale, t);
}

#endif
