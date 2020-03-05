// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Gammera/DistanceMask" {
Properties {
    [HDR]_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
    _MainTex ("Particle Texture", 2D) = "white" {}

	[Space(8)]
	[Header(UVW Animations Params)]
	_UVAnimationParams("X Speed x | Y Speed y | Z Speed z | W Scale",Vector) = (1,1,1,1)

	[Space(8)]
    _InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
}

Category {
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
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

			#define BALLARRAYCOUNT 4
			#define PLAYERARRAYCOUNT 10

            sampler2D _MainTex;
			float4 _MainTex_ST;

            fixed4 _TintColor;

			float4 _UVAnimationParams;

			UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
			float _InvFade;

			float4 _BallPositions [BALLARRAYCOUNT];
			float4 _PlayerPositions [PLAYERARRAYCOUNT];

			float4 _BallColor;
			float4 _PlayerColor;

			float _BallSize;
			float _PlayerSize;


            struct appdata_t {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
				float3 normal : TEXCOORD3;
				float4 worldPos : TEXCOORD4;

                UNITY_FOG_COORDS(1)
                #ifdef SOFTPARTICLES_ON
                float4 projPos : TEXCOORD2;
                #endif
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                #ifdef SOFTPARTICLES_ON
                o.projPos = ComputeScreenPos (o.vertex);
                COMPUTE_EYEDEPTH(o.projPos.z);
                #endif

                o.color = v.color * _TintColor;
                o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				//Soft Particles
                #ifdef SOFTPARTICLES_ON
                float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                float partZ = i.projPos.z;
                float fade = saturate (_InvFade * (sceneZ-partZ));
                i.color.a *= fade;
                #endif

				//Triplanar texture
				float3 blendfactor = normalize(abs(i.normal));
				blendfactor /= dot(blendfactor, (float3)1);

				fixed4 mainTex_XY = tex2D(_MainTex,i.worldPos.xy * _UVAnimationParams.w + (_Time.y * _UVAnimationParams.xy)) * blendfactor.z;
				fixed4 mainTex_YZ = tex2D(_MainTex,i.worldPos.yz * _UVAnimationParams.w + (_Time.y * _UVAnimationParams.yz)) * blendfactor.x;
				fixed4 mainTex_XZ = tex2D(_MainTex,i.worldPos.xz * _UVAnimationParams.w + (_Time.y * _UVAnimationParams.xz)) * blendfactor.y;

				fixed4 mainTex = (mainTex_XY + mainTex_YZ + mainTex_XZ);

				//Distance mask
				float ballMask = 0;
				float playerMask = 0;

				[unroll]
				for (int b = 0; b < BALLARRAYCOUNT; b++)
				{
					float distance = length(_BallPositions[b].xyz - i.worldPos.xyz);
					float sphere = 1 - saturate(distance / _BallSize);

					ballMask += sphere;
				}

				[unroll]
				for (int p = 0; p < PLAYERARRAYCOUNT; p++)
				{
					float distance = length(_PlayerPositions[p].xyz - i.worldPos.xyz);
					float sphere = 1 - saturate(distance / _PlayerSize);

					playerMask += sphere;
				}

				float4 mask = saturate(ballMask * _BallColor + playerMask * _PlayerColor);


				//Final color
                fixed4 col = 2.0f * i.color * mainTex * mask;
                col.a = saturate(col.a);

                UNITY_APPLY_FOG(i.fogCoord, col);

                return col;
            }
            ENDCG
        }
    }
}
}
