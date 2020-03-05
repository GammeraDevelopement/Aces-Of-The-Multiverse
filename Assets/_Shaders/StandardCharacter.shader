
Shader "Gammera/StandardCharacter"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_DisolveGuide("Disolve Guide", 2D) = "white" {}
		_BurnRamp("Burn Ramp", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_MetallicSmoothness("MetallicSmoothness", 2D) = "white" {}
		_Emission("Emission", 2D) = "black" {}
		_OpacityCliping("OpacityCliping", Range( 0 , 10)) = 1
		_EmissionMultiply("Emission Multiply", Range( 1 , 100)) = 1
		_SmoothAmount("SmoothAmount", Range( 0 , 1)) = 0
		_MetallicAmount("MetallicAmount", Range( 0 , 1)) = 0
		_AlbedoColor("Albedo Color", Color) = (1,1,1,0)

		_FrostEffectParams("Frost Effect Params",Vector) = (0,0,0,0)

		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }

		Cull Off
		CGPROGRAM

		#pragma target 3.0
		#pragma surface surf Standard vertex:vert keepalpha addshadow fullforwardshadows noshadow 

		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _AlbedoColor;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _EmissionMultiply;
		uniform float _DissolveAmount;
		uniform sampler2D _DisolveGuide;
		uniform float4 _DisolveGuide_ST;
		uniform sampler2D _BurnRamp;
		uniform sampler2D _MetallicSmoothness;
		uniform float4 _MetallicSmoothness_ST;
		uniform float _SmoothAmount;
		uniform float _MetallicAmount;
		uniform float _OpacityCliping;
		uniform float _Cutoff = 0.5;

		uniform float4 _FrostEffectParams;

		void vert(inout appdata_full v) {

			//Frost effect vertex displacement
			v.vertex.xyz += v.normal * (_FrostEffectParams.w * 0.05);

		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			//Frost effect
			//Parallax offset
			float2 parallaxOffset = ParallaxOffset(1.0f, -(_FrostEffectParams.w * 0.05), i.viewDir);
			i.uv_texcoord += parallaxOffset;

			float rim = smoothstep(_FrostEffectParams.x, _FrostEffectParams.y,saturate(dot(i.viewDir,o.Normal)));
			_AlbedoColor *= rim;

			//--------------------------------------------

			//Normal
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );

			//Albedo
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 albedo = tex2D( _Albedo, uv_Albedo );
			o.Albedo = (albedo * _AlbedoColor ).rgb;//--------------------------

			//Dissolve effect and emission
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float2 uv_DisolveGuide = i.uv_texcoord * _DisolveGuide_ST.xy + _DisolveGuide_ST.zw;

			float dissolve = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DisolveGuide, uv_DisolveGuide ).r );
			float clampDissolve = clamp( (-4.0 + (dissolve - 0.0) * (4.0 - -4.0) / (1.0 - 0.0)) , 0.0 , 1.0 );

			float2 dissolveUV = float2((1.0 - clampDissolve), 0.0);
			float4 burn = ((1.0 - clampDissolve) * tex2D( _BurnRamp, dissolveUV) );

			o.Emission = lerp((tex2D(_Emission, uv_Emission) * _EmissionMultiply), burn, burn).rgb;

			//Metallic smoothness
			float2 uv_MetallicSmoothness = i.uv_texcoord * _MetallicSmoothness_ST.xy + _MetallicSmoothness_ST.zw;
			float4 metallicTex = tex2D( _MetallicSmoothness, uv_MetallicSmoothness );
			o.Metallic = metallicTex.xyz;
			o.Smoothness = (metallicTex.a * _SmoothAmount ) * _MetallicAmount;

			//Alpha and clipping pixels from dissolve effect
			o.Alpha = 1;
			clip( ( (albedo.a * _OpacityCliping ) * dissolve) - _Cutoff );
		}

		ENDCG
	}

	Fallback "Diffuse"

}
