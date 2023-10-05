Shader "Demos/Lambert"  
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _LightDirection ("Light direction", Vector) = (1,1,1)
        _LightStrength("Intensityu of light", Range(0,5)) = 2
        _AmbientLight("Ambient lighting strength", Range(0,1)) = 0.3


    }
    SubShader
    {
       Pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL; 
                float2 uv : TEXCOORD0; 
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0; 
                float2 uv : TEXCOORD1; 
            };

            float3 _LightDirection;
            float4 _Color;
            sampler2D _MainTex;
            float _AmbientLight;
            float _LightStrength;

            // Vertex function
            v2f vert(appdata IN) {
                v2f OUT;
                OUT.pos = UnityObjectToClipPos(IN.vertex);
                OUT.normal = normalize(UnityObjectToWorldNormal(IN.normal)); // Normalize the normal
                OUT.uv = IN.uv; 
                return OUT;
            }

            // Fragment function
            float4 frag(v2f IN) : SV_Target {
                float3 lightDir = normalize(_LightDirection); 
                // Calculate diffuse lighting term
                float diffuseReflection = max(0, dot(IN.normal, lightDir)*_LightStrength); 
                //Calculate ambient reflection term    
                float ambientReflection  = _AmbientLight; 
                //Add all terms
                float res = diffuseReflection + ambientReflection;
                // Finally add texture and color 
                float4 tex = (tex2D(_MainTex, IN.uv)*_Color);
                float4 finalColor = res * tex; 
                return finalColor;
            }

            ENDCG

       }
    }
    FallBack "Diffuse"
}
