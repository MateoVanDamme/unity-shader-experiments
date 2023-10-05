Shader"Demos/Vertex_Manipulation"
{
    Properties
    {
        _MainTexture("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        _VertexOffset("Offset", Float) = (0,0,0,0)
        _AnimationSpeed("Animation Speed", Range(0,3)) = 0
        _Amplitude("Amplitude", Range(0,10)) = 0
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vertexFunc
            #pragma fragment fragmentFunc

            #include "UnityCG.cginc"
            
            struct appdata
            {  
                float4 vertex: POSITION; 
                float2 uv: TEXCOORD0; 
            };

            struct v2f{
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0; 
            }; 

            fixed4 _Color; 
            fixed4 _VertexOffset;
            float _AnimationSpeed;
            float _Amplitude;
            sampler2D _MainTexture; 



            v2f vertexFunc(appdata IN){
                v2f OUT; 

                IN.vertex+= _VertexOffset; 
                IN.vertex.x+= sin(IN.vertex.y+ _Time.y*_AnimationSpeed)*_Amplitude;

                OUT.position =  UnityObjectToClipPos(IN.vertex); 
                OUT.uv = IN.uv; 
                return OUT; 
            }
            fixed4 fragmentFunc(v2f IN): SV_Target{
                fixed4 pixelColor = tex2D(_MainTexture, IN.uv); 
                return pixelColor* _Color; 
            }
            ENDCG
        }
    }

}