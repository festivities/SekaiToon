#include "SekaiToon-inputs.hlsli"

#include "SekaiToon-helpers.hlsl"

vsOut vert(vsIn i){
    vsOut o;
    //o.pos = mul(UNITY_MATRIX_MVP, i.vertex); // transform to clip space
    o.normalOS = i.normal;
    o.tangent = i.tangent;
    o.vertexOS = i.vertex;
    o.uv = (_ToggleLongTex != 0) ? vector<float, 2>(i.uv.x * 0.5, i.uv.y) : i.uv; // vs_TEXCOORD1
    o.vertexcol.x = i.vertexcol.x; // outline direction, EdgeScale_view @ line 246
    o.vertexcol.y = i.vertexcol.y; // rim intensity, RimScale_view @ line 247
    o.vertexcol.z = i.vertexcol.z; // eyebrow mask, used for making them appear in front of the hair at all times
    o.vertexcol.w = i.vertexcol.w; // UNUSED

    const vector<half, 4> vertexWS = mul(UNITY_MATRIX_M, i.vertex); // transform to world space

    if(_OutlineType != 0){
        const half _OutlineCorrectionWidth = 2.25;
        const vector<half, 4> _OutlineWidthAdjustScales = vector<half, 4>(0.01, 0.245, 0.6, 0.0);
        const vector<half, 4> _OutlineWidthAdjustZs = vector<half, 4>(0.001, 2.0, 6.0, 0.0);

        // formula is literally just how miHoYo does outlines
        vector<half, 4> vViewPosition = mul(UNITY_MATRIX_MV, o.vertexOS);
        half fovScale = (2.41400003 / unity_CameraProjection[1][1]) * -vViewPosition.z;

        vector<half, 2> zRange, scales;
        if (fovScale < _OutlineWidthAdjustZs.y){
            zRange = _OutlineWidthAdjustZs.xy;
            scales = _OutlineWidthAdjustScales.xy;
        }
        else{
            zRange = _OutlineWidthAdjustZs.yz;
            scales = _OutlineWidthAdjustScales.yz;
        }
        fovScale = lerpByZ(scales.x, scales.y, zRange.x, zRange.y, fovScale);
        vector<half, 4> scale;
        scale = _OutlineWidth * _OutlineCorrectionWidth;
        fovScale *= scale.x;
        fovScale *= 4000.0;
        fovScale *= 0.414250195;
        // base outline thickness
        fovScale *= o.vertexcol.x;

        half zOffset = 0.000125;

        // get outline direction, can be either the raw normals (HORRIBLE) or the custom tangents
        vector<half, 3> outlineDirection;
        switch(_OutlineType){
            case 1:
                outlineDirection = o.normalOS;
                break;
            case 2:
                outlineDirection = o.tangent.xyz;
                break;
            default:
                break;
        }

        // get camera view direction
        vector<half, 3> viewDirWS = normalize(_WorldSpaceCameraPos - vertexWS);

        vViewPosition = vector<half, 4>(scale.xyz, 0);
        vViewPosition.xyz = vViewPosition.xyz * outlineDirection.xyz * fovScale;
        vViewPosition = vViewPosition - mul(unity_WorldToObject, viewDirWS) * zOffset;
        vViewPosition += o.vertexOS;
        // convert to clip space
        vViewPosition = mul(UNITY_MATRIX_MVP, vViewPosition);

        o.pos = vViewPosition;
    }
    else{
        o.pos = vector<half, 4>(0.0, 0.0, 0.0, 0.0);
    }

    // compute vertex lights
    o.vertexLight = ComputeAdditionalLights(vertexWS, o.pos);
    o.vertexLight = min(o.vertexLight, 10);

    // compute light direction
    OpenLitLightDatas lightData;
    ComputeLights(lightData, vector<half, 4>(1.0, 1.0, 0.0, 0.0) * 0.001);
    o.lightData = lightData;

    UNITY_TRANSFER_FOG(o, o.pos);

    return o;
}

vector<float, 4> frag(vsOut i) : SV_Target{
    /* TEXTURE CREATION */

    const vector<fixed, 4> mainTex = _MainTex.Sample(sampler_MainTex, i.uv);

    /* END OF TEXTURE CREATION */


    /* ENVIRONMENT LIGHTING */

    vector<fixed, 3> envLighting = max(max(i.lightData.directLight, i.lightData.indirectLight), i.vertexLight);

    /* END OF ENVIRONMENT LIGHTING */


    /* COLOR CREATION */

    vector<fixed, 4> finalColor = mainTex * 0.375;

    // apply environment lighting
    finalColor.xyz = lerp(finalColor.xyz, (blendColorBurn(finalColor.xyz, 
                     min(envLighting, 1), 0.6) * min(envLighting, 1)), _envLightingStrength);

    // apply fog
    UNITY_APPLY_FOG(i.fogCoord, finalColor);

    /* END OF COLOR CREATION */


    return finalColor;
}
