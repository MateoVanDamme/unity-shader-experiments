Shader "Demos/Blinn-Phong with Texture"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {} // Diffuse color texture
        _Specular ("Specular Intensity", Range(0, 1)) = 0.5
        _SpecularExponent ("Specular Exponent", Range(1, 128)) = 32
        _LightDirection ("Light direction", Vector) = (1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL; // Include normals as a vertex attribute
                float2 uv : TEXCOORD0; // Texture coordinates
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0; // Pass the normal from the vertex to fragment stage
                float2 uv : TEXCOORD1; // Pass texture coordinates to fragment
                float3 viewDir : TEXCOORD2; // Pass the view direction from the vertex to fragment stage
                float4 color : COLOR; // Define a color variable to pass data from vertex to fragment.
            };

            float4 _Color;
            sampler2D _MainTex;
            float _Specular;
            float _SpecularExponent;
            float3 _LightDirection;

            // Vertex function
            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // Transform the vertex position to clip space

                // Calculate the view direction in world space
                o.viewDir = normalize(UnityWorldSpaceViewDir(v.vertex));

                o.uv = v.uv; // Pass texture coordinates
                o.color = _Color;
                o.normal = normalize(UnityObjectToWorldNormal(v.normal)); // Normalize the normal
                return o;
            }

            // Fragment function
            float4 frag(v2f i) : SV_Target {
                // Lambertian diffuse lighting with texture
                float3 lightDir = normalize(_LightDirection); // Example: Directional light direction
                float NdotL = max(0, dot(i.normal, lightDir)); // Lambertian lighting term

                float3 diffuseColor = (tex2D(_MainTex, i.uv)*_Color).rgb; // Diffuse color from texture

                // Blinn-Phong specular reflection
                float3 floatwayDir = normalize(lightDir + i.viewDir);
                float spec = pow(max(0, dot(i.normal, floatwayDir)), _SpecularExponent);
                float3 specularColor = _Specular * spec;

                // Final color calculation (Lambertian diffuse + Blinn-Phong specular)
                float3 finalColor = NdotL * diffuseColor + specularColor;

                return float4(finalColor, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
