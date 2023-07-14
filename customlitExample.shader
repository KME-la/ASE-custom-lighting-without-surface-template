// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "customlitExample"
{
	Properties
	{
		
		
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="False" }
	LOD 0

		Cull Back
		AlphaToMask Off
		ZWrite On
		ZTest LEqual
		ColorMask RGBA
		
		Blend Off
		

		CGINCLUDE
		
		#define _ALPHATEST_ON
		#pragma target 5.0

		ENDCG
	

		
		Pass
		{
			Name "FORWARD"
			Tags { "LightMode"="ForwardBase" }
	

	CGPROGRAM




			#define ASE_ABSOLUTE_VERTEX_POS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile_fwdbase





			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#pragma multi_compile _ SHADOWS_SCREEN
			#pragma multi_compile _ VERTEXLIGHT_ON
			#ifndef UNITY_PASS_FORWARDBASE
				#define UNITY_PASS_FORWARDBASE
			#endif
			#include "HLSLSupport.cginc"
			#ifndef UNITY_INSTANCED_LOD_FADE
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#ifndef UNITY_INSTANCED_SH
				#define UNITY_INSTANCED_SH
			#endif
			#ifndef UNITY_INSTANCED_LIGHTMAPSTS
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#define _ALPHATEST_ON
			#define UNITY_SHOULD_SAMPLE_SH (defined(LIGHTPROBE_SH) && !defined(UNITY_PASS_FORWARDADD) && !defined(UNITY_PASS_PREPASSBASE) && !defined(UNITY_PASS_SHADOWCASTER) && !defined(UNITY_PASS_META))
		
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityStandardCore.cginc"
			#include "UnityStandardBRDF.cginc"


			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES2

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
		
				
				
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				#if defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS) && UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHTING_COORDS(2,3)
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_SHADOW_COORDS(2)
					#else
						SHADOW_COORDS(2)
					#endif
				#endif
				#ifdef ASE_FOG
					UNITY_FOG_COORDS(4)
				#endif
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
				float4 ase_lmap : TEXCOORD8;
				float4 ase_sh : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

		
			

			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float3 LightColorZero(  )
			{
				return unity_LightColor[0];
			}
			
			float3 LightColorZOne(  )
			{
				return unity_LightColor[1];
			}
			
			float3 LightColorZTwo(  )
			{
				return unity_LightColor[2];
			}
			
			float3 LightColorZThree(  )
			{
				return unity_LightColor[3];
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 _Vector0 = float3(1,0,0);
				float3 rotatedValue522 = RotateAroundAxis( float3( 0,0,0 ), v.vertex.xyz, _Vector0, _Time.y );
				float3 finalvertexpos544 = rotatedValue522;
				
				float3 rotatedValue521 = RotateAroundAxis( float3( 0,0,0 ), v.normal, _Vector0, _Time.y );
				float3 normalizeResult525 = normalize( rotatedValue521 );
				float3 finalvertexnorm545 = normalizeResult525;
				
				#ifdef DYNAMICLIGHTMAP_ON //dynlm
				o.ase_lmap.zw = v.texcoord2.xyzw.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif //dynlm
				#ifdef LIGHTMAP_ON //stalm
				o.ase_lmap.xy = v.texcoord1.xyzw.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif //stalm
				float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.normal);
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_sh.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = finalvertexpos544;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = finalvertexnorm545;
				v.tangent = v.tangent;
				

				o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

				#if UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_TRANSFER_SHADOW(o, v.texcoord1.xy);
					#else
						TRANSFER_SHADOW(o);
					#endif
				#endif

				#ifdef ASE_FOG
					UNITY_TRANSFER_FOG(o,o.pos);
				#endif
				return o;
			}

			
		
			v2f vert ( appdata v )
			{
				return VertexFunction( v );
			}
			

			fixed4 frag (v2f IN 
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
				) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);

					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
			
				float3 WorldTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldNormal = float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z);
				float3 worldPos = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
				#else
					half atten = 1;
				#endif

				UnityGIInput data;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data );
				data.worldPos = worldPos;
				data.worldViewDir = worldViewDir;
				data.probeHDR[0] = unity_SpecCube0_HDR;
				data.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION //specdataif0
				data.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif //specdataif0
				#if UNITY_SPECCUBE_BOX_PROJECTION //specdataif1
				data.boxMax[0] = unity_SpecCube0_BoxMax;
				data.probePosition[0] = unity_SpecCube0_ProbePosition;
				data.boxMax[1] = unity_SpecCube1_BoxMax;
				data.boxMin[1] = unity_SpecCube1_BoxMin;
				data.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif //specdataif1
				Unity_GlossyEnvironmentData g517 = UnityGlossyEnvironmentSetup( 0.5, worldViewDir, WorldNormal, float3(0,0,0));
				float3 indirectSpecular517 = UnityGI_IndirectSpecular( data, 1.0, WorldNormal, g517 );
				UnityGIInput data516;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data516 );
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm516
				data516.lightmapUV = IN.ase_lmap;
				#endif //dylm516
				#if UNITY_SHOULD_SAMPLE_SH //fsh516
				data516.ambient = IN.ase_sh;
				#endif //fsh516
				UnityGI gi516 = UnityGI_Base(data516, 1, WorldNormal);
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 temp_output_512_0 = ( float4( ase_lightColor.rgb , 0.0 ) * (float4(atten,0,0,0)).xxxx );
				float3 localLightColorZero532 = LightColorZero();
				float3 localLightColorZOne530 = LightColorZOne();
				float3 localLightColorZTwo531 = LightColorZTwo();
				float3 localLightColorZThree533 = LightColorZThree();
				#ifdef VERTEXLIGHT_ON
				float3 staticSwitch537 = ( localLightColorZero532 + localLightColorZOne530 + localLightColorZTwo531 + localLightColorZThree533 );
				#else
				float3 staticSwitch537 = float3( 0,0,0 );
				#endif
				
				float3 Color = ( float4( indirectSpecular517 , 0.0 ) + float4( gi516.indirect.diffuse , 0.0 ) + temp_output_512_0 + float4( staticSwitch537 , 0.0 ) ).xyz;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				float4 c = float4( Color, Alpha );

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
					outputDepth = IN.pos.z;
				#endif

				#ifdef ASE_FOG
					UNITY_APPLY_FOG(IN.fogCoord, c);
				#endif
				return c;
			}
			ENDCG
			}


		
		Pass
		{
			Name "forwardad"
			Tags { "LightMode"="forwardadd" }
			ZWrite Off
			Blend One One

	CGPROGRAM




			#define ASE_ABSOLUTE_VERTEX_POS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_NEEDS_FRAG_SHADOWCOORDS





			#pragma vertex vert
			#pragma fragment frag
			#pragma skip_variants INSTANCING_ON
			#pragma multi_compile_fwdadd_fullshadows
			#ifndef UNITY_PASS_FORWARDADD
				#define UNITY_PASS_FORWARDADD
			#endif
			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#if !defined( UNITY_INSTANCED_SH )
				#define UNITY_INSTANCED_SH
			#endif
			#if !defined( UNITY_INSTANCED_LIGHTMAPSTS )
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"
		
		


			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
		
				
				
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				#if UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHTING_COORDS(1,2)
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_SHADOW_COORDS(1)
					#else
						SHADOW_COORDS(1)
					#endif
				#endif
				#ifdef ASE_FOG
					UNITY_FOG_COORDS(3)
				#endif
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD8;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

		
			

			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 _Vector0 = float3(1,0,0);
				float3 rotatedValue522 = RotateAroundAxis( float3( 0,0,0 ), v.vertex.xyz, _Vector0, _Time.y );
				float3 finalvertexpos544 = rotatedValue522;
				
				float3 rotatedValue521 = RotateAroundAxis( float3( 0,0,0 ), v.normal, _Vector0, _Time.y );
				float3 normalizeResult525 = normalize( rotatedValue521 );
				float3 finalvertexnorm545 = normalizeResult525;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = finalvertexpos544;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = finalvertexnorm545;
				v.tangent = v.tangent;
				

						o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

				#if UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_TRANSFER_SHADOW(o, v.texcoord1.xy);
					#else
						TRANSFER_SHADOW(o);
					#endif
				#endif

				#ifdef ASE_FOG
					UNITY_TRANSFER_FOG(o,o.pos);
				#endif
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(o.pos);
				#endif
				return o;
			}

			
		
			v2f vert ( appdata v )
			{
				return VertexFunction( v );
			}
			

			fixed4 frag (v2f IN 
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
				) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);

					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
			
				float3 WorldTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldNormal = float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z);
				float3 worldPos = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
				#else
					half atten = 1;
				#endif

				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 temp_output_512_0 = ( float4( ase_lightColor.rgb , 0.0 ) * (float4(atten,0,0,0)).xxxx );
				
				float3 Color = temp_output_512_0.xyz;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				float4 c = float4( Color, Alpha );

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
					outputDepth = IN.pos.z;
				#endif

				#ifdef ASE_FOG
					UNITY_APPLY_FOG(IN.fogCoord, c);
				#endif
				return c;
			}
			ENDCG
			}



