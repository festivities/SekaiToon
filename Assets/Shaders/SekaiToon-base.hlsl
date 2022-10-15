#include "SekaiToon-inputs.hlsli"

#include "SekaiToon-helpers.hlsl"

vsOut vert(vsIn i){
    vsOut o;
    o.pos = mul(UNITY_MATRIX_MVP, i.vertex); // transform to clip space
    o.normalOS = i.normal;
    o.tangent = i.tangent;
    o.vertexOS = i.vertex;
    o.uv = (_ToggleLongTex != 0) ? vector<float, 2>(i.uv.x * 0.5, i.uv.y) : i.uv; // vs_TEXCOORD1
    o.vertexcol.x = i.vertexcol.x; // outline direction, EdgeScale_view @ line 246
    o.vertexcol.y = i.vertexcol.y; // rim intensity, RimScale_view @ line 247
    o.vertexcol.z = i.vertexcol.z; // eyebrow mask, used for making them appear in front of the hair at all times
    o.vertexcol.w = i.vertexcol.w; // UNUSED

    const vector<half, 4> vertexWS = mul(UNITY_MATRIX_M, i.vertex); // transform to world space
    const vector<half, 3> viewDirOS = normalize(ObjSpaceViewDir(o.vertexOS));

    vector<half, 4> zOffset = 1.0;
    zOffset.xyz = o.vertexcol.z * 0.015 * viewDirOS;
    zOffset.xyz += o.vertexOS;

    o.pos = mul(UNITY_MATRIX_MVP, zOffset);

    // compute vertex lights
    o.vertexLight = ComputeAdditionalLights(vertexWS, o.pos);
    o.vertexLight = min(o.vertexLight, 10);

    // compute light direction
    OpenLitLightDatas lightData;
    ComputeLights(lightData, vector<half, 4>(1.0, 1.0, 0.0, 0.0) * 0.001);
    o.lightData = lightData;

    UNITY_TRANSFER_SHADOW(o, o.pos);
    UNITY_TRANSFER_FOG(o, o.pos);

    return o;
}

vector<float, 4> frag(vsOut i) : SV_Target{
    const vector<half, 3> normalWS = UnityObjectToWorldNormal(i.normalOS);
    const vector<half, 4> vertexWS = mul(UNITY_MATRIX_M, i.vertexOS);
    const vector<half, 3> viewDirWS = normalize(WorldSpaceViewDir(i.vertexOS)); // vs_TEXCOORD2?


    /* TEXTURE CREATION */

    const vector<fixed, 4> mainTex = _MainTex.Sample(sampler_MainTex, i.uv);
    const vector<fixed, 4> valueTex = _ValueTex.Sample(sampler_ValueTex, i.uv);
    const vector<fixed, 4> shadowTex = _ShadowTex.Sample(sampler_ShadowTex, i.uv);

    /* END OF TEXTURE CREATION */


    /* DOT CREATION */

    // NdotL
    half NdotL = dot(i.lightData.lightDirection, normalWS);
    // we need NdotL untouched
    half buffer = NdotL;
    // convert from a range of { -1, 1 } to { 0, 1 }
    NdotL = NdotL * 0.5 + 0.5;
    // control shadow push
    NdotL += _ShadowPush;
    // use blue channel of lightmap texture
    NdotL = saturate(NdotL + (valueTex.z * 2.0 - 1.0));
    // control shadow smoothness, 0.0925 is arbitrary - I wanted to visually match line 217
    NdotL = smoothstep(0.0 + (1.0 - _ShadowSmoothness) * 0.5, 1.0 - (1.0 - _ShadowSmoothness) * 0.5, NdotL + 0.0925);

    // NdotV, probably not needed
    half NdotV = dot(viewDirWS, normalWS);
    // convert from a range of { -1, 1 } to { 0, 1 }
    //NdotV = NdotV * 0.5 + 0.5;

    // NdotH, probably not needed
    // form the halfVector
    vector<half, 3> halfVector = normalize(viewDirWS + i.lightData.lightDirection);
    half NdotH = dot(halfVector, normalWS);

    // shadows
    UNITY_LIGHT_ATTENUATION(attenuation, i, vertexWS);
    NdotL *= lerp(1.0, attenuation, _ShadowStrength);

    /* END OF DOT CREATION */


    /* RAMP CREATION */

    // diffuse ramp, lines 218-221
    vector<fixed, 3> diffuseRamp = lerp(shadowTex, mainTex, NdotL);
    // apply _Shadow1SkinColor, lines 222-224
    vector<fixed, 3> skinColor = lerp(Shadow1SkinColor[_CharacterId - 1.0], DefaultSkinColor[_CharacterId - 1.0], saturate(diffuseRamp.x * 2.0 - 1.0));
    // apply _Shadow1SkinColor, lines 225
    skinColor = lerp(Shadow2SkinColor[_CharacterId - 1.0], skinColor, saturate(diffuseRamp.x + diffuseRamp.x));
    // apply skinColor
    diffuseRamp = lerp(diffuseRamp, skinColor, valueTex.x >= 0.5);

    // rim light ramp
    half rim = pow(saturate(buffer), _RimLength);
    rim *= (1 - saturate(NdotV));
    rim = smoothstep(_RimThickness - 0.01, _RimThickness + 0.01, rim);

    /* END OF RAMP CREATION */


    /* ENVIRONMENT LIGHTING */

    vector<fixed, 3> envLighting = max(max(i.lightData.directLight, i.lightData.indirectLight), i.vertexLight);

    /* END OF ENVIRONMENT LIGHTING */


    /* DEBUGGING */

    if(_ReturnLightmapR != 0){ return vector<fixed, 4>(valueTex.xxx, 1.0); }
    if(_ReturnLightmapG != 0){ return vector<fixed, 4>(valueTex.yyy, 1.0); }
    if(_ReturnLightmapB != 0){ return vector<fixed, 4>(valueTex.zzz, 1.0); }
    if(_ReturnVertexColorR != 0){ return vector<fixed, 4>(i.vertexcol.xxx, 1.0); }
    if(_ReturnVertexColorG != 0){ return vector<fixed, 4>(i.vertexcol.yyy, 1.0); }
    if(_ReturnVertexColorB != 0){ return vector<fixed, 4>(i.vertexcol.zzz, 1.0); }
    if(_ReturnNormals != 0){ return vector<fixed, 4>(i.normalOS, 1.0); }
    if(_ReturnTangents != 0){ return i.tangent; }

    /* END OF DEBUGGING */


    /* COLOR CREATION */

    vector<fixed, 4> finalColor = vector<fixed, 4>(diffuseRamp, 1.0);
    
    // apply environment lighting
    finalColor.xyz = lerp(finalColor.xyz, (blendColorBurn(finalColor.xyz, envLighting, 0.6) * envLighting), _envLightingStrength);

    // apply rim light
    finalColor.xyz += rim * _RimColor * lerp(1.0, envLighting, 0.5) * _RimIntensity * i.vertexcol.y;

    // apply fog
    UNITY_APPLY_FOG(i.fogCoord, finalColor);

    /* END OF COLOR CREATION */ 


    return finalColor;
}
