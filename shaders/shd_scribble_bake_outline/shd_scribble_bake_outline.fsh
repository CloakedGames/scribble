varying vec2 v_vTexcoord;
varying vec4 v_vColor;

uniform vec2 u_vTexel;
uniform vec3 u_vOutlineColor;
uniform int  u_iOutlineSize;

void main()
{
    vec4 outlineColor = vec4(u_vOutlineColor, 1.0);
    vec4 newColor = vec4(1.0, 1.0, 1.0, 0.0);
    
    for(int j = -u_iOutlineSize; j <= u_iOutlineSize; j++)
    {
        for(int i = -u_iOutlineSize; i <= u_iOutlineSize; i++)
        {
            if ((i != 0) || (j != 0))
            {
                newColor = mix(newColor, outlineColor, texture2D(gm_BaseTexture, v_vTexcoord + vec2(i, j)*u_vTexel).a);
            }
        }
    }
    
    vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = v_vColor*mix(newColor, sample, sample.a);
}
