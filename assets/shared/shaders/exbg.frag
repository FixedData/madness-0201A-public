#pragma header




uniform float iTime;


float rand(vec2 p){
	p+=.2127+p.x+.3713*p.y;
	vec2 r=4.789*sin(789.123*(p));
	return fract(r.x*r.y);
}

float sn(vec2 p){
	vec2 i=floor(p-.5);
	vec2 f=fract(p-.5);
	f = f*f*f*(f*(f*6.0-15.0)+10.0);
	float rt=mix(rand(i),rand(i+vec2(1.,0.)),f.x);
	float rb=mix(rand(i+vec2(0.,1.)),rand(i+vec2(1.,1.)),f.x);
	return mix(rt,rb,f.y);
}

void main()
{

  vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;

	vec2 uv = fragCoord.xy / openfl_TextureSize.y;

	vec2 p=uv.xy*vec2(3.,4.3);
	float f =
	.5*sn(p)
	+.25*sn(2.*p)
	+.125*sn(4.*p)
	+.0625*sn(8.*p)
	+.03125*sn(16.*p)+
	.015*sn(32.*p)
	;
	
	float newT = iTime*0.4 + sn(vec2(iTime*1.))*0.1;
	p.x-=iTime*0.2;
	
	p.y*=1.3;
	float f2=
	.5*sn(p)
	+.25*sn(2.04*p+newT*1.1)
	-.125*sn(4.03*p-iTime*0.3)
	+.0625*sn(8.02*p-iTime*0.4)
	+.03125*sn(16.01*p+iTime*0.5)+
	.018*sn(24.02*p);
	
	float f3=
	.5*sn(p)
	+.25*sn(2.04*p+newT*1.1)
	-.125*sn(4.03*p-iTime*0.3)
	+.0625*sn(8.02*p-iTime*0.5)
	+.03125*sn(16.01*p+iTime*0.6)+
	.019*sn(18.02*p);
	
	float f4 = f2*smoothstep(0.0,1.,uv.y);
	
	vec3 clouds = mix(vec3(-0.3,-1.3,-0.95),vec3(1.000,0.000,0.000),f4*f);
	float lightning = sn((f3)+vec2(pow(sn(vec2(iTime*4.5)),6.)));

	

	lightning = smoothstep(0.76,1.5,lightning);
	
	

	

	clouds*=0.8;
	clouds += lightning  +0.2;

	float ground = smoothstep(0.07,0.075,f*(p.y-0.98)+0.01);
	
	vec2 newUV = uv;
	newUV.x-=iTime*0.3;
	newUV.y+=iTime*3.;
	float strength = sin(iTime*0.5+sn(newUV))*0.1+0.15;
	
	float rain = sn( vec2(newUV.x*20.1, newUV.y*40.1+newUV.x*400.1-20.*strength ));
	float rain2 = sn( vec2(newUV.x*45.+iTime*0.5, newUV.y*30.1+newUV.x*200.1 ));	
	rain = strength-rain;
	rain+=smoothstep(0.2,0.5,f4+lightning+0.1)*rain;
	rain += pow(length(uv),1.)*0.1;
	rain+=rain2*(sin(strength)-0.4)*2.;
	rain = clamp(rain, 0.,0.5)*0.5;
	
	float tree = 0.;
	vec2 treeUV = uv;

	{
		float atree = abs(atan(treeUV.x*59.-85.5,3.-treeUV.y*25.+5.));
		atree +=rand(treeUV.xy*vec2(0.001,1.))*atree;
		tree += clamp(atree, 0.,1.)*0.33;
	}
	{
		float atree = abs(atan(treeUV.x*65.-65.5,3.-treeUV.y*19.+4.));
		atree +=rand(treeUV.xy*vec2(0.001,1.))*atree;
		tree += clamp(atree, 0.,1.)*0.33;
	}
	{
		float atree = abs(atan(treeUV.x*85.-91.5,3.-treeUV.y*21.+4.));
		atree +=rand(treeUV.xy*vec2(0.001,1.))*atree;
		tree += clamp(atree, 0.,1.)*0.34;
	}
	
	
	
	vec3 painting = (clouds)+clamp((strength-0.1),0.,1.);
	
	float r=1.-length(max(abs(fragCoord.xy / openfl_TextureSize.xy*2.-1.)-.5,0.)); 
	painting*=r;
	
	gl_FragColor = vec4(painting, 1.);
}