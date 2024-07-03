Shader "ScreenSpaceFluidRendering/ParticleInstance"
{
    CGINCLUDE

    #include "../../Common.hlsl"

    StructuredBuffer<float4> _ParticleRenderingBuffer;

    float _Radius;
    float _NearClipPlane;
    float _FarClipPlane;

    struct v2f
    {
        float4 vertex : SV_POSITION;
        float2 texcoord : TEXCOORD0;
        float depth : TEXCOORD1;
    };

    // --------------------------------------------------------------------
    // Vertex Shader
    // --------------------------------------------------------------------
    v2f Vertex(appdata_default v, uint id : SV_InstanceID)
    {
        v2f o;

        float3 position = _ParticleRenderingBuffer[id].xyz;
        position += v.vertex.xyz * _Radius;

        // Tranforms position from world to Clip Space
        o.vertex = mul(UNITY_MATRIX_VP, float4(position, 1));

        o.texcoord = v.texcoord.xy;

        // Calculate depth
        o.depth = -mul(UNITY_MATRIX_V, float4(position, 1)).z;

        return o;
    }

    // --------------------------------------------------------------------
    // Fragment Shader
    // --------------------------------------------------------------------
    float4 Fragment(v2f i) : SV_Target
    {
        const float2 pos_in_circle = i.texcoord * 2.0 - 1.0;
        const float r2 = dot(pos_in_circle, pos_in_circle);
        if (r2 > 1.0) discard;

        const float depth = i.depth - sqrt(1.0 - r2) * _Radius;
        if (depth < _NearClipPlane || depth > _FarClipPlane) discard;

        return float4((float3)(depth / _FarClipPlane), 1);
    }

    ENDCG

    Properties
    {
    }

    SubShader
    {
        Tags{ "RenderType" = "Opaque" }

        Cull Back
        ZWrite Off
        ZTest Always
        Blend One One, One One
        BlendOp Min, Add

        Pass
        {
            CGPROGRAM
            #pragma target   5.0
            #pragma vertex   Vertex
            #pragma fragment Fragment
            ENDCG
        }
    }
}