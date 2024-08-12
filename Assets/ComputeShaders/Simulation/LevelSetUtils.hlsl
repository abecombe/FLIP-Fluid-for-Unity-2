#ifndef CS_SIMULATION_LEVEL_SET_UTILS_HLSL
#define CS_SIMULATION_LEVEL_SET_UTILS_HLSL

// LevelSet methods adapted from Christopher Batty's levelset_util.cpp:
// https://github.com/christopherbatty/Fluid3D/blob/master/levelset_util.cpp

inline void cycle_float4(inout float4 val) {
    const float temp = val[0];
    val[0] = val[1];
    val[1] = val[2];
    val[2] = val[3];
    val[3] = temp;
}

// given two signed distance values (line endpoints), determine what fraction of a connecting segment is "inside"
inline float fraction_inside(float phi_left, float phi_right)
{
    if (phi_left < 0 && phi_right < 0) {
        return 1;
    }
    if (phi_left < 0 && phi_right >= 0) {
        return phi_left / (phi_left - phi_right);
    }
    if (phi_left >= 0 && phi_right < 0) {
        return phi_right / (phi_right - phi_left);
    }
    return 0;
}

// given four signed distance values (square corners), determine what fraction of the square is "inside"
inline float fraction_inside(float phibl, float phibr, float phitl, float phitr)
{
    const int inside_count = (phibl < 0 ? 1 : 0) + (phitl < 0 ? 1 : 0) + (phibr < 0 ? 1 : 0) + (phitr < 0 ? 1 : 0);
    const float4 phi_list = float4(phibl, phibr, phitr, phitl);

    switch (inside_count)
    {
        case 4 :
        {
            return 1;
        }
        case 3 :
        {
            // rotate until the positive value is in the first position
            while (phi_list[0] < 0) {
                cycle_float4(phi_list);
            }

            // work out the area of the exterior triangle
            const float side_0 = 1 - fraction_inside(phi_list[0], phi_list[3]);
            const float side_1 = 1 - fraction_inside(phi_list[0], phi_list[1]);
            return 1.0f - 0.5f * side_0 * side_1;
        }
        case 2 :
        {
            // rotate until a negative value is in the first position, and the next negative is in either slot 1 or 2.
            while (phi_list[0] >= 0 || !(phi_list[1] < 0 || phi_list[2] < 0)) {
                cycle_float4(phi_list);
            }

            if (phi_list[1] < 0)
            {
                // the matching signs are adjacent
                const float side_left = fraction_inside(phi_list[0], phi_list[3]);
                const float side_right = fraction_inside(phi_list[1], phi_list[2]);
                return  0.5f * (side_left + side_right);
            }
            else // phi_list[2] < 0
            {
                // matching signs are diagonally opposite
                // determine the centre point's sign to disambiguate this case
                const float middle_point = 0.25f * (phi_list[0] + phi_list[1] + phi_list[2] + phi_list[3]);
                if (middle_point < 0)
                {
                    float area = 0;

                    // first triangle (top left)
                    const float side_1 = 1 - fraction_inside(phi_list[0], phi_list[3]);
                    const float side_3 = 1 - fraction_inside(phi_list[2], phi_list[3]);

                    area += 0.5f * side_1 * side_3;

                    // second triangle (top right)
                    const float side_2 = 1 - fraction_inside(phi_list[2], phi_list[1]);
                    const float side_0 = 1 - fraction_inside(phi_list[0], phi_list[1]);
                    area += 0.5f * side_0 * side_2;

                    return 1.0f - area;
                }
                else // middle_point >= 0
                {
                    float area = 0;

                    // first triangle (bottom left)
                    const float side_0 = fraction_inside(phi_list[0], phi_list[1]);
                    const float side_1 = fraction_inside(phi_list[0], phi_list[3]);
                    area += 0.5f * side_0 * side_1;

                    // second triangle (top right)
                    const float side_2 = fraction_inside(phi_list[2], phi_list[1]);
                    const float side_3 = fraction_inside(phi_list[2], phi_list[3]);
                    area += 0.5f * side_2 * side_3;
                    return area;
                }
            }
        }
        case 1 :
        {
            // rotate until the negative value is in the first position
            while(phi_list[0] >= 0) {
                cycle_float4(phi_list);
            }

            // work out the area of the interior triangle, and subtract from 1.
            const float side_0 = fraction_inside(phi_list[0], phi_list[3]);
            const float side_1 = fraction_inside(phi_list[0], phi_list[1]);
            return 0.5f * side_0 * side_1;
        }
        case 0 :
        default :
        {
            return 0;
        }
    }
}


#endif /* CS_SIMULATION_LEVEL_SET_UTILS_HLSL */