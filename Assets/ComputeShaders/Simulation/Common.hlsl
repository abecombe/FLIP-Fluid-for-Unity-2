#ifndef CS_SIMULATION_COMMON_HLSL
#define CS_SIMULATION_COMMON_HLSL

float _DeltaTime;

#include "Assets/Packages/GPUUtil/DispatchHelper.hlsl"

#include "../Constant.hlsl"

#include "../GridData.hlsl"
#include "../GridHelper.hlsl"

#include "FLIPParticle.hlsl"
#include "CellType.hlsl"
#include "BoundaryCondition.hlsl"
#include "KernelFunc.hlsl"
#include "Obstacle.hlsl"
#include "SDF.hlsl"
#include "LevelSetUtils.hlsl"


#endif /* CS_SIMULATION_COMMON_HLSL */