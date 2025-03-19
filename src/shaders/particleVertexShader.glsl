//#version 300 es
precision highp float;
precision highp int;// Precisión explícita para enteros

in vec3 position;
in float size;
in vec3 customColor;

out vec3 vColor;
uniform float time;
uniform float amplitud;// param1
uniform float frecuencia;// param2
uniform float fase;// param3
uniform int behavior;
uniform float velocidad;// Nueva uniforme para la velocidad
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
out vec2 vGridIndex;// Pasar la posición de la celda a fragment shader
out vec2 vCellSize;// Pasar el tamaño de la celda
uniform vec2 gridSize;// Número de celdas en el grid (e.g., vec2(4.0, 4.0))

void main(){
    vColor=customColor;
    vec3 pos=position;
    
    // vec2 gridIndex=vec2(mod(position.x,gridSize.x),mod(position.y,gridSize.y));// Índice de celda
    // vec2 cellSize=1./gridSize;// Tamaño de cada celda
    
    // vGridIndex=gridIndex;// Pasamos el índice
    // vCellSize=cellSize;// Pasamos el tamaño
    
    gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.);
    
    if(behavior==0){
        pos.y+=velocidad*amplitud*sin(time*frecuencia+position.x+fase);
        pos.x+=velocidad*amplitud*cos(time*frecuencia+position.y+fase);
    }else if(behavior==1){
        pos.y-=velocidad*amplitud*time;
        vec3 attractionPoint=vec3(0.,0.,0.);
        vec3 direction=normalize(attractionPoint-pos);
        pos+=direction*velocidad*.1*amplitud;
    }else if(behavior==2){
        float trailFactor=velocidad*sin(time*frecuencia+position.x)*amplitud;
        pos.x+=trailFactor;
        pos.y+=cos(time*frecuencia+position.y)*amplitud;
        pos.z+=.5*velocidad*sin(time*frecuencia+position.z+fase);
    }
    
    vec4 mvPosition=modelViewMatrix*vec4(pos,1.);
    gl_PointSize=size*(300./-mvPosition.z)*amplitud;
    gl_Position=projectionMatrix*mvPosition;
}
