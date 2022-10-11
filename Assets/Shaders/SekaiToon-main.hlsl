////////////////////////////////////////////////////////////////////////////////////////////////
//
//  SekaiToon [Project Sekai shader for Unity (Built-in Rendering Pipeline)]
//
//  Originally for MMD by: KH40 (khoast40) - https://github.com/KH40-khoast40/Shadekai/
//  Fork by: festivity - https://github.com/festivize/SekaiToon/
//  Base shader: 舞力介入P
//  Special thanks: Yukikami, lilxyzw
//
////////////////////////////////////////////////////////////////////////////////////////////////

#include "SekaiToon-inputs.hlsli"

#include "SekaiToon-helpers.hlsl"

vsOut vert(vsIn i){
    vsOut o;
    o.pos = mul(UNITY_MATRIX_MVP, i.vertex); // transform to clip space
    o.normalOS = i.normal;
    o.tangent = i.tangent;
    o.vertexOS = i.vertex;
    o.uv = i.uv;
    o.vertexcol.x = i.vertexcol.x; // outline direction, EdgeScale_view @ line 246
    o.vertexcol.y = i.vertexcol.y; // rim intensity, RimScale_view @ line 247
    o.vertexcol.z = i.vertexcol.z; // eyebrow mask, used for making them appear in front of the hair at all times
    o.vertexcol.w = i.vertexcol.w; // UNUSED

    const vector<half, 4> vertexWS = normalize(mul(UNITY_MATRIX_M, i.vertex)); // transform to world space

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
    const vector<half, 4> vertexWS = normalize(mul(UNITY_MATRIX_M, i.vertexOS));
    const vector<half, 3> viewDir = normalize(WorldSpaceViewDir(i.vertexOS));


    /* TEXTURE CREATION */

    const vector<fixed, 4> diffuseTex = _DiffuseTex.Sample(sampler_DiffuseTex, i.uv);
    const vector<fixed, 4> lightmapTex = _LightmapTex.Sample(sampler_LightmapTex, i.uv);
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
    // control shadow smoothness
    NdotL = smoothstep(0.0 + (1.0 - _ShadowSmoothness) * 0.5, 1.0 - (1.0 - _ShadowSmoothness) * 0.5, NdotL);
    // control shadow push

    // NdotV, probably not needed
    half NdotV = dot(viewDir, normalWS);
    // convert from a range of { -1, 1 } to { 0, 1 }
    //NdotV = NdotV * 0.5 + 0.5;

    // NdotH, probably not needed
    // form the halfVector
    vector<half, 3> halfVector = normalize(viewDir + i.lightData.lightDirection);
    half NdotH = dot(halfVector, normalWS);

    // shadows
    UNITY_LIGHT_ATTENUATION(attenuation, i, vertexWS);
    if(_ReceiveShadows != 0){ NdotL *= attenuation; }

    /* END OF DOT CREATION */


    /* RAMP CREATION */

    // diffuse ramp
    vector<fixed, 3> diffuseRamp = lerp(shadowTex, diffuseTex, NdotL);
    
    vector<fixed, 3> colorSkin = diffuseRamp * (Skin_Color[_Character - 1.0] / 255.0);
    colorSkin = max(colorSkin, (SkinShade_Color[_Character - 1.0] / 255.0));

    diffuseRamp = lerp(diffuseRamp, colorSkin, lightmapTex.x);

    // rim light ramp
    half rim = pow(saturate(buffer), _RimLength);
    rim *= (1 - saturate(NdotV));
    rim = smoothstep(_RimThickness - 0.01, _RimThickness + 0.01, rim);

    /* END OF RAMP CREATION */


    /* ENVIRONMENT LIGHTING */

    vector<fixed, 3> envLighting = max(max(i.lightData.directLight, i.lightData.indirectLight), i.vertexLight);

    /* END OF ENVIRONMENT LIGHTING */


    /* DEBUGGING */

    if(_ReturnVertexColorR != 0){ return vector<fixed, 4>(i.vertexcol.x, 0.0, 0.0, 1.0); }
    if(_ReturnVertexColorG != 0){ return vector<fixed, 4>(0.0, i.vertexcol.y, 0.0, 1.0); }
    if(_ReturnVertexColorB != 0){ return vector<fixed, 4>(0.0, 0.0, i.vertexcol.z, 1.0); }
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
