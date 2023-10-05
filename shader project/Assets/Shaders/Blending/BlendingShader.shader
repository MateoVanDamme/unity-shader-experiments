Shader"Demos/Blending"
{
    Properties
    {
        _Texture1("Texture 1", 2D) = "white" {}
        _Texture2("Texture 2", 2D) = "black" {}
        _Direction("Coverage Direction", Vector) = (0,1,0)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vertexFunc
            #pragma fragment fragmentFunc

            #include "UnityCG.cginc"

            struct v2f{
                float4 pos: SV_POSITION;
                float3 normal: NORMAL; 
                float2 uv_Texture1: TEXCOORD0; 
                float2 uv_Texture2: TEXCOORD1; 
            }; 
            
            float3 _Direction;
            float3 normalUp = float3(0,1,0); 
            float3 normalLeft = float3(1,0,0); 

            sampler2D _Texture1; 
            float4 _Texture1_ST; 
            sampler2D _Texture2; 
            float4 _Texture2_ST; 

            v2f vertexFunc(appdata_full IN)
            {
                v2f OUT; 
                OUT.pos = UnityObjectToClipPos(IN.vertex);
                OUT.uv_Texture1 = TRANSFORM_TEX(IN.texcoord, _Texture1); 
                OUT.uv_Texture2 = TRANSFORM_TEX(IN.texcoord, _Texture2);
                OUT.normal =  UnityObjectToWorldNormal(IN.normal);
                return OUT; 
            }

            fixed4 fragmentFunc(v2f IN): COLOR{
                
                fixed dir = dot(normalize(IN.normal), normalize(_Direction)); 

                fixed4 tex1 = tex2D(_Texture1, IN.uv_Texture1); 
                fixed4 tex2 = tex2D(_Texture2, IN.uv_Texture2); 

                return lerp(tex1, tex2, dir);
            }

            ENDCG
        }
    }

}