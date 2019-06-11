texture gTexture;
float4 color = float4(0.2,0.2,0.2,1.0);
bool retexColor = false;  
sampler Sampler0 : register( s0 );  
  
struct PSInput 
{ 
    float4 Position     : POSITION0; 
    float2 TexCoord     : TEXCOORD0; 
    float4 Diffuse  : COLOR0; 
}; 
  
  
float4 PixelShaderFunction( PSInput PS ) : COLOR0 
{    
    float4 texColor = tex2D( Sampler0, PS.TexCoord ); 
    if (retexColor) {
        texColor *= color; 
    }
    return texColor; 
}  


technique TexReplace
{
    pass P0
    {
        Texture[0] = gTexture;
        PixelShader     = compile ps_2_0 PixelShaderFunction();
    }
}