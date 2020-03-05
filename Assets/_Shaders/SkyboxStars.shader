// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Gammera/Skybox/Stars" {
	Properties{

		_Tint("Tint Color", Color) = (.5, .5, .5, .5)
		_Params("Params",Vector) = (0,0,0,0)
		[Gamma] _Exposure ("Exposure", Range(0, 8)) = 1.0

	}

SubShader {
    Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
    Cull Off ZWrite Off

    Pass {

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma target 2.0

        #include "UnityCG.cginc"

        half4 _Tint;
        half4 _Params;
        half _Exposure;

		float easeIn(float interpolator) {
			return interpolator * interpolator;
		}
		float easeOut(float interpolator) {
			return 1 - easeIn(1 - interpolator);
		}
		float easeInOut(float interpolator) {
			float easeInValue = easeIn(interpolator);
			float easeOutValue = easeOut(interpolator);
			return lerp(easeInValue, easeOutValue, interpolator);
		}

		float rand2dTo1d(float2 value, float2 dotDir = float2(12.9898, 78.233)) {
			float2 smallValue = sin(value);
			float random = dot(smallValue, dotDir);
			random = frac(sin(random) * 143758.5453);
			return random;
		}

		float ValueNoise2d(float2 value) {
			float upperLeftCell = rand2dTo1d(float2(floor(value.x), ceil(value.y)));
			float upperRightCell = rand2dTo1d(float2(ceil(value.x), ceil(value.y)));
			float lowerLeftCell = rand2dTo1d(float2(floor(value.x), floor(value.y)));
			float lowerRightCell = rand2dTo1d(float2(ceil(value.x), floor(value.y)));

			float interpolatorX = easeInOut(frac(value.x));
			float interpolatorY = easeInOut(frac(value.y));

			float upperCells = lerp(upperLeftCell, upperRightCell, interpolatorX);
			float lowerCells = lerp(lowerLeftCell, lowerRightCell, interpolatorX);

			float noise = lerp(lowerCells, upperCells, interpolatorY);
			return noise;
		}
        struct appdata_t {
            float4 vertex : POSITION;
            UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        struct v2f {
            float4 vertex : SV_POSITION;
            float3 texcoord : TEXCOORD0;
            UNITY_VERTEX_OUTPUT_STEREO
        };

        v2f vert (appdata_t v)
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.texcoord = v.vertex.xyz;
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
			half noise = 1 - step(_Params.x,ValueNoise2d((i.texcoord * _Params.y) + (_Params.zw * _Time.y)));
			
            half3 c = noise * _Tint.rgb * unity_ColorSpaceDouble.rgb;
            c *= _Exposure;
            return half4(c, 1);
        }
        ENDCG
    }
}


Fallback Off

}
