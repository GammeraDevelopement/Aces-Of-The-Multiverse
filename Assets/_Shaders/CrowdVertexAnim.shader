Shader "Gammera/Characters/CrowdVertexAnim"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _EmissionMap ("Emission map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,1)


		[Space(8)]
		_AnimParams("X Frecuenty | Y Amplitude | Z Speed | W Remap01",Vector) = (0,0,0,0)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard vertex:vert addshadow
        #pragma target 3.0

		sampler2D _MainTex;
		sampler2D _EmissionMap;
		float4 _EmissionColor;
		fixed4 _Color;
		half4 _AnimParams;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		float Rand(float3 co)
		{
			return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 53.539))) * 43758.5453);
		}

        struct Input
        {
            float2 uv_MainTex;
        };

		void vert(inout appdata_full v) {

			float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
			half anim = (sin((worldPos.y + _Time.y * _AnimParams.z) * _AnimParams.x) * _AnimParams.w + 1 - _AnimParams.w) * _AnimParams.y;
			v.vertex.xyz += float3(0,0,1) * anim;

		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
			o.Emission = tex2D(_EmissionMap, IN.uv_MainTex) * _EmissionColor;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
