// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Gammera/UI/WaveVerticalFill"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

		[Space(16)][Header(Wave Fill)]
		_EffectTexture("Wave Fill Texture",2D) = "black" {}
		_EffectTextureColor("Wave Fill Icon Color",Color) = (0.5,0.5,0.5,1)
		
		_EffectFill("Wave Fill Amount", Range(0,1)) = 0
		_EffectFillSmooth("Wave Fill Smooth", Range(0.001,0.5)) = 0
		_EffectFillEdge("Wave Fill Edge", Range(0.0001,0.5)) = 0
		_EffectFillEdgeColor("Wave Fill Edge Color", Color) = (1,1,1,1)

		_WaveParams("X : Wave Speed | Y : Wave Amplitude | Z : Wave Frecuenty", Vector) = (0,0,0,0)

        [HideInInspector]_StencilComp ("Stencil Comparison", Float) = 8
		[HideInInspector]_Stencil ("Stencil ID", Float) = 0
		[HideInInspector]_StencilOp ("Stencil Operation", Float) = 0
		[HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
		[HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255

		[HideInInspector]_ColorMask ("Color Mask", Float) = 15

		[Space(16)]
        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            Name "Default"
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

			sampler2D _MainTex;
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
			float4 _ClipRect;
			float4 _MainTex_ST;

			sampler2D _EffectTexture;

			float4 _EffectTextureColor;
			float4 _EffectFillEdgeColor;

			float _EffectFill;
			float _EffectFillSmooth;
			float _EffectFillEdge;
			float4 _WaveParams;


            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata_t v)
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                OUT.worldPosition = v.vertex;
                OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

                OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;

				//effect
				float4 effectTex = tex2D(_EffectTexture, IN.texcoord) * _EffectTextureColor;
				color.rgb = lerp(color.rgb, effectTex.rgb, effectTex.a);

				float effectSin = sin(IN.texcoord.x * _WaveParams.z + _Time.y * _WaveParams.x) * _WaveParams.y;

				float effectFill = smoothstep(_EffectFill + _EffectFillSmooth, _EffectFill, IN.texcoord.y + effectSin);

				float effectFillEdge = 1 - smoothstep(_EffectFill + _EffectFillSmooth, _EffectFill, (_EffectFillEdge + IN.texcoord.y) + effectSin) * effectFill;
				
				color.rgb = (color.rgb * (1 - effectFillEdge)) + (_EffectFillEdgeColor * effectFillEdge);

				color.a *= effectFill;
				//-----

				#ifdef UNITY_UI_CLIP_RECT
				color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
				#endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                return color;
            }
        ENDCG
        }
	}
}
