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

Shader ".festivity/SekaiToon/SekaiToon-main"{
    Properties{
        [Header(Textures)] [MainTex] [NoScaleOffset] [HDR] [Space(10)] _MainTex ("Diffuse", 2D) = "white"{}
        [NoScaleOffset] [HDR] _ShadowTex ("Shadow", 2D) = "black"{}
        [NoScaleOffset] _ValueTex ("Lightmap", 2D) = "white"{}
        [Toggle] _ToggleLongTex ("Long Textures? (turn this on if textures have an aspect ratio of 2:1", Range(0.0, 1.0)) = 0.0

        [Header(Character Selection)] [Space(10)] [IntRange] _CharacterId ("Select Character", Range(1.0, 21.0)) = 1.0

        [Header(Main Settings)] [Space(10)] [Gamma] [HideInInspector] _DefaultSkinColor ("Default Skin Color", Color) = (0.9921875, 0.9609375, 0.921875, 1.0)
        [Gamma] [HideInInspector] _Shadow1SkinColor ("Shadow 1 Skin Color", Color) = (0.890625, 0.7695313, 0.796875, 1.0)
        [Gamma] [HideInInspector] _Shadow2SkinColor ("Shadow 2 Skin Color", Color) = (0.796875, 0.59375, 0.6367188, 1.0)

        [Header(Lighting)] [Space(10)] _ShadowStrength ("Shadow Strength", Range(0.0, 1.0)) = 1.0
        _ShadowPush ("Shadow Push", Range(-2.0, 2.0)) = 0.0
        _ShadowSmoothness ("Shadow Smoothness", Range(0.0, 1.0)) = 0.01
        _envLightingStrength ("Environment Lighting Strength", Range(0.0, 1.0)) = 1.0
        _RimIntensity ("Rim Light Strength", Range(0.0, 1.0)) = 0.5
        _RimLength ("Rim Light Length", Range(0.0, 1.0)) = 0.25
        _RimThickness ("Rim Light Thickness", Range(0.0, 1.0)) = 0.65
        [Gamma] _RimColor ("Rim Light Color", Color) = (1.0, 1.0, 1.0, 1.0)
        
        [Header(Outlines)] [Space(10)] [KeywordEnum(None, Normal, Tangent)] _OutlineType ("Outline Type", Float) = 1.0
        _OutlineWidth ("Outline Thickness", Float) = 0.001

        [Header(Debugging)] [Space(10)] [Toggle] _ReturnLightmapR ("Show Lightmap Red", Range(0.0, 1.0)) = 0.0
        [Toggle] _ReturnLightmapG ("Show Lightmap Green", Range(0.0, 1.0)) = 0.0
        [Toggle] _ReturnLightmapB ("Show Lightmap Blue", Range(0.0, 1.0)) = 0.0
        [Toggle] _ReturnVertexColorR ("Show Vertex Color Red", Range(0.0, 1.0)) = 0.0
        [Toggle] _ReturnVertexColorG ("Show Vertex Color Green", Range(0.0, 1.0)) = 0.0
        [Toggle] _ReturnVertexColorB ("Show Vertex Color Blue", Range(0.0, 1.0)) = 0.0
        [Toggle] _ReturnNormals ("Show Normals", Range(0.0, 1.0)) = 0.0
        [Toggle] _ReturnTangents ("Show Tangents", Range(0.0, 1.0)) = 0.0
    }
    SubShader{
        Tags{
            "RenderType" = "Opaque"
            "Queue" = "Geometry+70"
        }

        HLSLINCLUDE

        #pragma vertex vert
        #pragma fragment frag

        #pragma multi_compile _ UNITY_HDR_ON
        #pragma multi_compile_fog
        #pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED

        #include "UnityCG.cginc"
        #include "Lighting.cginc"
        #include "AutoLight.cginc"
        #include "UnityLightingCommon.cginc"
        #include "UnityShaderVariables.cginc"
        
        #include "OpenLit-core.hlsl" // https://github.com/lilxyzw/OpenLit/


        /* properties */

        Texture2D _MainTex;                 SamplerState sampler_MainTex;
        Texture2D _ShadowTex;               SamplerState sampler_ShadowTex;
        Texture2D _ValueTex;                SamplerState sampler_ValueTex;
        float _ToggleLongTex;

        float _CharacterId;

        vector<float, 4> _DefaultSkinColor;
        vector<float, 4> _Shadow1SkinColor;
        vector<float, 4> _Shadow2SkinColor;

        float _ShadowStrength;
        float _ShadowPush;
        float _ShadowSmoothness;
        float _envLightingStrength;
        float _RimIntensity;
        float _RimLength;
        float _RimThickness;
        vector<float, 4> _RimColor;

        float _OutlineType;
        float _OutlineWidth;

        float _ReturnLightmapR;
        float _ReturnLightmapG;
        float _ReturnLightmapB;
        float _ReturnVertexColorR;
        float _ReturnVertexColorG;
        float _ReturnVertexColorB;
        float _ReturnNormals;
        float _ReturnTangents;

        /* end of properties */


        ENDHLSL

        Pass{
            Name "ForwardBase"

            Tags{ "LightMode" = "ForwardBase" }

            HLSLPROGRAM

            #pragma multi_compile_fwdbase

            #include "SekaiToon-base.hlsl"

            ENDHLSL
        }
        Pass{
            Name "OutlinePass"

            Cull Front

            HLSLPROGRAM

            #pragma multi_compile_fwdbase

            #include "SekaiToon-outlines.hlsl"

            ENDHLSL
        }
        UsePass "Standard/SHADOWCASTER"
    }
}
