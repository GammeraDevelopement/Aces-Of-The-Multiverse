// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Wheels"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Speed("Speed", Range( 0 , 2)) = 1.785457
		_Noise("Noise", Range( 0 , 1)) = 1
		_DisolveGuide("Disolve Guide", 2D) = "white" {}
		_Metalness("Metalness", 2D) = "white" {}
		_BurnRamp("Burn Ramp", 2D) = "white" {}
		_Smoothness("Smoothness", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_Color0("Color 0", Color) = (0.4056604,0.4056604,0.4056604,0)
		[Normal]_Normal("Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float _Speed;
		uniform float _Noise;
		uniform sampler2D _TextureSample0;
		uniform float4 _Color0;
		uniform float _DissolveAmount;
		uniform sampler2D _DisolveGuide;
		uniform float4 _DisolveGuide_ST;
		uniform sampler2D _BurnRamp;
		uniform sampler2D _Metalness;
		uniform sampler2D _Smoothness;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Noise).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_0;
			float2 panner5 = ( ( _Time.y * _Speed ) * float2( 0,1 ) + uv_TexCoord4);
			o.Normal = UnpackNormal( tex2D( _Normal, panner5 ) );
			float4 lerpResult29 = lerp( tex2D( _TextureSample0, panner5 ) , _Color0 , _Color0);
			o.Albedo = lerpResult29.rgb;
			float2 uv_DisolveGuide = i.uv_texcoord * _DisolveGuide_ST.xy + _DisolveGuide_ST.zw;
			float temp_output_33_0 = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DisolveGuide, uv_DisolveGuide ).r );
			float clampResult40 = clamp( (-4.0 + (temp_output_33_0 - 0.0) * (4.0 - -4.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_41_0 = ( 1.0 - clampResult40 );
			float2 appendResult42 = (float2(temp_output_41_0 , 0.0));
			o.Emission = ( temp_output_41_0 * tex2D( _BurnRamp, appendResult42 ) ).rgb;
			o.Metallic = tex2D( _Metalness, panner5 ).r;
			o.Smoothness = tex2D( _Smoothness, panner5 ).r;
			o.Alpha = 1;
			clip( temp_output_33_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
7;1;1352;699;1223.747;517.7894;1.940585;True;True
Node;AmplifyShaderEditor.CommentaryNode;31;-1430.344,838.0017;Float;False;908.2314;498.3652;Dissolve - Opacity Mask;5;38;37;36;35;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1382.014,910.2157;Float;False;Property;_DissolveAmount;Dissolve Amount;8;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;-1118.219,911.0616;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-1020.53,1126.867;Float;True;Property;_DisolveGuide;Disolve Guide;4;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;38;-989.4019,911.8462;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-782.6558,894.3481;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1355.904,377.0166;Float;False;814.5701;432.0292;Burn Effect - Emission;6;43;42;41;40;39;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;39;-1341.124,608.8145;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;40;-1260.606,418.2335;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1331.083,196.3515;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;1.785457;0.7;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1532.288,-581.6153;Float;False;Property;_Noise;Noise;3;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;3;-1338.985,-149.5953;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1104.288,-113.6152;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1230.446,-427.706;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;41;-1090.57,411.0211;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;5;-755.4641,-224.9077;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-1012.409,635.02;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;28;-440.5896,-204.897;Float;False;Property;_Color0;Color 0;9;0;Create;True;0;0;False;0;0.4056604,0.4056604,0.4056604,0;0.6603774,0.6603774,0.6603774,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-471.024,-407.8239;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;183a8100253f21545822bd8a201b3a43;183a8100253f21545822bd8a201b3a43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-885.1148,622.9312;Float;True;Property;_BurnRamp;Burn Ramp;6;0;Create;True;0;0;False;0;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-665.3346,453.6841;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-334.8129,190.4352;Float;True;Property;_Metalness;Metalness;5;0;Create;True;0;0;False;0;472f068c3b823c84fa1ac1735278a4a5;472f068c3b823c84fa1ac1735278a4a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;39.68467,-449.3071;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;30;-297.0201,-3.216027;Float;True;Property;_Normal;Normal;10;1;[Normal];Create;True;0;0;True;0;cf3aa8877b6810b44bf034ec0c89a296;cf3aa8877b6810b44bf034ec0c89a296;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-341.0936,405.8214;Float;True;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;09464aa95efcd1045b35f50f9706d845;09464aa95efcd1045b35f50f9706d845;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;435.5331,-138.7418;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Wheels;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;35;0
WireConnection;38;0;36;0
WireConnection;33;0;38;0
WireConnection;33;1;37;1
WireConnection;39;0;33;0
WireConnection;40;0;39;0
WireConnection;17;0;3;2
WireConnection;17;1;16;0
WireConnection;4;0;18;0
WireConnection;41;0;40;0
WireConnection;5;0;4;0
WireConnection;5;1;17;0
WireConnection;42;0;41;0
WireConnection;1;1;5;0
WireConnection;34;1;42;0
WireConnection;43;0;41;0
WireConnection;43;1;34;0
WireConnection;19;1;5;0
WireConnection;29;0;1;0
WireConnection;29;1;28;0
WireConnection;29;2;28;0
WireConnection;30;1;5;0
WireConnection;21;1;5;0
WireConnection;0;0;29;0
WireConnection;0;1;30;0
WireConnection;0;2;43;0
WireConnection;0;3;19;0
WireConnection;0;4;21;0
WireConnection;0;10;33;0
ASEEND*/
//CHKSM=B9D0C7A5A48167B44B8AA9D7F81353450C6C014D