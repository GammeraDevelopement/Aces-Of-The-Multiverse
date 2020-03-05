Shader "Gammera/StandardAnimatedEmission"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		
		[Space(16)]
        [Normal]_BumpMap ("Normal", 2D) = "bump" {}
		
		[Space(16)]
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		[Space(16)]
		_Emission("Emission", 2D) = "black" {}
		[HDR]_EmissionColor("Color", Color) = (1,1,1,1)
		
		[Space(8)]
		_Noise("Noise",2D) = "black" {}
		_NoiseParams("Noise Speed X Y | Noise Scale Z | Noise power W",Vector) = (0,0,0,0)
		_NoiseDisplacement("Noise Displacement",Range(-100,100)) = 0
		
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard vertex:vert fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _Emission;
		sampler2D _Noise;

		half4 _NoiseParams;

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float4 _EmissionColor;

		float _NoiseDisplacement;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_Emission;
			float3 worldPos;
			float4 color;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata_full v/*, out Input o*/) {

			//UNITY_INITIALIZE_OUTPUT(Input,o);
			
			float3 worldPos = mul(unity_ObjectToWorld,v.vertex);

			half emissionTex = tex2Dlod(_Emission, float4(v.texcoord.xy, 0, 0)).r;
			half noiseTex = tex2Dlod(_Noise, float4(worldPos.x + _NoiseParams.x * _Time.y, worldPos.z + _NoiseParams.y * _Time.y, 0, 0) * _NoiseParams.z).r;

			half displace = emissionTex * (noiseTex *_NoiseDisplacement);

			//o.color = half4(noiseTex,0,0,0);

			v.vertex.xyz += v.normal * displace;

		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap,IN.uv_BumpMap));

			half emissionTex = tex2D(_Emission, IN.uv_Emission).r;
			half noiseTex = pow(tex2D(_Noise, float2(IN.worldPos.x + _NoiseParams.x * _Time.y, IN.worldPos.z + _NoiseParams.y * _Time.y) * _NoiseParams.z), _NoiseParams.w).r;

			float emissionMask = emissionTex * noiseTex;

			o.Emission = emissionMask * _EmissionColor;

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
