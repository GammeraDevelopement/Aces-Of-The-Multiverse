// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0.5287213,fgcg:0.5081099,fgcb:0.5441177,fgca:1,fgde:0.02,fgrn:42.2,fgrf:148.01,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:33533,y:32758,varname:node_4795,prsc:2|emission-2393-OUT,alpha-2374-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:33152,y:32659,varname:node_2393,prsc:2|A-4604-OUT,B-2053-RGB,C-797-RGB,D-9248-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:31800,y:32870,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:31800,y:33028,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Vector1,id:9248,x:31800,y:33179,varname:node_9248,prsc:2,v1:2;n:type:ShaderForge.SFN_Vector4Property,id:3787,x:31594,y:32713,ptovrint:False,ptlb:Pos,ptin:_Pos,varname:node_3787,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0,v2:0,v3:0,v4:0;n:type:ShaderForge.SFN_Tex2d,id:5648,x:30646,y:31998,ptovrint:False,ptlb:Noise,ptin:_Noise,varname:node_5648,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c77972954eed1814a942bbdcf86b0839,ntxv:0,isnm:False|UVIN-8406-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:9178,x:30079,y:31950,varname:node_9178,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:5278,x:30288,y:31958,varname:node_5278,prsc:2|A-9178-UVOUT,B-743-OUT;n:type:ShaderForge.SFN_ValueProperty,id:743,x:30106,y:32242,ptovrint:False,ptlb:Scale,ptin:_Scale,varname:node_743,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:5;n:type:ShaderForge.SFN_Panner,id:8406,x:30480,y:31953,varname:node_8406,prsc:2,spu:0,spv:0.2|UVIN-5278-OUT;n:type:ShaderForge.SFN_Power,id:8928,x:31033,y:32051,varname:node_8928,prsc:2|VAL-5648-R,EXP-2045-OUT;n:type:ShaderForge.SFN_Vector1,id:2045,x:30863,y:32208,varname:node_2045,prsc:2,v1:4;n:type:ShaderForge.SFN_Multiply,id:1162,x:31415,y:32170,varname:node_1162,prsc:2|A-8928-OUT,B-6628-OUT;n:type:ShaderForge.SFN_Vector1,id:6628,x:31213,y:32255,varname:node_6628,prsc:2,v1:3;n:type:ShaderForge.SFN_ValueProperty,id:6500,x:32610,y:33072,ptovrint:False,ptlb:Opacity,ptin:_Opacity,varname:node_6500,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Add,id:2648,x:31776,y:32213,varname:node_2648,prsc:2|A-1162-OUT,B-8221-OUT;n:type:ShaderForge.SFN_DepthBlend,id:4864,x:31247,y:32452,varname:node_4864,prsc:2|DIST-4693-OUT;n:type:ShaderForge.SFN_Vector1,id:4693,x:31082,y:32452,varname:node_4693,prsc:2,v1:1;n:type:ShaderForge.SFN_Clamp01,id:7887,x:31966,y:32213,varname:node_7887,prsc:2|IN-2648-OUT;n:type:ShaderForge.SFN_OneMinus,id:6503,x:31445,y:32452,varname:node_6503,prsc:2|IN-4864-OUT;n:type:ShaderForge.SFN_Multiply,id:4604,x:32287,y:32235,varname:node_4604,prsc:2|A-7887-OUT,B-7012-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:1271,x:31594,y:32555,varname:node_1271,prsc:2;n:type:ShaderForge.SFN_Distance,id:7710,x:31846,y:32627,varname:node_7710,prsc:2|A-1271-XYZ,B-3787-XYZ;n:type:ShaderForge.SFN_Multiply,id:5527,x:32473,y:32585,varname:node_5527,prsc:2|A-2651-OUT,B-2705-OUT;n:type:ShaderForge.SFN_Vector1,id:2705,x:32148,y:32790,varname:node_2705,prsc:2,v1:0.1;n:type:ShaderForge.SFN_OneMinus,id:2651,x:32257,y:32532,varname:node_2651,prsc:2|IN-9520-OUT;n:type:ShaderForge.SFN_Clamp01,id:8215,x:32710,y:32604,varname:node_8215,prsc:2|IN-5527-OUT;n:type:ShaderForge.SFN_Multiply,id:2374,x:32947,y:32969,varname:node_2374,prsc:2|A-8215-OUT,B-7887-OUT,C-6500-OUT;n:type:ShaderForge.SFN_Add,id:9520,x:32060,y:32580,varname:node_9520,prsc:2|A-7710-OUT,B-1531-OUT;n:type:ShaderForge.SFN_Vector1,id:1531,x:31901,y:32790,varname:node_1531,prsc:2,v1:-5;n:type:ShaderForge.SFN_ValueProperty,id:7012,x:32003,y:32460,ptovrint:False,ptlb:Intensity,ptin:_Intensity,varname:node_7012,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:3;n:type:ShaderForge.SFN_Multiply,id:8221,x:31638,y:32399,varname:node_8221,prsc:2|A-3944-OUT,B-6503-OUT;n:type:ShaderForge.SFN_Vector1,id:3944,x:31465,y:32382,varname:node_3944,prsc:2,v1:0.5;proporder:797-3787-5648-743-6500-7012;pass:END;sub:END;*/

Shader "Shader Forge/ExternalGrid" {
    Properties {
        _TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _Pos ("Pos", Vector) = (0,0,0,0)
        _Noise ("Noise", 2D) = "white" {}
        _Scale ("Scale", Float ) = 5
        _Opacity ("Opacity", Float ) = 0.5
        _Intensity ("Intensity", Float ) = 3
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles ps4 
            #pragma target 3.0
            uniform sampler2D _CameraDepthTexture;
            uniform float4 _TintColor;
            uniform float4 _Pos;
            uniform sampler2D _Noise; uniform float4 _Noise_ST;
            uniform float _Scale;
            uniform float _Opacity;
            uniform float _Intensity;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float4 vertexColor : COLOR;
                float4 projPos : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
////// Lighting:
////// Emissive:
                float4 node_8495 = _Time;
                float2 node_8406 = ((i.uv0*_Scale)+node_8495.g*float2(0,0.2));
                float4 _Noise_var = tex2D(_Noise,TRANSFORM_TEX(node_8406, _Noise));
                float node_7887 = saturate(((pow(_Noise_var.r,4.0)*3.0)+(0.5*(1.0 - saturate((sceneZ-partZ)/1.0)))));
                float3 emissive = ((node_7887*_Intensity)*i.vertexColor.rgb*_TintColor.rgb*2.0);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,(saturate(((1.0 - (distance(i.posWorld.rgb,_Pos.rgb)+(-5.0)))*0.1))*node_7887*_Opacity));
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0.5287213,0.5081099,0.5441177,1));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
