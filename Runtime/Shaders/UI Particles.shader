// Made with Amplify Shader Editor v1.9.9.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI Particles"
{
    Properties
    {
        _Color ("Tint", Color) = (1,1,1,1)
         _MaxLifetime( "Max Lifetime", Float ) = 1
         _Whatever( "[f]Time", Float ) = 0
         [Toggle( _USECUSTOMTIME_ON )] _UseCustomTime( "Use Custom Time", Float ) = 0
         _CustomTImesiUSECUSTOMTIME_ON( "Custom TIme [si(USECUSTOMTIME_ON)]", Float ) = 0
         _fFlipbook( "[f] Flipbook", Float ) = 0
         [Toggle( _USEFLIPBOOK_ON )] _UseFlipbook( "Use Flipbook", Float ) = 0
         _FlipbbokSpeedsi_USEFLIPBOOK_ON( "Flipbbok Speed [si(_USEFLIPBOOK_ON)]", Float ) = 1
         [Toggle( _RANDOMSTARTFRAME_ON )] _RandomStartFrame( "Random Start Frame", Float ) = 0
         _FlipbookCellssi_USEFLIPBOOK_ON( "Flipbook Cells [si(_USEFLIPBOOK_ON)]", Vector ) = ( 1, 1, 0, 0 )
         _fColorLifetime( "[f] Color Lifetime", Float ) = 0
         [KeywordEnum( No,Yes )] _UseGradient( "UseGradient", Float ) = 0
         _StartColorsi_USEGRADIENTNo( "Start Color [si(_USEGRADIENT=No)]", Color ) = ( 0, 0, 0, 0 )
         _EndColorsi_USEGRADIENTNo( "End Color [si(_USEGRADIENT=No)]", Color ) = ( 1, 1, 1, 1 )
         _gColoroverLifetimesi_USEGRADIENTYes( "[g] Color over Lifetime [si(_USEGRADIENT=Yes)]", 2D ) = "white" {}
         [KeywordEnum( Linear,FadeInOut,Curve )] _ColorType( "Color Type", Float ) = 1
         _cLifetimeColorsi_COLORTYPECurve( "[c] Lifetime Color [si(_COLORTYPE=Curve)]", 2D ) = "white" {}
         _ColorFadeInPower( "Fade In Power [si(_COLORTYPE=FadeInOut)]", Float ) = 1
         _ColorFadeOutPower( "Fade Out Power [si(_COLORTYPE=FadeInOut)]", Float ) = 0
         _fSizeLifetime( "[f] Size Lifetime", Float ) = 0
         _StartSize( "Start Size", Float ) = 0
         _EndSize( "End Size", Float ) = 1
         [KeywordEnum( Linear,FadeInOut,Curve )] _SizeType( "Size Type", Float ) = 1
         _cLifetimeSizesi_SIZETYPECurve( "[c] Lifetime Size [si(_SIZETYPE=Curve)]", 2D ) = "white" {}
         _SizeFadeInPower( "Fade In Power [si(_SIZETYPE=FadeInOut)]", Float ) = 1
         _SizeFadeOutPower( "Fade Out Power [si(_SIZETYPE=FadeInOut)]", Float ) = 0
         _fPosition( "[f] Position", Float ) = 0
         _EmitterDimensions( "Emitter Dimensions", Vector ) = ( 1, 1, 0, 0 )
         _Speed( "Speed", Vector ) = ( 0, 0, 0, 0 )
         _Acceleration( "Acceleration", Vector ) = ( 0, 0, 0, 0 )
         [Toggle( _USENOISEPOSITION_ON )] _UseNoisePosition( "Use Noise Position", Float ) = 0
         _MaxNoiseMovment( "Max Noise Movment [si(_USENOISEPOSITION_ON)]", Vector ) = ( 0, 0, 0, 0 )
         _NoiseScale( "Noise Scale [si(_USENOISEPOSITION_ON)]", Float ) = 1
         _fUnrealated( "[f] Unrealated", Float ) = 0
         [HideInInspector] _texcoord( "", 2D ) = "white" {}


        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        
        [HideInInspector] _StencilComp ("Stencil Comparison", Float) = 8
        [HideInInspector] _Stencil ("Stencil ID", Float) = 0
        [HideInInspector] _StencilOp ("Stencil Operation", Float) = 0
        [HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
        [HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255

        [HideInInspector]
        _ColorMask ("Color Mask", Float) = 15

        [HideInInspector]
        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

    }

    SubShader
    {
		LOD 0

        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

        Stencil
        {
        	Ref [_Stencil]
        	ReadMask [_StencilReadMask]
        	WriteMask [_StencilWriteMask]
        	Comp [_StencilComp]
        	Pass [_StencilOp]
        }


        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]

        
        Pass
        {
            Name "Default"
        CGPROGRAM
            #define ASE_VERSION 19901

            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            #include "UnityShaderVariables.cginc"
            #define ASE_NEEDS_VERT_POSITION
            #define ASE_NEEDS_FRAG_COLOR
            #define ASE_NEEDS_TEXTURE_COORDINATES0
            #define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
            #pragma shader_feature _SIZETYPE_LINEAR _SIZETYPE_FADEINOUT _SIZETYPE_CURVE
            #pragma shader_feature_local _USECUSTOMTIME_ON
            #pragma shader_feature_local _USENOISEPOSITION_ON
            #pragma shader_feature_local _USEFLIPBOOK_ON
            #pragma shader_feature_local _RANDOMSTARTFRAME_ON
            #pragma shader_feature_local _USEGRADIENT_NO _USEGRADIENT_YES
            #pragma shader_feature _COLORTYPE_LINEAR _COLORTYPE_FADEINOUT _COLORTYPE_CURVE


            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 ase_tangent : TANGENT;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4  mask : TEXCOORD2;
                float4 customData : TEXCOORD4;
                UNITY_VERTEX_OUTPUT_STEREO
                float4 ase_tangent : TANGENT;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;
            float4 _customData;

            uniform float _fSizeLifetime;
            uniform half _fPosition;
            uniform half _fUnrealated;
            uniform half _fColorLifetime;
            uniform half _Whatever;
            uniform half _fFlipbook;
            uniform float _StartSize;
            uniform float _EndSize;
            uniform float _CustomTImesiUSECUSTOMTIME_ON;
            uniform float _MaxLifetime;
            uniform float _SizeFadeInPower;
            uniform float _SizeFadeOutPower;
            uniform sampler2D _cLifetimeSizesi_SIZETYPECurve;
            uniform float2 _EmitterDimensions;
            uniform float2 _Speed;
            uniform float2 _Acceleration;
            uniform float2 _MaxNoiseMovment;
            uniform float _NoiseScale;
            uniform float2 _FlipbookCellssi_USEFLIPBOOK_ON;
            uniform float _FlipbbokSpeedsi_USEFLIPBOOK_ON;
            uniform float4 _StartColorsi_USEGRADIENTNo;
            uniform float4 _EndColorsi_USEGRADIENTNo;
            uniform float _ColorFadeInPower;
            uniform float _ColorFadeOutPower;
            uniform sampler2D _cLifetimeColorsi_COLORTYPECurve;
            uniform sampler2D _gColoroverLifetimesi_USEGRADIENTYes;
            float3 HashVector32_g1( float3 p )
            {
            	uint3 v = (uint3) (int3) p;
            	    v.x ^= 1103515245U;
            	    v.y ^= v.x + v.z;
            	    v.y = v.y * 134775813;
            	    v.z += v.x ^ v.y;
            	    v.y += v.x ^ v.z;
            	    v.x += v.y * v.z;
            	    v.x = v.x * 0x27d4eb2du;
            	    v.z ^= v.x << 3;
            	    v.y += v.z << 3; 
            	return v * (1.0 / float(0xffffffff));
            }
            
            inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
            inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
            inline float valueNoise (float2 uv)
            {
            	float2 i = floor(uv);
            	float2 f = frac( uv );
            	f = f* f * (3.0 - 2.0 * f);
            	uv = abs( frac(uv) - 0.5);
            	float2 c0 = i + float2( 0.0, 0.0 );
            	float2 c1 = i + float2( 1.0, 0.0 );
            	float2 c2 = i + float2( 0.0, 1.0 );
            	float2 c3 = i + float2( 1.0, 1.0 );
            	float r0 = noise_randomValue( c0 );
            	float r1 = noise_randomValue( c1 );
            	float r2 = noise_randomValue( c2 );
            	float r3 = noise_randomValue( c3 );
            	float bottomOfGrid = noise_interpolate( r0, r1, f.x );
            	float topOfGrid = noise_interpolate( r2, r3, f.x );
            	float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
            	return t;
            }
            
            float SimpleNoise(float2 UV)
            {
            	float t = 0.0;
            	float freq = pow( 2.0, float( 0 ) );
            	float amp = pow( 0.5, float( 3 - 0 ) );
            	t += valueNoise( UV/freq )*amp;
            	freq = pow(2.0, float(1));
            	amp = pow(0.5, float(3-1));
            	t += valueNoise( UV/freq )*amp;
            	freq = pow(2.0, float(2));
            	amp = pow(0.5, float(3-2));
            	t += valueNoise( UV/freq )*amp;
            	return t;
            }
            

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                float3 appendResult150 = (float3(v.ase_tangent.x , v.ase_tangent.y , v.ase_tangent.z));
                float3 Correct_Object_Position152 = appendResult150;
                float2 appendResult391 = (float2(( v.vertex.xyz - Correct_Object_Position152 ).xy));
                float2 Vertex_Offset_From_Center189 = appendResult391;
                float Quad_Value153 = v.ase_tangent.w;
                #ifdef _USECUSTOMTIME_ON
                float staticSwitch240 = _CustomTImesiUSECUSTOMTIME_ON;
                #else
                float staticSwitch240 = _Time.y;
                #endif
                float Time242 = staticSwitch240;
                float temp_output_158_0 = ( Quad_Value153 + ( Time242 / _MaxLifetime ) );
                float temp_output_117_0 = frac( temp_output_158_0 );
                float Lifetime_Progress194 = temp_output_117_0;
                float temp_output_209_0 = ( pow( Lifetime_Progress194 , _SizeFadeInPower ) * pow( ( 1.0 - Lifetime_Progress194 ) , _SizeFadeOutPower ) );
                float2 temp_cast_1 = (saturate( temp_output_209_0 )).xx;
                #if defined( _SIZETYPE_LINEAR )
                float staticSwitch222 = Lifetime_Progress194;
                #elif defined( _SIZETYPE_FADEINOUT )
                float staticSwitch222 = temp_output_209_0;
                #elif defined( _SIZETYPE_CURVE )
                float staticSwitch222 = tex2Dlod( _cLifetimeSizesi_SIZETYPECurve, float4( temp_cast_1, 0, 0.0) ).r;
                #else
                float staticSwitch222 = temp_output_209_0;
                #endif
                float lerpResult213 = lerp( _StartSize , _EndSize , staticSwitch222);
                float Lifetime_Size192 = lerpResult213;
                float3 temp_cast_3 = (( floor( ( Quad_Value153 * 174937.0 ) ) + temp_output_158_0 )).xxx;
                float3 p2_g1 = temp_cast_3;
                float3 localHashVector32_g1 = HashVector32_g1( p2_g1 );
                float3 Hash_3_Quad97 = localHashVector32_g1;
                float2 appendResult393 = (float2(Hash_3_Quad97.xy));
                float2 Emitter_Position394 = ( ( ( appendResult393 * float2( 2,2 ) ) + float2( -1,-1 ) ) * _EmitterDimensions );
                float Lifetime_seconds195 = ( temp_output_117_0 * _MaxLifetime );
                float2 Travel_Distance291 = ( ( _Speed * Lifetime_seconds195 ) + ( _Acceleration * Lifetime_seconds195 * Lifetime_seconds195 ) );
                float3 break351 = Hash_3_Quad97;
                float2 appendResult352 = (float2(break351.x , break351.y));
                float dotResult4_g28 = dot( appendResult352 , float2( 12.9898,78.233 ) );
                float lerpResult10_g28 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g28 ) * 43758.55 ) ));
                float Noise_for_Movement364 = lerpResult10_g28;
                float2 appendResult367 = (float2(Noise_for_Movement364 , Lifetime_seconds195));
                float simpleNoise349 = SimpleNoise( appendResult367*_NoiseScale );
                float2 appendResult371 = (float2(( 45.5 + Noise_for_Movement364 ) , Lifetime_seconds195));
                float simpleNoise372 = SimpleNoise( appendResult371*_NoiseScale );
                float2 appendResult375 = (float2(simpleNoise349 , simpleNoise372));
                float2 Random_Position_Offset377 = ( _MaxNoiseMovment * (appendResult375*2.0 + -1.0) );
                #ifdef _USENOISEPOSITION_ON
                float2 staticSwitch398 = Random_Position_Offset377;
                #else
                float2 staticSwitch398 = float2( 0,0 );
                #endif
                
                OUT.ase_tangent = v.ase_tangent;

                OUT.customData =  float4( 0, 0, 0, 0) ;
                v.vertex.xyz = ( Correct_Object_Position152 + float3( ( Vertex_Offset_From_Center189 * Lifetime_Size192 ) ,  0.0 ) + float3( Emitter_Position394 ,  0.0 ) + float3( Travel_Distance291 ,  0.0 ) + float3( staticSwitch398 ,  0.0 ) );

                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord = v.texcoord;
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN ) : SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0/alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision)*invAlphaPrecision;

                float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                float temp_output_4_0_g33 = _FlipbookCellssi_USEFLIPBOOK_ON.x;
                float temp_output_5_0_g33 = _FlipbookCellssi_USEFLIPBOOK_ON.y;
                float temp_output_176_0 = ( _FlipbookCellssi_USEFLIPBOOK_ON.x * _FlipbookCellssi_USEFLIPBOOK_ON.y );
                float Quad_Value153 = IN.ase_tangent.w;
                #ifdef _USECUSTOMTIME_ON
                float staticSwitch240 = _CustomTImesiUSECUSTOMTIME_ON;
                #else
                float staticSwitch240 = _Time.y;
                #endif
                float Time242 = staticSwitch240;
                float temp_output_158_0 = ( Quad_Value153 + ( Time242 / _MaxLifetime ) );
                float3 temp_cast_0 = (( floor( ( Quad_Value153 * 174937.0 ) ) + temp_output_158_0 )).xxx;
                float3 p2_g1 = temp_cast_0;
                float3 localHashVector32_g1 = HashVector32_g1( p2_g1 );
                float3 Hash_3_Quad97 = localHashVector32_g1;
                float3 break351 = Hash_3_Quad97;
                float2 appendResult354 = (float2(break351.x , break351.z));
                float dotResult4_g32 = dot( appendResult354 , float2( 12.9898,78.233 ) );
                float lerpResult10_g32 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g32 ) * 43758.55 ) ));
                float Noise_for_Start_Frame396 = lerpResult10_g32;
                float lerpResult409 = lerp( 0.0 , ( temp_output_176_0 * 2.0 ) , Noise_for_Start_Frame396);
                #ifdef _RANDOMSTARTFRAME_ON
                float staticSwitch407 = lerpResult409;
                #else
                float staticSwitch407 = 0.0;
                #endif
                float Quad_Time229 = temp_output_158_0;
                // *** BEGIN Flipbook UV Animation vars ***
                // Total tiles of Flipbook Texture
                float fbtotaltiles246_g33 = min( temp_output_4_0_g33 * temp_output_5_0_g33, ( ( temp_output_4_0_g33 * temp_output_5_0_g33 ) - 0.0 ) + 1 );
                // Offsets for cols and rows of Flipbook Texture
                float fbcolsoffset246_g33 = 1.0f / temp_output_4_0_g33;
                float fbrowsoffset246_g33 = 1.0f / temp_output_5_0_g33;
                // Speed of animation
                float fbspeed246_g33 = Quad_Time229 * ( temp_output_176_0 * _FlipbbokSpeedsi_USEFLIPBOOK_ON );
                // UV Tiling (col and row offset)
                float2 fbtiling246_g33 = float2(fbcolsoffset246_g33, fbrowsoffset246_g33);
                // UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
                // Calculate current tile linear index
                float fbcurrenttileindex246_g33 = floor( fmod( fbspeed246_g33 + staticSwitch407, fbtotaltiles246_g33) );
                fbcurrenttileindex246_g33 += ( fbcurrenttileindex246_g33 < 0) ? fbtotaltiles246_g33 : 0;
                // Obtain Offset X coordinate from current tile linear index
                float fblinearindextox246_g33 = round ( fmod ( fbcurrenttileindex246_g33, temp_output_4_0_g33 ) );
                // Multiply Offset X by coloffset
                float fboffsetx246_g33 = fblinearindextox246_g33 * fbcolsoffset246_g33;
                // Obtain Offset Y coordinate from current tile linear index
                float fblinearindextoy246_g33 = round( fmod( ( fbcurrenttileindex246_g33 - fblinearindextox246_g33 ) / temp_output_4_0_g33, temp_output_5_0_g33 ) );
                // Reverse Y to get tiles from Top to Bottom
                fblinearindextoy246_g33 = (int)(temp_output_5_0_g33-1) - fblinearindextoy246_g33;
                // Multiply Offset Y by rowoffset
                float fboffsety246_g33 = fblinearindextoy246_g33 * fbrowsoffset246_g33;
                // UV Offset
                float2 fboffset246_g33 = float2(fboffsetx246_g33, fboffsety246_g33);
                // Flipbook UV
                float2 fbuv246_g33 = IN.texcoord.xy * fbtiling246_g33 + fboffset246_g33;
                // *** END Flipbook UV Animation vars ***
                int flipbookFrame246_g33 = ( ( int )fbcurrenttileindex246_g33);
                #ifdef _USEFLIPBOOK_ON
                float4 staticSwitch255 = tex2D( _MainTex, fbuv246_g33 );
                #else
                float4 staticSwitch255 = tex2D( _MainTex, uv_MainTex );
                #endif
                float temp_output_117_0 = frac( temp_output_158_0 );
                float Lifetime_Progress194 = temp_output_117_0;
                float temp_output_273_0 = ( pow( Lifetime_Progress194 , _ColorFadeInPower ) * pow( ( 1.0 - Lifetime_Progress194 ) , _ColorFadeOutPower ) );
                float2 temp_cast_1 = (saturate( temp_output_273_0 )).xx;
                #if defined( _COLORTYPE_LINEAR )
                float staticSwitch278 = Lifetime_Progress194;
                #elif defined( _COLORTYPE_FADEINOUT )
                float staticSwitch278 = temp_output_273_0;
                #elif defined( _COLORTYPE_CURVE )
                float staticSwitch278 = tex2D( _cLifetimeColorsi_COLORTYPECurve, temp_cast_1 ).r;
                #else
                float staticSwitch278 = temp_output_273_0;
                #endif
                float4 lerpResult279 = lerp( _StartColorsi_USEGRADIENTNo , _EndColorsi_USEGRADIENTNo , staticSwitch278);
                float2 temp_cast_2 = (saturate( staticSwitch278 )).xx;
                #if defined( _USEGRADIENT_NO )
                float4 staticSwitch288 = lerpResult279;
                #elif defined( _USEGRADIENT_YES )
                float4 staticSwitch288 = tex2D( _gColoroverLifetimesi_USEGRADIENTYes, temp_cast_2 );
                #else
                float4 staticSwitch288 = lerpResult279;
                #endif
                float4 Lifetime_Color280 = staticSwitch288;
                

                half4 color = ( IN.color * staticSwitch255 * Lifetime_Color280 );

                #ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                color.a *= m.x * m.y;
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                color.rgb *= color.a;

                return color;
            }
        ENDCG
        }
    }
    CustomEditor "Chroma"
	
	Fallback Off
}
/*ASEBEGIN
Version=19901
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;236;-3328,-448;Inherit;False;1030.399;546.1;;20;245;242;240;121;241;163;195;194;229;196;117;97;120;182;158;181;166;154;243;415;Hash & TIme;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;241;-3296,16;Inherit;False;Property;_CustomTImesiUSECUSTOMTIME_ON;Custom TIme [si(USECUSTOMTIME_ON)];3;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;121;-3296,-64;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;191;-4224,-448;Inherit;False;847.2002;489.35;;9;189;391;149;153;155;83;152;150;147;Vertex Data;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;240;-2992,-48;Inherit;False;Property;_UseCustomTime;Use Custom Time;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TangentVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;-4176,-400;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;242;-2704,-48;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;153;-3856,-304;Float;False;Quad Value;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;243;-3280,-240;Inherit;False;242;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;163;-3296,-144;Inherit;False;Property;_MaxLifetime;Max Lifetime;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;154;-3312,-384;Inherit;False;153;Quad Value;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;166;-3104,-224;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;181;-3072,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;174937;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;158;-2944,-256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;182;-2928,-400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;120;-2816,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;415;-2688,-400;Inherit;False;HashVector3;-1;;1;5f4e488a01b1707489c22df9fbf91233;0;1;1;FLOAT3;0,0,0;False;1;FLOAT3;3
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;97;-2512,-400;Inherit;False;Hash 3 Quad;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;350;-4528,656;Inherit;False;97;Hash 3 Quad;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FractNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;117;-2800,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;351;-4336,656;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;266;-3152,1536;Inherit;False;2392.94;610.8431;;18;280;288;274;275;278;289;283;284;287;279;281;273;272;271;269;270;268;267;Lifetime Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;352;-4144,352;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;194;-2544,-224;Inherit;False;Lifetime Progress;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;227;-3170,798;Inherit;False;1751.34;611.6434;;15;253;198;209;192;213;222;200;201;225;207;203;204;208;206;202;Lifetime Scale;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;267;-3088,1664;Inherit;False;194;Lifetime Progress;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;353;-4016,352;Inherit;False;Random Range;-1;;28;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;202;-3120,928;Inherit;False;194;Lifetime Progress;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;268;-2832,1696;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;270;-2976,1584;Inherit;False;Property;_ColorFadeInPower;Fade In Power [si(_COLORTYPE=FadeInOut)];16;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;269;-2976,1760;Inherit;False;Property;_ColorFadeOutPower;Fade Out Power [si(_COLORTYPE=FadeInOut)];17;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;196;-2688,-176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;376;-2016,2416;Inherit;False;1630.981;538.4268;;15;385;374;377;387;375;367;383;349;370;373;372;371;369;365;368;Movement Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;364;-3824,352;Inherit;False;Noise for Movement;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;206;-2864,960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;204;-3008,848;Inherit;False;Property;_SizeFadeInPower;Fade In Power [si(_SIZETYPE=FadeInOut)];23;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;208;-3008,1024;Inherit;False;Property;_SizeFadeOutPower;Fade Out Power [si(_SIZETYPE=FadeInOut)];24;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;271;-2640,1584;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;272;-2640,1712;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;369;-1952,2784;Inherit;False;364;Noise for Movement;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;195;-2544,-160;Inherit;False;Lifetime seconds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;203;-2672,848;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;207;-2672,976;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;273;-2496,1632;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;373;-1696,2768;Inherit;False;2;2;0;FLOAT;45.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;370;-1952,2848;Inherit;False;195;Lifetime seconds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;368;-1952,2608;Inherit;False;195;Lifetime seconds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;365;-1952,2544;Inherit;False;364;Noise for Movement;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;397;-706,1374;Inherit;False;996;274.85;;7;44;45;46;47;394;393;329;Emitter;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;150;-3984,-400;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;209;-2528,896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;274;-2560,1904;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;371;-1584,2784;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;367;-1584,2544;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;383;-1792,2688;Inherit;False;Property;_NoiseScale;Noise Scale [si(_USENOISEPOSITION_ON)];31;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;354;-4144,464;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;238;-2016,-496;Inherit;False;1606.852;949.3232;;14;409;175;407;128;176;230;188;183;239;255;259;107;410;411;Flipbook;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;152;-3856,-400;Inherit;False;Correct Object Position;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;253;-2624,1184;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;275;-2416,1888;Inherit;True;Property;_cLifetimeColorsi_COLORTYPECurve;[c] Lifetime Color [si(_COLORTYPE=Curve)];15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.NoiseGeneratorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;372;-1440,2784;Inherit;False;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;349;-1440,2544;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;362;-4016,464;Inherit;False;Random Range;-1;;32;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;329;-688,1424;Inherit;False;97;Hash 3 Quad;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;128;-2000,-112;Inherit;False;Property;_FlipbookCellssi_USEFLIPBOOK_ON;Flipbook Cells [si(_USEFLIPBOOK_ON)];8;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PosVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-4176,-208;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;155;-4176,-48;Inherit;False;152;Correct Object Position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;311;-2992,2416;Inherit;False;916;418.8501;;7;295;294;308;296;307;306;291;Lifetime Travel;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;225;-2480,1152;Inherit;True;Property;_cLifetimeSizesi_SIZETYPECurve;[c] Lifetime Size [si(_SIZETYPE=Curve)];22;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;278;-2096,1664;Inherit;False;Property;_ColorType;Color Type;14;0;Create;True;0;0;0;True;0;False;0;1;1;True;_ScaleCurve;KeywordEnum;3;Linear;FadeInOut;Curve;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;375;-1216,2640;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;396;-3824,464;Inherit;False;Noise for Start Frame;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;393;-496,1424;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;176;-1664,-64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;149;-3920,-112;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;222;-2224,928;Inherit;False;Property;_SizeType;Size Type;21;0;Create;True;0;0;0;True;0;False;0;1;1;True;_ScaleCurve;KeywordEnum;3;Linear;FadeInOut;Curve;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;200;-1952,880;Inherit;False;Property;_StartSize;Start Size;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;201;-1952,944;Inherit;False;Property;_EndSize;End Size;20;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;289;-1776,1968;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;283;-1792,1568;Inherit;False;Property;_StartColorsi_USEGRADIENTNo;Start Color [si(_USEGRADIENT=No)];11;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;284;-1792,1744;Inherit;False;Property;_EndColorsi_USEGRADIENTNo;End Color [si(_USEGRADIENT=No)];12;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;295;-2944,2592;Inherit;False;195;Lifetime seconds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;294;-2848,2464;Inherit;False;Property;_Speed;Speed;27;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;308;-2880,2672;Inherit;False;Property;_Acceleration;Acceleration;28;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;387;-1056,2640;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;385;-1152,2512;Inherit;False;Property;_MaxNoiseMovment;Max Noise Movment [si(_USENOISEPOSITION_ON)];30;0;Create;False;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;410;-1840,-240;Inherit;False;396;Noise for Start Frame;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;-352,1424;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;411;-1535.285,-272.4774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;391;-3792,-112;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;229;-2512,-288;Inherit;False;Quad Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;213;-1792,880;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;287;-1648,1952;Inherit;True;Property;_gColoroverLifetimesi_USEGRADIENTYes;[g] Color over Lifetime [si(_USEGRADIENT=Yes)];13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;279;-1456,1648;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;296;-2656,2496;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;307;-2656,2608;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;374;-800,2512;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;183;-1600,96;Inherit;False;Property;_FlipbbokSpeedsi_USEFLIPBOOK_ON;Flipbbok Speed [si(_USEFLIPBOOK_ON)];6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;409;-1456,-192;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;-336,1520;Inherit;False;Property;_EmitterDimensions;Emitter Dimensions;26;0;Create;True;1;Emitter Settings;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-192,1424;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-1,-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;189;-3664,-112;Inherit;False;Vertex Offset From Center;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;192;-1648,880;Inherit;False;Lifetime Size;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;288;-1280,1792;Inherit;False;Property;_UseGradient;UseGradient;10;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;No;Yes;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;306;-2464,2528;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;377;-672,2512;Inherit;False;Random Position Offset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;107;-1280,-416;Inherit;False;0;0;_MainTex;Shader;True;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;230;-1200,112;Inherit;False;229;Quad Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;188;-1248,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-80,1424;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;407;-1280,-176;Inherit;False;Property;_RandomStartFrame;Random Start Frame;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;280;-1024,1792;Inherit;False;Lifetime Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;291;-2320,2528;Inherit;False;Travel Distance;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;217;-368,624;Inherit;False;192;Lifetime Size;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;190;-432,560;Inherit;False;189;Vertex Offset From Center;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;399;-544,832;Inherit;False;377;Random Position Offset;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;259;-1024,-448;Inherit;True;Property;_TextureSample0;Texture Sample 0;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;175;-1024,-240;Inherit;False;Flipbook;-1;;33;53c2488c220f6564ca6c90721ee16673;3,68,0,217,0,244,1;11;51;SAMPLER2D;0.0;False;167;SAMPLERSTATE;0;False;13;FLOAT2;0,0;False;24;FLOAT;0;False;210;FLOAT;4;False;4;FLOAT;4;False;5;FLOAT;4;False;130;FLOAT;4;False;2;FLOAT;0;False;55;FLOAT;0;False;70;FLOAT;0;False;5;COLOR;53;FLOAT2;0;FLOAT;47;FLOAT;48;INT;218
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;394;48,1424;Inherit;False;Emitter Position;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;162;-272,-464;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;286;-96,80;Inherit;False;280;Lifetime Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;-128,576;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;395;-192,688;Inherit;False;394;Emitter Position;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;389;-256,480;Inherit;False;152;Correct Object Position;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;293;-192,752;Inherit;False;291;Travel Distance;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;398;-288,816;Inherit;False;Property;_UseNoisePosition;Use Noise Position;29;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;255;-704,-320;Inherit;False;Property;_UseFlipbook;Use Flipbook;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;198;-3056,1168;Inherit;False;Property;_fSizeLifetime;[f] Size Lifetime;18;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;144,-240;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;355;-4144,576;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;357;-4144,688;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;380;-2944,2240;Half;False;Property;_fPosition;[f] Position;25;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;218;-4112,64;Half;False;Property;_fUnrealated;[f] Unrealated;32;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;281;-3024,1904;Half;False;Property;_fColorLifetime;[f] Color Lifetime;9;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;160,576;Inherit;False;5;5;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;359;-4144,800;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;361;-4144,912;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;363;-4016,576;Inherit;False;Random Range;-1;;34;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;356;-4016,688;Inherit;False;Random Range;-1;;35;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;358;-4016,800;Inherit;False;Random Range;-1;;36;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;360;-4016,912;Inherit;False;Random Range;-1;;37;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;245;-2464,-32;Half;False;Property;_Whatever;[f]Time;1;0;Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;239;-1888,-416;Half;False;Property;_fFlipbook;[f] Flipbook;4;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;413;352,144;Float;False;True;-1;3;Chroma;0;18;UI Particles;be4d4bcd50512f54fa7c9e44b0a24c92;True;Default;0;0;Default;3;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;240;1;121;0
WireConnection;240;0;241;0
WireConnection;242;0;240;0
WireConnection;153;0;147;4
WireConnection;166;0;243;0
WireConnection;166;1;163;0
WireConnection;181;0;154;0
WireConnection;158;0;154;0
WireConnection;158;1;166;0
WireConnection;182;0;181;0
WireConnection;120;0;182;0
WireConnection;120;1;158;0
WireConnection;415;1;120;0
WireConnection;97;0;415;3
WireConnection;117;0;158;0
WireConnection;351;0;350;0
WireConnection;352;0;351;0
WireConnection;352;1;351;1
WireConnection;194;0;117;0
WireConnection;353;1;352;0
WireConnection;268;0;267;0
WireConnection;196;0;117;0
WireConnection;196;1;163;0
WireConnection;364;0;353;0
WireConnection;206;0;202;0
WireConnection;271;0;267;0
WireConnection;271;1;270;0
WireConnection;272;0;268;0
WireConnection;272;1;269;0
WireConnection;195;0;196;0
WireConnection;203;0;202;0
WireConnection;203;1;204;0
WireConnection;207;0;206;0
WireConnection;207;1;208;0
WireConnection;273;0;271;0
WireConnection;273;1;272;0
WireConnection;373;1;369;0
WireConnection;150;0;147;1
WireConnection;150;1;147;2
WireConnection;150;2;147;3
WireConnection;209;0;203;0
WireConnection;209;1;207;0
WireConnection;274;0;273;0
WireConnection;371;0;373;0
WireConnection;371;1;370;0
WireConnection;367;0;365;0
WireConnection;367;1;368;0
WireConnection;354;0;351;0
WireConnection;354;1;351;2
WireConnection;152;0;150;0
WireConnection;253;0;209;0
WireConnection;275;1;274;0
WireConnection;372;0;371;0
WireConnection;372;1;383;0
WireConnection;349;0;367;0
WireConnection;349;1;383;0
WireConnection;362;1;354;0
WireConnection;225;1;253;0
WireConnection;278;1;267;0
WireConnection;278;0;273;0
WireConnection;278;2;275;1
WireConnection;375;0;349;0
WireConnection;375;1;372;0
WireConnection;396;0;362;0
WireConnection;393;0;329;0
WireConnection;176;0;128;1
WireConnection;176;1;128;2
WireConnection;149;0;83;0
WireConnection;149;1;155;0
WireConnection;222;1;202;0
WireConnection;222;0;209;0
WireConnection;222;2;225;1
WireConnection;289;0;278;0
WireConnection;387;0;375;0
WireConnection;44;0;393;0
WireConnection;411;0;176;0
WireConnection;391;0;149;0
WireConnection;229;0;158;0
WireConnection;213;0;200;0
WireConnection;213;1;201;0
WireConnection;213;2;222;0
WireConnection;287;1;289;0
WireConnection;279;0;283;0
WireConnection;279;1;284;0
WireConnection;279;2;278;0
WireConnection;296;0;294;0
WireConnection;296;1;295;0
WireConnection;307;0;308;0
WireConnection;307;1;295;0
WireConnection;307;2;295;0
WireConnection;374;0;385;0
WireConnection;374;1;387;0
WireConnection;409;1;411;0
WireConnection;409;2;410;0
WireConnection;45;0;44;0
WireConnection;189;0;391;0
WireConnection;192;0;213;0
WireConnection;288;1;279;0
WireConnection;288;0;287;0
WireConnection;306;0;296;0
WireConnection;306;1;307;0
WireConnection;377;0;374;0
WireConnection;188;0;176;0
WireConnection;188;1;183;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;407;0;409;0
WireConnection;280;0;288;0
WireConnection;291;0;306;0
WireConnection;259;0;107;0
WireConnection;175;51;107;0
WireConnection;175;24;407;0
WireConnection;175;4;128;1
WireConnection;175;5;128;2
WireConnection;175;130;188;0
WireConnection;175;2;230;0
WireConnection;394;0;47;0
WireConnection;80;0;190;0
WireConnection;80;1;217;0
WireConnection;398;0;399;0
WireConnection;255;1;259;0
WireConnection;255;0;175;53
WireConnection;109;0;162;0
WireConnection;109;1;255;0
WireConnection;109;2;286;0
WireConnection;355;0;351;1
WireConnection;355;1;351;2
WireConnection;357;0;351;1
WireConnection;357;1;351;0
WireConnection;82;0;389;0
WireConnection;82;1;80;0
WireConnection;82;2;395;0
WireConnection;82;3;293;0
WireConnection;82;4;398;0
WireConnection;359;0;351;2
WireConnection;359;1;351;0
WireConnection;361;0;351;2
WireConnection;361;1;351;1
WireConnection;363;1;355;0
WireConnection;356;1;357;0
WireConnection;358;1;359;0
WireConnection;360;1;361;0
WireConnection;413;0;109;0
WireConnection;413;2;82;0
ASEEND*/
//CHKSM=4EB41E9D4C931B973308CC695768D2503878F769