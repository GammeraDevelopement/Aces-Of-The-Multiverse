// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "UI/StandardFX"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

		[Space(16)][Header(Null Field)]
		_NullFieldTexture("Null Field Texture",2D) = "black" {}
		_NullFieldColor("Null Field Color", Color) = (1,1,1,1)

		[Space(16)][Header(Counter Machine)]
		_CounterMachineTexture("Counter Machine Texture",2D) = "black" {}
		_CounterMachineColor("Counter Machine Color", Color) = (1,1,1,1)

		[Space(16)][Header(Dissolve)]
		_NoiseDissolve("Noise Dissolve",2D) = "black" {}
		_DissolveParams("Noise Speed XY | Noise Scale Z | Burn Thickness W",Vector) = (1,1,1,1)
		_BWIntensity("BW Intensity",Range(0,1)) = 1
		_BurningLine1("Burning Line 1", Color) = (1,1,1,1)
		_BurningLine2("Burning Line 2", Color) = (1,1,1,1)


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

			sampler2D _NullFieldTexture;
			sampler2D _CounterMachineTexture;

			float4 _NullFieldColor;
			float4 _CounterMachineColor;

			uniform float _NullField;
			uniform float _CounterMachine;

			sampler2D _NoiseDissolve;
			float4 _DissolveParams;
			uniform float _DissolveAmount;
			float _BWIntensity;
			float4 _BurningLine1;
			float4 _BurningLine2;



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

				//-------------

				float lerpValue = (sin(_Time.y * 5) * 0.5 + 0.6);

				//NullField
				float4 nullFieldTex = tex2D(_NullFieldTexture, IN.texcoord);
				float4 nullFieldColor = lerp(_NullFieldColor,nullFieldTex,nullFieldTex.a);

				color.rgb = lerp(color.rgb, nullFieldColor.rgb, lerpValue * _NullField);

				//CounterMachine
				float4 counterMachineTex = tex2D(_CounterMachineTexture, IN.texcoord);
				float4 counterMachineColor = lerp(_CounterMachineColor,counterMachineTex, counterMachineTex.a);

				color.rgb = lerp(color.rgb, counterMachineColor.rgb , lerpValue * _CounterMachine);

				//Burned Card
				half noise1 = tex2D(_NoiseDissolve, (IN.texcoord - float2(_Time.y * _DissolveParams.x, _Time.y * _DissolveParams.y)) / _DissolveParams.z).rgb;
				half noise2 = tex2D(_NoiseDissolve, (IN.texcoord + float2(_Time.y * _DissolveParams.x, _Time.y * _DissolveParams.y)) / _DissolveParams.z).rgb;
			
				half noise = max(noise1,noise2);

				float3 dissolveLine1 = step(noise - (_DissolveParams.w * _DissolveAmount), _DissolveAmount);
				float3 dissolveLine2 = step(noise - ((_DissolveParams.w + 1.0) * _DissolveAmount), _DissolveAmount) - dissolveLine1;

				float3 NoDissolve = float3(1, 1, 1) - dissolveLine1 - dissolveLine2;
				half3 burningCard = lerp(color.rgb, (dissolveLine1 * _BurningLine1) + (dissolveLine2 * _BurningLine2), dissolveLine1 + dissolveLine2);

				float luminance = dot(color.rgb, float3(0.2126729, 0.7151522, 0.0721750)) * _BWIntensity;


				color.rgb = lerp(burningCard, float3(luminance, luminance, luminance),step(noise, _DissolveAmount));

				//-------------

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
