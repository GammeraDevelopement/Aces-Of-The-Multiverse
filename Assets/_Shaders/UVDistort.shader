﻿
Shader "Gammera/Particles/UVDistort" {

	Properties{

		_TintColor("Tint Color",Color) =  (0,0,0,1)
		_MainTex("Particle Texture", 2D) = "white" {}
		[NoScaleOffset]_UVDistortTex("UV Distort Texture", 2D) = "white" {}
		_DistortParams("XY Speed | Z Scale | W Intensity",Vector) = (1,1,1,1)
		_InvFade("Soft Particles Factor", Range(0.01,3.0)) = 1.0

	}

	Category{

		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" }
		Blend SrcAlpha OneMinusSrcAlpha
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
				sampler2D _UVDistortTex;

				float4 _MainTex_ST;
				float4 _DistortParams;

				fixed4 _TintColor;

				UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
				float _InvFade;


				struct appdata_t {
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f {
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)

					float4 projPos : TEXCOORD2;
					UNITY_VERTEX_OUTPUT_STEREO
				};


				v2f vert(appdata_t v)
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.projPos = ComputeScreenPos(o.vertex);
					#ifdef SOFTPARTICLES_ON
					COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
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

					//uv distortion
					float2 uvDistortTex = (tex2D(_UVDistortTex,((i.projPos.xy / i.projPos.w) + (_DistortParams.xy * _Time.y)) * _DistortParams.z).rg - 0.5) * 2.0;
					float2 uvDistort = i.texcoord + (uvDistortTex * _DistortParams.w);


					fixed4 col = 2.0f * i.color * tex2D(_MainTex, uvDistort);
					col.a = saturate(col.a); // alpha should not have double-brightness applied to it, but we can't fix that legacy behavior without breaking everyone's effects, so instead clamp the output to get sensible HDR behavior (case 967476)

					UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(1,1,1,1)); // fog towards white due to our blend mode


					return col;
				}
				ENDCG
			}
		}
	}

}
