struct vsIn{
    vector<float, 4> vertex : POSITION; // object space
    vector<float, 3> normal : NORMAL; // object space
    vector<float, 4> tangent : TANGENT;
    vector<float, 2> uv : TEXCOORD0;
    vector<float, 4> vertexcol : COLOR0;
};

struct vsOut{
    vector<float, 4> pos : SV_POSITION; // clip space vertex positions
    vector<float, 3> normalOS : NORMAL;
    vector<float, 4> tangent : TANGENT;
    vector<float, 3> vertexLight : TEXCOORD0;
    vector<float, 4> vertexOS : TEXCOORD1;
    vector<float, 2> uv : TEXCOORD2;
    UNITY_FOG_COORDS(3)
    UNITY_SHADOW_COORDS(4)
    OpenLitLightDatas lightData : TEXCOORD5;
    vector<float, 4> vertexcol : COLOR0;
};
