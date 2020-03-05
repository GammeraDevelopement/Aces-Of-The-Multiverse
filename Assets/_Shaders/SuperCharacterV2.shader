// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Gammera/SuperCharacter" {
Properties {
	[Space(16)]
	_Thickness("Thickness",Float) = 0.5
	[Space(8)]
	_RimPower("Rim Power",Float) = 2.0
	_RimMul("Rim Mul",Float) = 2.0

	[Space(16)]
	_CloudsTex("Clouds Tex",2D) = "white" {}
	_CloudsSize("Clouds Size",Float) = 1.0
	_CloudsSpeed("Clouds Speed",Float) = 1.0
	_Axis("Axis xyz | Height w",Vector) = (1,0,0,1)

	[Space(16)]
	[HDR]_EmissionColor("Emission Color",Color) = (1,1,1,1)
	[HDR]_EmissionColor2("Emission Color 2",Color) = (1,1,1,1)
		
	[Space(16)]
    _InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0

	[Space(32)]
	_DissolveAmount("Dissolve Amount",Range(0,1)) = 1.0
	_AlphaMask("Alpha Mask",Float) = 1.0
}

Category {

	Tags { "Queue" = "Overlay" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" }

	SubShader {

		Blend SrcAlpha One
		ColorMask RGB
		Cull Off Lighting Off ZWrite Off

        Pass {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_particles
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

			float _Thickness;
			float _RimPower;
			float _RimMul;
			float4 _EmissionColor;
			float4 _EmissionColor2;
			sampler2D _CloudsTex;
			float _CloudsSize;
			float _CloudsSpeed;
			float4 _Axis;
			float _DissolveAmount;

            struct appdata_t {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD3;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
				float3 viewDir : TEXCOORD4;
                UNITY_FOG_COORDS(1)
                float4 projPos : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
            };


            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 worldPos = mul(unity_ObjectToWorld,v.vertex);

				float cloudXY = tex2Dlod(_CloudsTex, float4((worldPos.xy * _CloudsSize) - float2(0, _Time.y * _CloudsSpeed), 0, 0)).r;
				float cloudZY = tex2Dlod(_CloudsTex, float4((worldPos.zy * _CloudsSize) - float2(0, _Time.y * _CloudsSpeed), 0, 0)).r;
				float cloudXZ = tex2Dlod(_CloudsTex, float4((worldPos.xz * _CloudsSize) - float2(0, _Time.y * _CloudsSpeed), 0, 0)).r;

				float cloud = lerp(lerp(cloudXY, cloudZY, abs(v.normal.x)), cloudXZ, abs(v.normal.y));

				float3 vertexAxis = v.vertex.xyz * _Axis.xyz;
				float height = saturate((vertexAxis.x + vertexAxis.y + vertexAxis.z) / _Axis.w);

				v.vertex.xyz += v.normal * _Thickness * (cloud * (height + 0.5));

				o.color = float4(cloud,0,0,1);

                o.vertex = UnityObjectToClipPos(v.vertex);

                o.projPos = ComputeScreenPos (o.vertex);
                COMPUTE_EYEDEPTH(o.projPos.z);

                o.texcoord = v.texcoord;
				o.normal = v.normal;
				o.viewDir = ObjSpaceViewDir(v.vertex);

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            float _InvFade;

            fixed4 frag (v2f i) : SV_Target
            {
                float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                float partZ = i.projPos.z;
                float fade = saturate (_InvFade * (sceneZ-partZ));

				float rim = pow(saturate(dot(normalize(i.normal),normalize(i.viewDir)) * _RimMul),_RimPower);

				float4 col;
				col.rgb = lerp(_EmissionColor.rgb, _EmissionColor2.rgb, i.color.r * 2.0);
                col.a = (_EmissionColor.a * (fade * rim)) * (1 - _DissolveAmount);

                UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
            }
            ENDCG
        }

		Blend One One
		ColorMask A
		Cull Off Lighting Off ZWrite Off

		Pass{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_particles

			#include "UnityCG.cginc"

			float _Thickness;
			float _RimPower;
			float _RimMul;
			float4 _EmissionColor;
			float4 _EmissionColor2;
			sampler2D _CloudsTex;
			float _CloudsSize;
			float _CloudsSpeed;
			float _AlphaMask;
			float _DissolveAmount;

			struct appdata_t {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 normal : TEXCOORD3;
				float2 texcoord : TEXCOORD0;
				float3 viewDir : TEXCOORD4;
				UNITY_VERTEX_OUTPUT_STEREO
			};


			v2f vert(appdata_t v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float cloudXY = tex2Dlod(_CloudsTex, float4((v.vertex.xy * _CloudsSize) - float2(0, _Time.y * _CloudsSpeed), 0, 0)).r;
				float cloudZY = tex2Dlod(_CloudsTex, float4((v.vertex.zy * _CloudsSize) - float2(0, _Time.y * _CloudsSpeed), 0, 0)).r;
				float cloudXZ = tex2Dlod(_CloudsTex, float4((v.vertex.xz * _CloudsSize) - float2(0, _Time.y * _CloudsSpeed), 0, 0)).r;

				float cloud = lerp(lerp(cloudXY, cloudZY, abs(v.normal.x)), cloudXZ, abs(v.normal.y));

				v.vertex.xyz += v.normal * _Thickness * (cloud * (v.vertex.y + 0.5));

				o.vertex = UnityObjectToClipPos(v.vertex);

				o.texcoord = v.texcoord;
				o.normal = v.normal;
				o.viewDir = ObjSpaceViewDir(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float rim = pow(saturate(dot(normalize(i.normal),normalize(i.viewDir)) * _RimMul),_RimPower);

				float4 col;
				col.rgb = float3(0,0,0);
				col.a = saturate(_AlphaMask * rim) * (1 - _DissolveAmount);
				return col;
			}
			ENDCG
			}
    }
}
}
