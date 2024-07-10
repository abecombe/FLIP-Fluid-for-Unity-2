Shader "ParticleRendering/PreparePBR"
{
    CGINCLUDE

    #include "../../Common.hlsl"

    sampler2D _MainTex;
    float4 _MainTex_TexelSize;

    sampler2D _AOTex;
    float4 _AOTex_TexelSize;

    float2 Frag(v2f_default i) : SV_Target
    {
        return float2(tex2D(_MainTex, i.texcoord).r, tex2D(_AOTex, i.texcoord).r);
    }

    ENDCG

    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags{ "RenderType" = "Opaque" }

        ZTest Always
        Cull Off
        ZWrite Off
        Blend Off

        // 0
        Pass
        {
            CGPROGRAM
            #pragma target   5.0
            #pragma vertex   VertDefault
            #pragma fragment Frag
            ENDCG
        }
    }
}