// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Interface"
{
	Properties
	{
		_opacity("opacity", 2D) = "white" {}
		[HDR]_BaseColor("BaseColor", Color) = (0.09414079,0.03937301,1.07432,0)
		_TileablePattern("TileablePattern", 2D) = "white" {}
		[HDR]_Frame("Frame", 2D) = "white" {}
		_fade("fade", Range( 0 , 1)) = 0
		_RotationSpeed("RotationSpeed", Float) = 0
		_ScrollSpeed("ScrollSpeed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _BaseColor;
		uniform sampler2D _Frame;
		uniform float _RotationSpeed;
		uniform sampler2D _TileablePattern;
		uniform float _ScrollSpeed;
		uniform sampler2D _opacity;
		uniform float _fade;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color36 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float cos68 = cos( ( _RotationSpeed * _Time.y ) );
			float sin68 = sin( ( _RotationSpeed * _Time.y ) );
			float2 rotator68 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos68 , -sin68 , sin68 , cos68 )) + float2( 0.5,0.5 );
			o.Albedo = ( _BaseColor * ( 1.0 - ( color36 * tex2D( _Frame, rotator68 ) ) ) ).rgb;
			float2 uv_TexCoord9 = i.uv_texcoord * float2( 1,3 );
			float2 panner11 = ( ( _ScrollSpeed * _Time.y ) * float2( 12,1 ) + uv_TexCoord9);
			o.Emission = ( ( _BaseColor + float4( 0.1603774,0.1565949,0.1565949,0 ) ) * tex2D( _TileablePattern, panner11 ) ).rgb;
			o.Alpha = ( tex2D( _opacity, rotator68 ) * _fade ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.5
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
7;26;1906;993;2200.896;286.2957;1;True;True
Node;AmplifyShaderEditor.TimeNode;10;-2375.052,-90.43626;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-1386.441,-29.02317;Float;False;Property;_RotationSpeed;RotationSpeed;5;0;Create;True;0;0;False;0;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-1399.762,-364.4134;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1220.898,42.91451;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;71;-1392.957,-219.7156;Float;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;74;-1645.052,113.52;Float;False;Property;_ScrollSpeed;ScrollSpeed;6;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;68;-895.2258,-21.11321;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;34;-549.2114,-210.078;Float;True;Property;_Frame;Frame;3;1;[HDR];Create;True;0;0;False;0;None;891be01acd1d0b149a437fba0879d847;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1450.159,246.1791;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-543.2991,-534.0247;Float;False;Constant;_Color1;Color 1;6;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1796.528,393.6884;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-131.0845,-195.4521;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;5;-132.5541,-571.7924;Float;False;Property;_BaseColor;BaseColor;1;1;[HDR];Create;True;0;0;False;0;0.09414079,0.03937301,1.07432,0;0.7490196,0.7490196,0.7490196,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;11;-1202.846,427.6886;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;12,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;342.8103,-498.6046;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.1603774,0.1565949,0.1565949,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;16;-833.9827,399.0046;Float;True;Property;_TileablePattern;TileablePattern;2;0;Create;True;0;0;False;0;81160735627cbf845bc7f7380894ad76;81160735627cbf845bc7f7380894ad76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-63.86782,385.6464;Float;True;Property;_opacity;opacity;0;0;Create;True;0;0;False;0;None;64b71f8f75e41a849812001f97e335e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;62;109.1124,-193.5529;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;67;342.9141,532.3223;Float;False;Property;_fade;fade;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;677.954,408.9622;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;706.1741,115.8291;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;503.9162,-131.2911;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;964.8569,68.69679;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;Interface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;70;0;69;0
WireConnection;70;1;10;2
WireConnection;68;0;72;0
WireConnection;68;1;71;0
WireConnection;68;2;70;0
WireConnection;34;1;68;0
WireConnection;73;0;74;0
WireConnection;73;1;10;2
WireConnection;37;0;36;0
WireConnection;37;1;34;0
WireConnection;11;0;9;0
WireConnection;11;1;73;0
WireConnection;65;0;5;0
WireConnection;16;1;11;0
WireConnection;4;1;68;0
WireConnection;62;0;37;0
WireConnection;66;0;4;0
WireConnection;66;1;67;0
WireConnection;17;0;65;0
WireConnection;17;1;16;0
WireConnection;63;0;5;0
WireConnection;63;1;62;0
WireConnection;2;0;63;0
WireConnection;2;2;17;0
WireConnection;2;9;66;0
ASEEND*/
//CHKSM=3414FCCCA36E3A78EDF00A068D436B2BCE757EF4