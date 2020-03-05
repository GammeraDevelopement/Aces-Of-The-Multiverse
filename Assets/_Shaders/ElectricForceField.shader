// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ElectricForceField"
{
	Properties
	{
		_MainPattern("MainPattern", 2D) = "white" {}
		_FlipbookSpeedVertical("FlipbookSpeed Vertical", Float) = 0
		_FlipbookScaleY("Flipbook Scale Y", Float) = 0
		_FlipbookScaleX("Flipbook Scale X", Float) = 0
		_PatternSpeedX("Pattern Speed X", Range( 0 , 0.5)) = 0
		_PatternSpeedY("Pattern Speed Y", Range( 0 , 0.5)) = 0
		[HDR]_SecondRayColor("SecondRayColor", Color) = (0,0,0,0)
		[HDR]_FlipbookColor("FlipbookColor", Color) = (0,0,0,0)
		_FlipbookSpeed("FlipbookSpeed", Float) = 0
		_SecondRaySpeed("SecondRaySpeed", Float) = 0
		_FlipbookTexture("Flipbook Texture", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_PatternScaleX("PatternScaleX", Range( 0 , 2)) = 0
		_PatternScaleY("PatternScaleY", Range( 0 , 2)) = 0
		_BorderMask("Border Mask ", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_NoiseSpeed("Noise Speed", Range( 0 , 0.5)) = 0
		[HDR]_MainColor("MainColor", Color) = (0,0,0,0)
		_PatternOpacity("Pattern Opacity", Range( 0 , 1)) = 0
		_NoiseOpacity("Noise Opacity", Range( 0 , 1)) = 0
		_SecondRayOffset("SecondRayOffset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainPattern;
		uniform float _PatternScaleX;
		uniform float _PatternScaleY;
		uniform float _PatternSpeedX;
		uniform float _PatternSpeedY;
		uniform float _PatternOpacity;
		uniform sampler2D _BorderMask;
		uniform float4 _BorderMask_ST;
		uniform sampler2D _TextureSample2;
		uniform float _NoiseSpeed;
		uniform float _NoiseOpacity;
		uniform float4 _MainColor;
		uniform sampler2D _FlipbookTexture;
		uniform float _FlipbookScaleX;
		uniform float _FlipbookScaleY;
		uniform float _FlipbookSpeedVertical;
		uniform float _FlipbookSpeed;
		uniform float4 _FlipbookColor;
		uniform sampler2D _TextureSample0;
		uniform float _SecondRayOffset;
		uniform float _SecondRaySpeed;
		uniform float4 _SecondRayColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 appendResult13 = (float4(_PatternScaleX , _PatternScaleY , 0.0 , 0.0));
			float4 appendResult6 = (float4(( _PatternSpeedX * _Time.y ) , ( _Time.y * _PatternSpeedY ) , 0.0 , 0.0));
			float2 uv_TexCoord5 = i.uv_texcoord * appendResult13.xy + appendResult6.xy;
			float2 uv_BorderMask = i.uv_texcoord * _BorderMask_ST.xy + _BorderMask_ST.zw;
			float2 temp_cast_2 = (( _Time.y * _NoiseSpeed )).xx;
			float2 uv_TexCoord24 = i.uv_texcoord + temp_cast_2;
			float4 temp_output_25_0 = ( ( ( tex2D( _MainPattern, uv_TexCoord5 ) * _PatternOpacity ) * ( 1.0 - tex2D( _BorderMask, uv_BorderMask ).a ) ) * ( tex2D( _TextureSample2, uv_TexCoord24 ) * _NoiseOpacity ) );
			float4 appendResult28 = (float4(_FlipbookScaleX , _FlipbookScaleY , 0.0 , 0.0));
			float4 appendResult29 = (float4(0.0 , ( _FlipbookSpeedVertical * _Time.y ) , 0.0 , 0.0));
			float2 uv_TexCoord31 = i.uv_texcoord * appendResult28.xy + appendResult29.xy;
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles34 = 3.0 * 3.0;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset34 = 1.0f / 3.0;
			float fbrowsoffset34 = 1.0f / 3.0;
			// Speed of animation
			float fbspeed34 = _Time[ 1 ] * _FlipbookSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling34 = float2(fbcolsoffset34, fbrowsoffset34);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex34 = round( fmod( fbspeed34 + 0.0, fbtotaltiles34) );
			fbcurrenttileindex34 += ( fbcurrenttileindex34 < 0) ? fbtotaltiles34 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox34 = round ( fmod ( fbcurrenttileindex34, 3.0 ) );
			// Multiply Offset X by coloffset
			float fboffsetx34 = fblinearindextox34 * fbcolsoffset34;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy34 = round( fmod( ( fbcurrenttileindex34 - fblinearindextox34 ) / 3.0, 3.0 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy34 = (int)(3.0-1) - fblinearindextoy34;
			// Multiply Offset Y by rowoffset
			float fboffsety34 = fblinearindextoy34 * fbrowsoffset34;
			// UV Offset
			float2 fboffset34 = float2(fboffsetx34, fboffsety34);
			// Flipbook UV
			half2 fbuv34 = uv_TexCoord31 * fbtiling34 + fboffset34;
			// *** END Flipbook UV Animation vars ***
			float4 appendResult60 = (float4(_FlipbookScaleX , _FlipbookScaleY , 0.0 , 0.0));
			float4 appendResult61 = (float4(0.0 , ( ( _FlipbookSpeedVertical * _Time.y ) + _SecondRayOffset ) , 0.0 , 0.0));
			float2 uv_TexCoord64 = i.uv_texcoord * appendResult60.xy + appendResult61.xy;
			float fbtotaltiles66 = 3.0 * 3.0;
			float fbcolsoffset66 = 1.0f / 3.0;
			float fbrowsoffset66 = 1.0f / 3.0;
			float fbspeed66 = _Time[ 1 ] * _SecondRaySpeed;
			float2 fbtiling66 = float2(fbcolsoffset66, fbrowsoffset66);
			float fbcurrenttileindex66 = round( fmod( fbspeed66 + 0.0, fbtotaltiles66) );
			fbcurrenttileindex66 += ( fbcurrenttileindex66 < 0) ? fbtotaltiles66 : 0;
			float fblinearindextox66 = round ( fmod ( fbcurrenttileindex66, 3.0 ) );
			float fboffsetx66 = fblinearindextox66 * fbcolsoffset66;
			float fblinearindextoy66 = round( fmod( ( fbcurrenttileindex66 - fblinearindextox66 ) / 3.0, 3.0 ) );
			fblinearindextoy66 = (int)(3.0-1) - fblinearindextoy66;
			float fboffsety66 = fblinearindextoy66 * fbrowsoffset66;
			float2 fboffset66 = float2(fboffsetx66, fboffsety66);
			half2 fbuv66 = uv_TexCoord64 * fbtiling66 + fboffset66;
			o.Emission = ( ( temp_output_25_0 * _MainColor ) + ( ( tex2D( _FlipbookTexture, fbuv34 ).a * _FlipbookColor ) + ( tex2D( _TextureSample0, fbuv66 ).a * _SecondRayColor ) ) ).rgb;
			o.Alpha = temp_output_25_0.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
831.2;73.6;703;712;2720.548;-978.3191;1.813248;True;False
Node;AmplifyShaderEditor.TimeNode;7;-2982.328,-165.767;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-2991.64,-308.4215;Float;False;Property;_PatternSpeedX;Pattern Speed X;4;0;Create;True;0;0;False;0;0;0.085;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3010.006,15.59692;Float;False;Property;_PatternSpeedY;Pattern Speed Y;5;0;Create;True;0;0;False;0;0;0.03;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;38;-3035.866,1319.639;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-2998.765,1195.239;Float;False;Property;_FlipbookSpeedVertical;FlipbookSpeed Vertical;1;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2719.056,1904.546;Float;False;Property;_SecondRayOffset;SecondRayOffset;20;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2668.037,1723.17;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2985.762,-443.5819;Float;False;Property;_PatternScaleY;PatternScaleY;13;0;Create;True;0;0;False;0;0;0.47;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-2716.324,-120.3517;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2991.726,-576.2073;Float;False;Property;_PatternScaleX;PatternScaleX;12;0;Create;True;0;0;False;0;0;0.77;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2716.323,-224.1581;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-2547.859,1813.347;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2883.966,1052.239;Float;False;Constant;_Float5;Float 5;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2882.096,812.6909;Float;False;Property;_FlipbookScaleX;Flipbook Scale X;3;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2886.936,923.2783;Float;False;Property;_FlipbookScaleY;Flipbook Scale Y;2;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2696.665,1236.439;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-2541.152,-198.2064;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TimeNode;21;-2439.626,444.6169;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;13;-2634.944,-528.2098;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2459.691,661.6373;Float;False;Property;_NoiseSpeed;Noise Speed;16;0;Create;True;0;0;False;0;0;0.202;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-2456.221,1639.949;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-2515.42,1435.218;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-2531.248,953.2867;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-2472.049,1158.018;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2172.781,546.0197;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-2337.664,-278.1831;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-2147.453,1757.889;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-2156.561,1554.895;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2107.573,-224.5303;Float;True;Property;_MainPattern;MainPattern;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-2035.207,510.9117;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;-2162.453,1685.889;Float;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2178.281,1203.958;Float;False;Constant;_Float11;Float 11;2;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2177.281,1358.958;Float;False;Property;_FlipbookSpeed;FlipbookSpeed;8;0;Create;True;0;0;False;0;0;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2172.389,1072.964;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-2163.281,1275.958;Float;False;Constant;_Float9;Float 9;0;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2161.453,1840.889;Float;False;Property;_SecondRaySpeed;SecondRaySpeed;9;0;Create;True;0;0;False;0;0;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2009.303,23.92015;Float;False;Property;_PatternOpacity;Pattern Opacity;18;0;Create;True;0;0;False;0;0;0.652;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-2171.623,158.1629;Float;True;Property;_BorderMask;Border Mask ;14;0;Create;True;0;0;False;0;None;2494c5aee9f88994884c6793bb0f0c93;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;66;-1805.523,1553.68;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;18;-1796.851,182.1305;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;34;-1821.35,1071.749;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;20;-1790.923,560.4471;Float;True;Property;_TextureSample2;Texture Sample 2;15;0;Create;True;0;0;False;0;None;4e883de1b8c3c3a439df23a099862311;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-1664.296,783.663;Float;False;Property;_NoiseOpacity;Noise Opacity;19;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1693.772,15.05841;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;67;-1436.518,1772.796;Float;False;Property;_SecondRayColor;SecondRayColor;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,28.06393,63.99999,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-1441.733,1017.519;Float;True;Property;_FlipbookTexture;Flipbook Texture;10;0;Create;True;0;0;False;0;None;4a85390cc6ee62c4aa37860b2a8fe81a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1335.036,581.6625;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;35;-1452.345,1290.865;Float;False;Property;_FlipbookColor;FlipbookColor;7;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,28.06393,63.99999,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;68;-1425.906,1499.45;Float;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;False;0;None;4a85390cc6ee62c4aa37860b2a8fe81a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1488.432,173.5396;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1081.763,1149.109;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1065.936,1631.04;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1124.389,336.9678;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;26;-1133.328,560.7608;Float;False;Property;_MainColor;MainColor;17;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,3.523293,2.187873,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-880.1926,460.4349;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-769.2068,1510.992;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-777.1283,906.2784;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;53;-772.4893,320.3766;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;15;-537.1497,792.9457;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;ElectricForceField;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;0;37;0
WireConnection;59;1;38;2
WireConnection;8;0;7;2
WireConnection;8;1;4;0
WireConnection;9;0;3;0
WireConnection;9;1;7;2
WireConnection;70;0;59;0
WireConnection;70;1;71;0
WireConnection;39;0;37;0
WireConnection;39;1;38;2
WireConnection;6;0;9;0
WireConnection;6;1;8;0
WireConnection;13;0;10;0
WireConnection;13;1;11;0
WireConnection;61;0;40;0
WireConnection;61;1;70;0
WireConnection;60;0;41;0
WireConnection;60;1;42;0
WireConnection;28;0;41;0
WireConnection;28;1;42;0
WireConnection;29;0;40;0
WireConnection;29;1;39;0
WireConnection;22;0;21;2
WireConnection;22;1;23;0
WireConnection;5;0;13;0
WireConnection;5;1;6;0
WireConnection;64;0;60;0
WireConnection;64;1;61;0
WireConnection;1;1;5;0
WireConnection;24;1;22;0
WireConnection;31;0;28;0
WireConnection;31;1;29;0
WireConnection;66;0;64;0
WireConnection;66;1;65;0
WireConnection;66;2;63;0
WireConnection;66;3;62;0
WireConnection;18;0;16;4
WireConnection;34;0;31;0
WireConnection;34;1;33;0
WireConnection;34;2;30;0
WireConnection;34;3;32;0
WireConnection;20;1;24;0
WireConnection;51;0;1;0
WireConnection;51;1;50;0
WireConnection;36;1;34;0
WireConnection;54;0;20;0
WireConnection;54;1;56;0
WireConnection;68;1;66;0
WireConnection;19;0;51;0
WireConnection;19;1;18;0
WireConnection;43;0;36;4
WireConnection;43;1;35;0
WireConnection;69;0;68;4
WireConnection;69;1;67;0
WireConnection;25;0;19;0
WireConnection;25;1;54;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;58;0;43;0
WireConnection;58;1;69;0
WireConnection;48;0;27;0
WireConnection;48;1;58;0
WireConnection;53;0;25;0
WireConnection;15;2;48;0
WireConnection;15;9;53;0
ASEEND*/
//CHKSM=AB1561F2277461B5BC996E5AE60D8FBABB421B7B