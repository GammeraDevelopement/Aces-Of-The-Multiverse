// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Glass"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_Emission("Emission", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_Fresnel("Fresnel", Range( 0 , 10)) = 5.321785
		[HDR]_FresnelColor("FresnelColor", Color) = (0.2946687,2.084509,1.069538,1)
		_Border("Border", Range( 0 , 10)) = 7.057663
		[HDR]_BorderColor("BorderColor", Color) = (1.801096,1.958267,2.670157,1)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform float4 _FresnelColor;
		uniform float _Fresnel;
		uniform float4 _BorderColor;
		uniform float _Border;
		uniform float4 _EmissionColor;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _DissolveAmount;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV8 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode8 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV8, _Fresnel ) );
			float fresnelNdotV38 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode38 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV38, _Border ) );
			float4 temp_output_39_0 = ( ( _FresnelColor * fresnelNode8 ) + pow( ( _BorderColor * fresnelNode38 ) , 4.0 ) );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 temp_output_62_0 = ( _EmissionColor * tex2D( _Emission, uv_Emission ) );
			float grayscale60 = dot(temp_output_62_0.rgb, float3(0.299,0.587,0.114));
			float4 lerpResult59 = lerp( temp_output_39_0 , temp_output_62_0 , grayscale60);
			o.Emission = lerpResult59.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			float4 temp_cast_3 = (grayscale60).xxxx;
			float4 lerpResult66 = lerp( ( _Color.a + temp_output_39_0 ) , temp_cast_3 , grayscale60);
			o.Alpha = ( saturate( lerpResult66 ) * ( 1.0 - _DissolveAmount ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
-11;121;1352;537;2245.481;1240.403;2.804987;True;True
Node;AmplifyShaderEditor.RangedFloatNode;35;-2295.635,-89.98505;Float;False;Property;_Border;Border;5;0;Create;True;0;0;False;0;7.057663;2.4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1990.494,-560.4827;Float;False;Property;_Fresnel;Fresnel;3;0;Create;True;0;0;False;0;5.321785;1.1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;38;-1983.979,-183.6085;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-2001.317,-376.1823;Float;False;Property;_BorderColor;BorderColor;6;1;[HDR];Create;True;0;0;False;0;1.801096,1.958267,2.670157,1;1.414669,1.783196,2.270603,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-1687.239,-857.1992;Float;False;Property;_FresnelColor;FresnelColor;4;1;[HDR];Create;True;0;0;False;0;0.2946687,2.084509,1.069538,1;0.2380289,1.862835,1.976675,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1707.097,-272.7871;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;8;-1682.584,-654.9291;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;-1203.821,-947.4489;Float;True;Property;_Emission;Emission;1;0;Create;True;0;0;False;0;None;8de8e22f7a7bd4442994c4abcb489b97;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;61;-1158.503,-1128.387;Float;False;Property;_EmissionColor;EmissionColor;2;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.608238,2.608238,2.608238,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1394.628,-738.6572;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;45;-1490.83,-231.0968;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-859.6035,-964.3887;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;46;-1154.837,-676.3275;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0,0,0,0;0.6792453,0.509434,0.509434,0.007843138;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1129.806,-400.6165;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-543.7336,-315.7014;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;60;-651.5923,-435.3925;Float;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-479.6289,-141.9701;Float;False;Property;_DissolveAmount;Dissolve Amount;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;66;-360.2075,-376.0068;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;64;-170.427,-232.4823;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;52;-178.448,-151.6371;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-166.7043,49.05697;Float;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-164.1042,-23.74306;Float;False;Property;_Metallic;Metallic;7;0;Create;True;0;0;False;0;0;0.03482628;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;2.555192,-221.5364;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;59;-335.4584,-559.0516;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;173.0001,-420.5001;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Glass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;10;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;3;35;0
WireConnection;37;0;36;0
WireConnection;37;1;38;0
WireConnection;8;3;5;0
WireConnection;18;0;9;0
WireConnection;18;1;8;0
WireConnection;45;0;37;0
WireConnection;62;0;61;0
WireConnection;62;1;56;0
WireConnection;39;0;18;0
WireConnection;39;1;45;0
WireConnection;47;0;46;4
WireConnection;47;1;39;0
WireConnection;60;0;62;0
WireConnection;66;0;47;0
WireConnection;66;1;60;0
WireConnection;66;2;60;0
WireConnection;64;0;66;0
WireConnection;52;0;51;0
WireConnection;65;0;64;0
WireConnection;65;1;52;0
WireConnection;59;0;39;0
WireConnection;59;1;62;0
WireConnection;59;2;60;0
WireConnection;0;0;46;0
WireConnection;0;2;59;0
WireConnection;0;3;48;0
WireConnection;0;4;49;0
WireConnection;0;9;65;0
ASEEND*/
//CHKSM=0BBBCDEAE9EBF6EE607772664F21E329F90C1753