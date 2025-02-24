// ASCII shader for use with obs-shaderfilter 7/2020 v1.0
// https://github.com/Oncorporation/obs-shaderfilter
// Based on the following shaders:
// https://www.shadertoy.com/view/3dtXD8 - Created by DSWebber in 2019-10-24
// https://www.shadertoy.com/view/lssGDj - Created by movAX13h in 2013-09-22

// Modifications of original shaders include:
//  - Porting from GLSL to HLSL
//  - Combining characters sets from both source shaders
//  - Adding support for parameters from OBS for monochrome rendering, scaling and dynamic character set
//
// Add Additional Characters with this tool: http://thrill-project.com/archiv/coding/bitmap/
// converts a bitmap into int then decodes it to look like text

uniform int scale<
    string label = "Scale";
    string widget_type = "slider";
    int minimum = 1;
    int maximum = 20;
    int step = 1;
> = 1; // Size of characters
uniform float4 base_color<
    string label = "Base color";
> = {0.0,1.0,0.0,1.0}; // Monochrome base color
uniform bool monochrome<
    string label = "Monochrome";
> = false;
uniform int character_set<
  string label = "Character set";
  string widget_type = "select";
  int    option_0_value = 0;
  string option_0_label = "Large set of non-letters";
  int    option_1_value = 1;
  string option_1_label = "Small set of capital letters";
  int    option_1_value = 2;
  string option_1_label = "Custom set of symbols";
> = 0;
uniform string note<
    string widget_type = "info";
> = "Base color is used as monochrome base color.";

float character(int n, float2 p)
{
    p = floor(p*float2(4.0, 4.0) + 2.5);
    if (clamp(p.x, 0.0, 4.0) == p.x)
    {
        if (clamp(p.y, 0.0, 4.0) == p.y)	
        {
	    int a = int(round(p.x) + 5.0 * round(p.y));
            if (((n >> a) & 1) == 1) return 1.0;
        }	
    }
    return 0.0;
}

float2 mod(float2 x, float2 y)
{
    return x - y * floor(x/y);
}

float4 mainImage( VertData v_in ) : TARGET
{
    float2 iResolution = uv_size*uv_scale;
    float2 pix = v_in.pos.xy;
    float4 c = image.Sample(textureSampler, floor(pix/float2(scale*8.0,scale*8.0))*float2(scale*8.0,scale*8.0)/iResolution.xy);

    float gray = 0.3 * c.r + 0.59 * c.g + 0.11 * c.b;
	
    int n;
    int charset = clamp(character_set, 0, 2);  // adjusted clap max_val to 2 to match charsets

    if (charset==0)
    {
        if (gray <= 0.2) n = 4096;     // .
        if (gray > 0.2)  n = 65600;    // :
        if (gray > 0.3)  n = 332772;   // *
        if (gray > 0.4)  n = 15255086; // o 
        if (gray > 0.5)  n = 23385164; // &
        if (gray > 0.6)  n = 15252014; // 8
        if (gray > 0.7)  n = 13199452; // @
        if (gray > 0.8)  n = 11512810; // #
    }
    else if (charset==1)
    {
        if (gray <= 0.1) n = 0;
        if (gray > 0.1)  n = 9616687; // R
        if (gray > 0.3)  n = 32012382; // S
        if (gray > 0.5)  n = 16303663; // D
        if (gray > 0.7)  n = 15255086; // O
        if (gray > 0.8)  n = 16301615; // B
    }
	else if (charset==2) // my custom character set!
    {
        if (gray <= 0.1) n = 4096;     // .
		if (gray > 0.1)  n = 135168;   // '
		if (gray > )  n =  // 
        if (gray > 0.2)  n = 65600;    // :
		if (gray > 0.25) n = 32641183; // I
        if (gray > 0.3)  n = 332772;   // *
		if (gray > )  n =  // 
        if (gray > 0.4)  n = 15255086; // o 
		if (gray > )  n =  // 
        if (gray > 0.5)  n = 23385164; // &
		if (gray > )  n =  // 
        if (gray > 0.6)  n = 15252014; // 8
		if (gray > )  n =  // 
        if (gray > 0.7)  n = 13199452; // @
		if (gray > )  n =  // 
        if (gray > 0.8)  n = 11512810; // #
		if (gray > )  n =  // 
		if (gray > )  n =  // 
    }

    float2 p = mod(pix/float2(scale*4.0,scale*4.0),float2(2.0,2.0)) - float2(1.0,1.0);
	
    if (monochrome)
    {
        c.rgb = base_color.rgb;
    }
    c = c*character(n, p);
    
    return c;
}

/*
n =  4540401   ; // A
n =  25846424  ; // B
n =  16269839  ; // C
n =  25842328  ; // D
n =  33061407  ; // E
n =  33061392  ; // F
n =  16272975  ; // G
n =  18415153  ; // H
n =  14815374  ; // I
n =  15796548  ; // J
n =  19554962  ; // K
n =  8659214   ; // L
n =  18732593  ; // M
n =  18666927  ; // N
n =  15255086  ; // O
n =  32078352  ; // P
n =  15255151  ; // Q
n =  29979217  ; // R
n =  16267326  ; // S
n =  32641156  ; // T
n =  18400814  ; // U
n =  18400580  ; // V
n =  18405233  ; // W
n =  18157905  ; // X
n =  18157700  ; // Y
n =  32575773  ; // Z
n =  4591758   ; // 1
n =  31522335  ; // 2
n =  32554047  ; // 3
n =  18414625  ; // 4
n =  33060927  ; // 5
n =  33062463  ; // 6
n =  32538880  ; // 7
n =  33080447  ; // 8
n =  33095935  ; // 9
n =  15324974  ; // 0
n =  477775    ; // a
n =  17332830  ; // b
n =  15204878  ; // c
n =  14747239  ; // d
n =  13201934  ; // e
n =  6584584   ; // f
n =    ; // 
n =    ; // 
n =    ; // 
n =    ; // 
n =    ; // 
n =    ; // 
n =    ; // 
n =    ; // 
n =    ; // 
n =    ; // 
n =    ; // 
*/