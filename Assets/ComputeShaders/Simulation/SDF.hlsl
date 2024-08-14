#ifndef CS_SIMULATION_SDF_HLSL
#define CS_SIMULATION_SDF_HLSL

inline float SDFSphereInside(float3 position, float3 center, float radius)
{
    return length(position - center) - radius;
}

inline float SDFSphereOutside(float3 position, float3 center, float radius)
{
    return radius - length(position - center);
}

inline float SDFBox(float3 position, float3 center, float3 size)
{
    float3 d = abs(position - center) - size;
    return min(max(d.x, max(d.y, d.z)), 0.0f) + length(max(d, 0.0f));
}


#endif /* CS_SIMULATION_SDF_HLSL */