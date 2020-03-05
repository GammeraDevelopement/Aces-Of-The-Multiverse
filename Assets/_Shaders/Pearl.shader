Shader "Gammera/Iridescent" {
	Properties{
		_Color("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		[Space(16)]
		_Noise("Noise (RGB)", 2D) = "white" {} // noise texture
		_IrTex("Iridescence Ramp (RGB)", 2D) = "white" {} // color ramp
		_IrColor("Ir Color", Color) = (0.5,0.5,0.5,1)// extra iridescence tinting
		_Offset("Iridescence Ramp Offset", Range(0, 1)) = 1 // offset of the color ramp
		_Brightness("Iridescence Opacity", Range(0, 1)) = 1 // opacity of iridescence
		_WorldScale("Noise Worldscale", Range(.002, 5)) = 1 // noise scale


	}

	SubShader{
	Tags{ "RenderType" = "Opaque" }
	LOD 200

	CGPROGRAM
		#pragma surface surf Standard vertex:vert fullforwardshadows

		sampler2D _MainTex;
		sampler2D _Noise; // noise
		sampler2D _IrTex; // color ramp
		float4 _Color;
		float4 _IrColor; // extra tinting
		float _Offset; // color ramp offset
		float _Brightness; // Iridescence opacity
		float _WorldScale; // noise scale

		half _Glossiness;
		half _Metallic;

		struct Input {
			float3 viewDir; // view direction
			float3 localPos;
			float3 localNormal;
		};

		void vert(inout appdata_full v,out Input o) {

			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.localPos = v.vertex.xyz;
			o.localNormal = v.normal.xyz;

		}

		void surf(Input IN, inout SurfaceOutputStandard o) {

			// Blending factor of triplanar mapping
			float3 bf = normalize(abs(IN.localNormal));
			bf /= dot(bf, (float3)1);

			// Triplanar mapping
			float2 tx = IN.localPos.yz * _WorldScale;
			float2 ty = IN.localPos.zx * _WorldScale;
			float2 tz = IN.localPos.xy * _WorldScale;

			//Noise
			half4 cx = tex2D(_Noise, tx) * bf.x;
			half4 cy = tex2D(_Noise, ty) * bf.y;
			half4 cz = tex2D(_Noise, tz) * bf.z;

			half4 n = (cx + cy + cz);

			//Albedo
			half4 ax = tex2D(_Noise, tx) * bf.x;
			half4 ay = tex2D(_Noise, ty) * bf.y;
			half4 az = tex2D(_Noise, tz) * bf.z;

			half4 c = (ax + ay + az) * _Color;


			//Composition
			half f = 1 - dot(o.Normal, IN.viewDir) + _Offset; // fresnel

			half3 i = tex2D(_IrTex, float2(f,f) + n).rgb * _IrColor; // iridescence effect

			o.Albedo = (c.rgb) + ((i * n) * _Brightness); // multiplied by original texture, with an opacity float

			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			o.Alpha = c.a;
		}
	ENDCG

	}

	Fallback "Diffuse"
}