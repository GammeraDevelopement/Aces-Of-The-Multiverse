Shader "Gammera/Particles/Lightning"
{
    Properties
    {
        [NoScaleOffset]_DisplaceTex ("Displace Tex", 2D) = "white" {}
		_DisplaceParams("DisScale | DisSpeed | DisIntensity",Vector) = (0,0,0,0)

		[HDR]_Color1("Color1",Color) = (0,0,0,1)
		_Speed("Speed",Float) = 0

		_Cutout("Cutout", Float) = 0
    }
    SubShader
    {
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off
			Lighting Off
			ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

			sampler2D _DisplaceTex;
			float4 _DisplaceParams;
			
			float _Cutout;
			float _Speed;

			float4 _Color1;

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float4 color : COLOR;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
				
				// get vertex world position
				float4 worldPos = mul(v.vertex, unity_ObjectToWorld);
				float displaceNoise = tex2Dlod(_DisplaceTex,float4(worldPos.xz * _DisplaceParams.x + float2(_Time.y * _DisplaceParams.y,0),0,0)).x * _DisplaceParams.z;

				v.vertex.xyz += v.normal * displaceNoise;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				o.color = v.color;


                return o;
            }

			float rand1dTo1d(float value, float mutator = 0.546) {
				float random = frac(sin(value + mutator) * 143758.5453);
				return random;
			}

            fixed4 frag (v2f i) : SV_Target
            {
				float randomFrame = clamp(rand1dTo1d(_Time * _Speed),0,1);
				float frame = step(i.color.r,randomFrame);
				float frameCutout = step(i.color.r, (randomFrame + _Cutout));
                // sample the texture
				fixed4 col = _Color1;//tex2D(_MainTex, i.uv);

			    clip(-(1- (frame - frameCutout)));

                return col;
            }
            ENDCG
        }
    }
}
