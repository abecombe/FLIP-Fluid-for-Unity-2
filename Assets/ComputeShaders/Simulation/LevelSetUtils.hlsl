#ifndef CS_SIMULATION_LEVEL_SET_UTILS_HLSL
#define CS_SIMULATION_LEVEL_SET_UTILS_HLSL

inline float Percentage(float left, float right)
{
    return left / (left - right);
}

// given five signed distance values (center, bottom left, bottom right, top right, top left), compute the fraction of the cell that is "inside"
inline float FractionInside(float phic, float phibl, float phibr, float phitl, float phitr)
{
    float4 phi_list = float4(phibl, phibr, phitr, phitl);

    float total_inside = 0;
    for (uint i = 0; i < 4; ++i)
    {
        float3 phi = float3(phi_list[i], phi_list[(i + 1u) % 4u], phic);

        float3 phi_sort;
        phi_sort.x = min(phi.x, min(phi.y, phi.z));
        phi_sort.z = max(phi.x, max(phi.y, phi.z));
        phi_sort.y = phi.x + phi.y + phi.z - phi_sort.x - phi_sort.z;

        if (phi_sort.x > 0)
        {
            total_inside += 0;
        }
        else if (phi_sort.y > 0)
        {
            const float side_0 = Percentage(phi_sort.x, phi_sort.y);
            const float side_1 = Percentage(phi_sort.x, phi_sort.z);
            total_inside += side_0 * side_1;
        }
        else if (phi_sort.z > 0)
        {
            const float side_0 = Percentage(phi_sort.z, phi_sort.x);
            const float side_1 = Percentage(phi_sort.z, phi_sort.y);
            total_inside += 1.0f - side_0 * side_1;
        }
        else
        {
            total_inside += 1;
        }
    }
    total_inside *= 0.25f;

    return total_inside;
}


#endif /* CS_SIMULATION_LEVEL_SET_UTILS_HLSL */