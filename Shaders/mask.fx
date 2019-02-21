texture Texture0; 
texture Texture1;
float4 coef = 1;

sampler2D texSampler0 : register(s0) = sampler_state
{
    Texture  = (Texture0);
}; 
sampler2D texSampler1 : register(s1) = sampler_state
{
    Texture  = (Texture1);
};

struct PSInput 
{ 
    float4 Position     : POSITION0; 
    float2 TexCoord     : TEXCOORD0; 
    float4 Diffuse  : COLOR0; 
}; 
  

float4 PixelShaderFunction( PSInput PS ) : COLOR0 
{   
	float4 texColor = tex2D( texSampler0, PS.TexCoord );
	float4 texColor2 = tex2D( texSampler1, PS.TexCoord );
    texColor.a = texColor2.a;
    texColor.a = texColor.a * coef;
	return texColor;
} 
  
technique 
{ 
    pass P0 
    {  
        PixelShader     = compile ps_2_0 PixelShaderFunction(); 
    } 
} 