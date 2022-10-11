#ifndef SEKAITOON_HELPERS
#define SEKAITOON_HELPERS

//------------------------------------------------------------------------------- 
/* https://github.com/KH40-khoast40/Shadekai/blob/main/Shadekai_Database.fxsub */

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//	0.Ichika	4.Minori	8.Kohane	12.Tsukasa	16.Kanade	20.Vocaloids
//	1.Saki		5.Haruka	9.An		13.Emu		17.Mafuyu
//	2.Honami	6.Airi		10.Akito	14.Nene		18.Ena
//	3.Shiho		7.Shizuku	11.Touya	15.Rui		19.Mizuki
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

// skin colors, I have literally no idea as to why this needs to be static
const static vector<float, 3> Skin_Color[21] = {
	vector<float, 3>(255, 245, 232),	//Ichika//     1
	vector<float, 3>(255, 245, 232),	//Saki//       2
	vector<float, 3>(255, 245, 232),	//Honami//     3
	vector<float, 3>(255, 245, 232),	//Shiho//      4
	vector<float, 3>(254, 239, 224),	//Minori//     5
	vector<float, 3>(255, 245, 232),	//Haruka//     6
	vector<float, 3>(254, 239, 224),	//Airi//       7
	vector<float, 3>(255, 245, 232),	//Shizuku//    8
	vector<float, 3>(255, 245, 232),	//Kohane//     9
	vector<float, 3>(254, 239, 224),	//An//         10
	vector<float, 3>(254, 239, 224),	//Akito//      11
	vector<float, 3>(255, 245, 232),	//Touya//      12
	vector<float, 3>(254, 239, 224),	//Tsukasa//    13
	vector<float, 3>(255, 245, 232),	//Emu//        14
	vector<float, 3>(255, 245, 232),	//Nene//       15
	vector<float, 3>(255, 245, 232),	//Rui//        16
	vector<float, 3>(255, 245, 232),	//Kanade//     17
	vector<float, 3>(254, 239, 224),	//Mafuyu//     18
	vector<float, 3>(255, 245, 232),	//Ena//        19
	vector<float, 3>(255, 245, 232),	//Mizuki//     20
	vector<float, 3>(253, 245, 235),	//Vocaloids//  21
};

// shaded skin colors, I have literally no idea as to why this needs to be static
const static vector<float, 3> SkinShade_Color[21] = {
	vector<float, 3>(244, 182, 205),	//Ichika//     1
	vector<float, 3>(244, 182, 205),	//Saki//       2
	vector<float, 3>(244, 182, 205),	//Honami//     3
	vector<float, 3>(244, 182, 205),	//Shiho//      4
	vector<float, 3>(239, 175, 187),	//Minori//     5
	vector<float, 3>(244, 182, 205),	//Haruka//     6
	vector<float, 3>(239, 175, 187),	//Airi//       7
	vector<float, 3>(244, 182, 205),	//Shizuku//    8
	vector<float, 3>(244, 182, 205),	//Kohane//     9
	vector<float, 3>(239, 175, 187),	//An//         10
	vector<float, 3>(236, 169, 170),	//Akito//      11
	vector<float, 3>(244, 182, 188),	//Touya//      12
	vector<float, 3>(236, 169, 170),	//Tsukasa//    13
	vector<float, 3>(244, 182, 205),	//Emu//        14
	vector<float, 3>(244, 182, 205),	//Nene//       15
	vector<float, 3>(244, 182, 188),	//Rui//        16
	vector<float, 3>(244, 182, 205),	//Kanade//     17
	vector<float, 3>(239, 175, 187),	//Mafuyu//     18
	vector<float, 3>(244, 182, 205),	//Ena//        19
	vector<float, 3>(244, 182, 205),	//Mizuki//     20
	vector<float, 3>(227, 196, 203),	//Vocaloids//  21
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
