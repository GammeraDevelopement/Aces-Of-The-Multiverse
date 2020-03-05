﻿//------------------------

//Custom data 1:

//	x = noise speed U
//	y = noise speed V
//	z = noise mul
//	w = noise power

//------------------------

//Custom data 2:

//	x = noise size U
//	y = noise size V
//  z = noise power affect ramp
//  w = noise mul affect ramp

//------------------------
Shader "Gammera/Particles/Dash"
{
	Properties{

		[HDR]_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Ramp", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_InvFade("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_AlphaClip("Alpha Clip",Float) = 1.0

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
					sampler2D _Noise;
					float _NoiseMul;
					float _NoisePower;
					fixed4 _TintColor;
					float _AlphaClip;

					struct appdata_t {
						float4 vertex : POSITION;
						float3 normal : NORMAL;
						fixed4 color : COLOR;
						float4 texcoord : TEXCOORD0;
						float4 texcoord1 : TEXCOORD1;
						float4 texcoord2 : TEXCOORD2;
						UNITY_VERTEX_INPUT_INSTANCE_ID
					};

					struct v2f {
						float4 vertex : SV_POSITION;
						fixed4 color : COLOR;
						float2 texcoord : TEXCOORD0;
						float4 custom1 : TEXCOORD3;
						float4 custom2 : TEXCOORD4;
						UNITY_FOG_COORDS(1)
						#ifdef SOFTPARTICLES_ON
						float4 projPos : TEXCOORD2;
						#endif
						UNITY_VERTEX_OUTPUT_STEREO
					};

					float4 _MainTex_ST;

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
						//float rim = pow(saturate(dot(normalize(ObjSpaceViewDir(v.vertex)),v.normal)),5);
						o.color = v.color/* * rim*/;
						o.custom1 = float4(v.texcoord.zw, v.texcoord1.xy);
						o.custom2 = float4(v.texcoord1.zw, v.texcoord2.xy);
						o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
						UNITY_TRANSFER_FOG(o,o.vertex);
						return o;
					}

					UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
					float _InvFade;

					fixed4 frag(v2f i) : SV_Target
					{
						#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate(_InvFade * (sceneZ - partZ));
						i.color.a *= fade;
						#endif

						float ramp = saturate(pow(tex2D(_MainTex, i.texcoord).x * lerp(1,i.custom1.z,i.custom2.w), lerp(1,i.custom1.w,i.custom2.z)));
						float noise = saturate(pow(tex2D(_Noise, float2(i.texcoord.x * i.custom2.x + (_Time.y * i.custom1.x), i.texcoord.y * i.custom2.y + (_Time.y * i.custom1.y))).x * i.custom1.z, i.custom1.w));

						float fxGrad = ramp * noise;

						fixed4 col = 2.0f * i.color * _TintColor;
						col.a = saturate(col.a * fxGrad); // alpha should not have double-brightness applied to it, but we can't fix that legacy behavior without breaking everyone's effects, so instead clamp the output to get sensible HDR behavior (case 967476)

						clip(_AlphaClip - (1 - col.a));

						UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0,0,0,0)); // fog towards black due to our blend mode
						return col;
					}
					ENDCG
				}
			}
	}
}