Pass
		{
			Name "shadowcaster"
			Tags { "LightMode"="shadowcaster" }
		ZWrite On
			ZTest LEqual
		
	CGPROGRAM




			#define ASE_ABSOLUTE_VERTEX_POS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_NEEDS_FRAG_SHADOWCOORDS





			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#pragma multi_compile _ SHADOWS_SCREEN
			#pragma multi_compile _ VERTEXLIGHT_ON
		#ifndef UNITY_PASS_SHADOWCASTER
				#define UNITY_PASS_SHADOWCASTER
			#endif
			#include "HLSLSupport.cginc"
			#ifndef UNITY_INSTANCED_LOD_FADE
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#ifndef UNITY_INSTANCED_SH
				#define UNITY_INSTANCED_SH
			#endif
			#ifndef UNITY_INSTANCED_LIGHTMAPSTS
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#define _ALPHATEST_ON
			
		
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityStandardCore.cginc"
			#include "UnityStandardBRDF.cginc"


			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
		
				
				
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				#if defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS) && UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHTING_COORDS(2,3)
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_SHADOW_COORDS(2)
					#else
						SHADOW_COORDS(2)
					#endif
				#endif
				#ifdef ASE_FOG
					UNITY_FOG_COORDS(4)
				#endif
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

		
			

			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 _Vector0 = float3(1,0,0);
				float3 rotatedValue522 = RotateAroundAxis( float3( 0,0,0 ), v.vertex.xyz, _Vector0, _Time.y );
				float3 finalvertexpos544 = rotatedValue522;
				
				float3 rotatedValue521 = RotateAroundAxis( float3( 0,0,0 ), v.normal, _Vector0, _Time.y );
				float3 normalizeResult525 = normalize( rotatedValue521 );
				float3 finalvertexnorm545 = normalizeResult525;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = finalvertexpos544;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = finalvertexnorm545;
				v.tangent = v.tangent;
				

				o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			
		
			v2f vert ( appdata v )
			{
				return VertexFunction( v );
			}
			

			fixed4 frag (v2f IN 
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
				) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);

					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
			
				float3 WorldTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldNormal = float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z);
				float3 worldPos = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
				#else
					half atten = 1;
				#endif

				
				float3 Color = fixed3( 0, 0, 0 );
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				float4 c = float4( Color, Alpha );

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
					outputDepth = IN.pos.z;
				#endif

				#ifdef ASE_FOG
					UNITY_APPLY_FOG(IN.fogCoord, c);
				#endif
				return c;
			}
			ENDCG
			}

			


			



	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;543;3348.973,320.8698;Inherit;False;187;174;important lights;1;511;pixel lights;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;542;3442.575,65.64771;Inherit;False;321.1731;160.0327;spherical harmonics;1;516;light probes;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;541;3531.069,-219.1148;Inherit;False;252.4854;188.1025;environment cubemaps;1;517;reflection probes;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;540;2769.669,821.7374;Inherit;False;353.7859;149.1199;take this out if you dont want an add pass;1;537;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;539;2428.129,452.8897;Inherit;False;834.3213;202.2427;this will turn everything RED if its not swizzled like this, let me know if the template is setup wrong;2;514;513;pixel light shadows;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;535;2185.377,789.3984;Inherit;False;411.759;571.3998;more data for these can be used via custom expression;4;533;531;530;532;vertex lights (not important lights);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;529;2648.795,1655.436;Inherit;False;1140.971;720.1544;use this to offset a pass individually. good for debugging too! also set vertex position to absolute;9;545;544;520;524;525;523;522;521;519;vertex and normal offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;507;4194.857,812.9706;Float;False;False;-1;2;ASEMaterialInspector;0;12;New Amplify Shader;003dfa9c16768d048b74f75c088119d8;True;forwardad;0;1;forwardad;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;7;False;0;False;True;4;1;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;True;1;LightMode=forwardadd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;506;4196.694,557.1793;Float;False;True;-1;2;ASEMaterialInspector;0;12;customlitExample;003dfa9c16768d048b74f75c088119d8;True;FORWARD;0;0;FORWARD;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;7;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;3;Vertex Position,InvertActionOnDeselection;1;0;Receive Shadows;1;638249088809278626;Built-in Fog;1;638249084926106095;0;3;True;True;True;False;;False;0
