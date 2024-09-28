
#pragma header


uniform float time;

void main()
{

    vec2 uv = openfl_TextureCoordv;


    float frequency = 2.0;        
    float amplitude = 0.1;       
    float speed = 2.0;          
     
    float wave = sin(uv.x * frequency + time * speed) * amplitude;
    float wavePosition = uv.y - 0.5 + wave;

    vec3 waveCol = vec3(0.494,0.047,0.047);
    
    vec4 bg = vec4(0.0, 0.0, 0.0, 0.0); 
    
    float blend = smoothstep(-0.4, 0.4, wavePosition); 
  
    float waveHeight = abs(wave / amplitude); 
    float alpha = 1.0 - smoothstep(0.0, 1.0, waveHeight); 
    
    vec4 col = vec4(waveCol, blend * (1.0 - smoothstep(0.0, 1.0, waveHeight)));
    

    gl_FragColor = mix(bg, col,blend);
}
