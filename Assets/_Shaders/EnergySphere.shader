﻿Shader "Gammera/Particles/EnergySphere"
{
	Properties{

		[HDR]_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_RimFadePower("Rim Fade Power", Range(0.1, 10)) = 1
		_RimFadeMul("Rim Fade Mul", Range(0.1, 1)) = 1
		_Thickness("Thickness", Range(0.01,2.0)) = 1
		_InvFade("Soft Particles Factor", Range(0.01,3.0)) = 1.0

	}

		Category{

			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" }
			Blend SrcAlpha One
			ColorMask RGB
			Cull Off Lighting Off ZWrite Off

			SubShader {
				Pass {

					CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma target 2.0
					#pragma multi_compile_particles
					#pragma multi_compile_fog

					#include "UnityCG.cginc"

					sampler2D _MainTex;
					float4 _MainTex_ST;

					float _RimFadePower;
					float _RimFadeMul;
					float _RimFadeMul2;
					float _Thickness;

					fixed4 _TintColor;

					UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
					float _InvFade;

					struct appdata_t {
						float4 vertex : POSITION;
						float3 normal : NORMAL;
						fixed4 color : COLOR;
						float2 texcoord : TEXCOORD0;
						UNITY_VERTEX_INPUT_INSTANCE_ID
					};

					struct v2f {
						float4 vertex : SV_POSITION;
						fixed4 color : COLOR;
						float2 texcoord : TEXCOORD0;
						float3 normal : TEXCOORD3;
						float3 viewDir : TEXCOORD4;
						UNITY_FOG_COORDS(1)
						#ifdef SOFTPARTICLES_ON
						float4 projPos : TEXCOORD2;
						#endif
						UNITY_VERTEX_OUTPUT_STEREO
					};

					v2f vert(appdata_t v)
					{
						v2f o;
						UNITY_SETUP_INSTANCE_ID(v);
						UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
						o.vertex = UnityObjectToClipPos(v.vertex);
						#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos(o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
						#endif

						o.normal = v.normal;
						o.viewDir = ObjSpaceViewDir(v.vertex);
						o.color = v.color;
						o.texcoord = v.texcoord;
						UNITY_TRANSFER_FOG(o,o.vertex);
						return o;
					}

					fixed4 frag(v2f i) : SV_Target
					{
						#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate(_InvFade * (sceneZ - partZ));
						i.color.a *= fade;
						#endif

						float rimBase = dot(normalize(i.viewDir), i.normal);

						float rim1 = pow(saturate(rimBase * _RimFadeMul), _RimFadePower);
						float rim2 = pow(1 - saturate(rimBase * _RimFadeMul * _Thickness), _RimFadePower * _Thickness);

						float rim = min(rim1,rim2);

						i.color.a *= rim;

						fixed4 col = 2.0f * i.color * _TintColor;
						col.a = saturate(col.a);

						UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0)); // fog towards black due to our blend mode
						return col;
					}
					ENDCG
				}
			}
	}
}