Node;AmplifyShaderEditor.CustomExpressionNode;530;2286.376,1027.483;Inherit;False;return unity_LightColor[1]@;3;Create;0;LightColorZOne;False;False;0;;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;531;2286.376,1155.483;Inherit;False;return unity_LightColor[2]@;3;Create;0;LightColorZTwo;False;False;0;;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;533;2286.376,1267.482;Inherit;False;return unity_LightColor[3]@;3;Create;0;LightColorZThree;False;False;0;;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;3641.907,512.5159;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;526;3861.478,336.181;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;538;3786.943,726.3489;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectSpecularLight;517;3559.998,-166.8532;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;516;3503.072,132.0911;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;511;3381.051,363.3418;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.CustomExpressionNode;532;2286.376,899.4834;Inherit;False;return unity_LightColor[0]@;3;Create;0;LightColorZero;False;False;0;;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;508;4204.377,1066.24;Float;False;False;-1;2;ASEMaterialInspector;0;12;New Amplify Shader;003dfa9c16768d048b74f75c088119d8;True;shadowcaster;0;2;shadowcaster;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;7;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=shadowcaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;547;3951.772,881.1424;Inherit;False;544;finalvertexpos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;548;3965.393,1138.906;Inherit;False;544;finalvertexpos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;546;3959.711,623.3669;Inherit;False;544;finalvertexpos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;549;3972.393,695.6198;Inherit;False;545;finalvertexnorm;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;550;3964.393,957.6198;Inherit;False;545;finalvertexnorm;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;551;3986.393,1214.62;Inherit;False;545;finalvertexnorm;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode;552;4869.375,873.5515;Inherit;False;542.3643;206.0445;;NOTES;0.514151,1,0.5689806,1;This currently has three coded passes with lightmodes set to forwardbase forwardadd and shadowcaster respectively. Currently no tessellation options, but this template should allow data from all types of light to be processed in their respective passes using the existing custom lighting nodes with the added bonus of controlling what data gets sent to what pass.;0;0
Node;AmplifyShaderEditor.StaticSwitch;537;2841.644,865.0635;Inherit;False;Property;_Keyword3;Keyword+1;16;0;Create;True;0;0;0;False;0;False;0;0;0;False;VERTEXLIGHT_ON;Toggle;2;Key0;Key1;Fetch;False;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;536;2659.462,896.0028;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;514;2919.174,526.9561;Inherit;False;FLOAT4;0;0;0;0;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LightAttenuation;513;2627.838,531.3273;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;553;4974.1,1149.007;Inherit;False;532.4922;136.7738;need help with these;TODO;1,0,0,1;cleaning up unnecessary  includes and directives$adding output ports to control more internal variables$optional outline pass with stencil sorting$optional support for light baking$;0;0
Node;AmplifyShaderEditor.Vector3Node;519;2872.941,1962.248;Inherit;False;Constant;_Vector0;Vector+0;9;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RotateAboutAxisNode;521;3075.133,2213.346;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;522;3105.424,1777.246;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;523;2692.129,2010.833;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;525;3389.133,2213.263;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;524;2777.197,2222.995;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;520;3099.4,1970.122;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;545;3583.133,2214.208;Inherit;False;finalvertexnorm;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;544;3419.688,1770.947;Inherit;False;finalvertexpos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
WireConnection;507;0;512;0
WireConnection;507;3;547;0
WireConnection;507;4;550;0
WireConnection;506;0;526;0
WireConnection;506;3;546;0
WireConnection;506;4;549;0
WireConnection;512;0;511;1
WireConnection;512;1;514;0
WireConnection;526;0;517;0
WireConnection;526;1;516;0
WireConnection;526;2;512;0
WireConnection;526;3;538;0
WireConnection;538;0;537;0
WireConnection;508;3;548;0
WireConnection;508;4;551;0
WireConnection;537;0;536;0
WireConnection;536;0;532;0
WireConnection;536;1;530;0
WireConnection;536;2;531;0
WireConnection;536;3;533;0
WireConnection;514;0;513;0
WireConnection;521;0;519;0
WireConnection;521;1;523;0
WireConnection;521;3;524;0
WireConnection;522;0;519;0
WireConnection;522;1;523;0
WireConnection;522;3;520;0
WireConnection;525;0;521;0
WireConnection;545;0;525;0
WireConnection;544;0;522;0
ASEEND*/
//CHKSM=96D4A5160FCB669CD6D0A1646CD1A52DADD35224